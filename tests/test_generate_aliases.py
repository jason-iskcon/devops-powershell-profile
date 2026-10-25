"""Tests for tools/generate_aliases.py.

Run from the repository root:  python3 -m unittest discover -s tests -v
"""

import copy
import hashlib
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import generate_aliases as gen  # noqa: E402

GRAMMAR = gen.load_grammar(gen.DEFAULT_GRAMMAR)


FROZEN_MANIFEST = ROOT / "tests" / "k-aliases.tsv"
ADDITIONS = ROOT / "tests" / "k-additions.tsv"
# sha256 of tests/k-aliases.tsv with LF line endings, as committed with the grammar.
FROZEN_MANIFEST_SHA256 = "8473e368f8e0de1f350d2e03fdb9c06b5b6bb6d6aacb6bf2d08e7bdc46a2ed21"


def read_tsv(path: Path) -> dict[str, tuple[str, ...]]:
    """name<TAB>kubectl args per line; blank lines and # comments are skipped."""
    rows = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        if line and not line.startswith("#"):
            name, _, args = line.partition("\t")
            rows[name] = tuple(args.split())
    return rows


def with_row(**row) -> dict:
    """A copy of the grammar with one extra [[commands]] row."""
    grammar = copy.deepcopy(GRAMMAR)
    grammar["commands"].append(row)
    return grammar


class ManifestIsFrozen(unittest.TestCase):
    """tests/k-aliases.tsv is the compatibility contract for the original 788 aliases.

    New aliases go in the grammar with added = "x.y.z" and in tests/k-additions.tsv. If this
    fails, do not update the hash: move the change to k-additions.tsv.
    """

    def test_manifest_has_not_changed(self):
        text = FROZEN_MANIFEST.read_bytes().replace(b"\r\n", b"\n")
        self.assertEqual(hashlib.sha256(text).hexdigest(), FROZEN_MANIFEST_SHA256,
                         "tests/k-aliases.tsv is frozen; add new aliases to tests/k-additions.tsv")
        self.assertEqual(len(read_tsv(FROZEN_MANIFEST)), 788)


class GrammarMatchesManifests(unittest.TestCase):
    """The grammar must keep producing exactly the names that already existed, and the
    additions file must list exactly the aliases added since.

    The manifests are independent of the generator, so these catch grammar edits that add,
    drop or change an alias, which no other test would notice.
    """

    def assert_same(self, generated: dict, expected: dict, label: str):
        self.assertEqual(sorted(set(expected) - set(generated)), [], f"{label}: listed, not generated")
        self.assertEqual(sorted(set(generated) - set(expected)), [], f"{label}: generated, not listed")
        different = {n: (expected[n], generated[n]) for n in expected if expected[n] != generated[n]}
        self.assertEqual(different, {})

    def test_original_aliases_match_the_frozen_manifest(self):
        original = {a.name: a.args for a in gen.expand(GRAMMAR) if a.added is None}
        self.assert_same(original, read_tsv(FROZEN_MANIFEST), "tests/k-aliases.tsv")

    def test_added_aliases_match_the_additions_file(self):
        added = {a.name: a.args for a in gen.expand(GRAMMAR) if a.added is not None}
        self.assert_same(added, read_tsv(ADDITIONS), "tests/k-additions.tsv")

    def test_additions_cannot_change_an_original_alias(self):
        # An added row that reuses an existing name is a duplicate, not an override.
        grammar = with_row(verb="get", namespaced=False, resources=["p"], blocks=["bare"], added="2.1.0")
        with self.assertRaisesRegex(gen.GrammarError, "defined more than once: kgp"):
            gen.expand(grammar)

    def test_an_added_row_is_marked_and_does_not_disturb_the_originals(self):
        grammar = copy.deepcopy(GRAMMAR)
        grammar["blocks"]["extra"] = ["sl w"]
        grammar["commands"].append(
            dict(verb="describe", namespaced=False, resources=["p"], blocks=["extra"], added="2.1.0"))
        aliases = gen.expand(grammar)
        added = [a for a in aliases if a.added]
        self.assertEqual([(a.name, a.added) for a in added], [("kdpslw", "2.1.0")])
        original = {a.name: a.args for a in aliases if a.added is None}
        self.assertEqual(original, read_tsv(FROZEN_MANIFEST))

    def test_committed_powershell_file_is_current(self):
        committed = gen.DEFAULT_POWERSHELL.read_text(encoding="utf-8")
        self.assertEqual(committed, gen.render_powershell(gen.expand(GRAMMAR)),
                         "run: python3 tools/generate_aliases.py")


class ExpansionRules(unittest.TestCase):
    def test_aa_means_all_for_delete_and_all_namespaces_otherwise(self):
        by_name = {a.name: a.args for a in gen.expand(GRAMMAR)}
        self.assertEqual(by_name["kgpaa"], ("get", "pods", "--all-namespaces"))
        self.assertEqual(by_name["kxpaa"], ("delete", "pods", "--all"))

    def test_kube_system_prefix_comes_before_the_verb(self):
        by_name = {a.name: a.args for a in gen.expand(GRAMMAR)}
        self.assertEqual(by_name["kzgpw"], ("--namespace=kube-system", "get", "pods", "--watch"))

    def test_powershell_rendering(self):
        text = gen.render_powershell([gen.Alias("k", ()), gen.Alias("kgp", ("get", "pods"))])
        self.assertIn("function k() { & kubectl $args }\n", text)
        self.assertIn("function kgp() { & kubectl get pods $args }\n", text)


class GrammarValidation(unittest.TestCase):
    """Malformed or ambiguous grammars are rejected before anything is generated.

    PowerShell lets a later definition silently replace an earlier one (the old kgn bug),
    and k-aliases.ps1 is written without quoting, so unsafe tokens must never get through.
    """

    def broken(self, edit) -> str:
        grammar = copy.deepcopy(GRAMMAR)
        edit(grammar)
        with self.assertRaises(gen.GrammarError) as caught:
            gen.expand(grammar)
        return str(caught.exception)

    # --- ambiguous names ---
    def test_duplicate_command_row_is_an_error(self):
        message = self.broken(lambda g: g["commands"].append(copy.deepcopy(g["commands"][0])))
        self.assertIn("defined more than once", message)

    def test_alias_colliding_with_a_generated_name_is_an_error(self):
        message = self.broken(lambda g: g["aliases"].append({"name": "kgp", "args": "get pod"}))
        self.assertIn("kgp", message)

    def test_system_code_equal_to_a_verb_code_is_an_error(self):
        message = self.broken(lambda g: g["system"].update(code="g"))
        self.assertIn("also a verb code", message)

    # --- malformed entries ---
    def test_unknown_modifier_is_an_error(self):
        self.assertIn("unknown modifier 'zz'", self.broken(lambda g: g["blocks"].update(bare=["zz"])))

    def test_unknown_resource_block_and_verb_are_errors(self):
        message = self.broken(lambda g: g["commands"][0].update(resources=["nope"], blocks=["nope"], verb="zap"))
        for expected in ("unknown resource 'nope'", "unknown block 'nope'", "unknown verb 'zap'"):
            self.assertIn(expected, message)

    def test_typo_in_a_row_key_is_an_error(self):
        message = self.broken(lambda g: g["commands"][0].update(namespace=True))
        self.assertIn("unknown key 'namespace'", message)

    def test_missing_key_is_an_error(self):
        message = self.broken(lambda g: g["commands"][0].pop("namespaced"))
        self.assertIn("missing key 'namespaced'", message)

    def test_namespaced_must_be_a_boolean(self):
        self.assertIn("'namespaced' must be true or false",
                      self.broken(lambda g: g["commands"][0].update(namespaced="yes")))

    def test_unused_block_is_an_error(self):
        message = self.broken(lambda g: g["blocks"].update(orphan=["w"]))
        self.assertIn("block 'orphan' is not used", message)

    def test_malformed_and_repeated_sequences_are_errors(self):
        message = self.broken(lambda g: g["blocks"].update(bare=["", "", "W", "w  l", "w w"]))
        for expected in ("lists '' more than once", "malformed sequence 'W'",
                         "malformed sequence 'w  l'", "repeats 'w'"):
            self.assertIn(expected, message)

    def test_bad_added_version_is_an_error(self):
        message = self.broken(lambda g: g["commands"][0].update(added="soon"))
        self.assertIn("'added' must look like 1.2.3", message)

    def test_modifier_with_per_verb_table_needs_a_default(self):
        message = self.broken(lambda g: g["flags"].update(aa={"delete": "--all"}))
        self.assertIn("no 'default'", message)

    def test_unknown_top_level_key_is_an_error(self):
        self.assertIn("unknown top-level key 'extra'", self.broken(lambda g: g.update(extra={})))

    # --- unsafe output ---
    def test_tokens_that_are_unsafe_in_unquoted_powershell_are_errors(self):
        for bad in ("--x;calc", "--x|y", "$env:HOME", "--x`n", "(1)", "'q'", "a&b", "--x>out"):
            with self.subTest(token=bad):
                message = self.broken(lambda g: g["flags"].update(w=bad))
                self.assertIn("unsafe or malformed token", message)

    def test_unsafe_irregular_alias_args_and_names_are_errors(self):
        message = self.broken(lambda g: g["aliases"].append({"name": "kbad", "args": "get; calc"}))
        self.assertIn("unsafe or malformed token 'get;'", message)
        for name in ("kubectl", "Kx", "k-x", "gp", "k x"):
            with self.subTest(name=name):
                self.broken(lambda g: g["aliases"].append({"name": name, "args": "get"}))


if __name__ == "__main__":
    unittest.main()
