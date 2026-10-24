"""Tests for tools/generate_aliases.py.

Run from the repository root:  python3 -m unittest discover -s tests -v
"""

import copy
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import generate_aliases as gen  # noqa: E402

GRAMMAR = gen.load_grammar(gen.DEFAULT_GRAMMAR)


def read_manifest() -> dict[str, tuple[str, ...]]:
    """tests/k-aliases.tsv: name<TAB>kubectl args, extracted from the pre-grammar profile."""
    manifest = {}
    for line in (ROOT / "tests" / "k-aliases.tsv").read_text(encoding="utf-8").splitlines():
        name, _, args = line.partition("\t")
        manifest[name] = tuple(args.split())
    return manifest


class GrammarMatchesManifest(unittest.TestCase):
    """The grammar must keep producing exactly the names that already existed.

    The manifest is independent of the generator, so this catches grammar edits that
    add, drop or change an alias, which no other test would notice.
    """

    def test_same_names_and_arguments(self):
        generated = {a.name: a.args for a in gen.expand(GRAMMAR)}
        manifest = read_manifest()
        self.assertEqual(sorted(set(manifest) - set(generated)), [], "in manifest, not generated")
        self.assertEqual(sorted(set(generated) - set(manifest)), [], "generated, not in manifest")
        different = {n: (manifest[n], generated[n]) for n in manifest if manifest[n] != generated[n]}
        self.assertEqual(different, {})

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
    """PowerShell lets a later definition silently replace an earlier one (the old kgn bug)."""

    def test_duplicate_name_is_an_error(self):
        broken = copy.deepcopy(GRAMMAR)
        broken["commands"].append(copy.deepcopy(broken["commands"][0]))
        with self.assertRaisesRegex(gen.GrammarError, "defined more than once"):
            gen.expand(broken)

    def test_alias_colliding_with_a_generated_name_is_an_error(self):
        broken = copy.deepcopy(GRAMMAR)
        broken["aliases"].append({"name": "kgp", "args": "get pod"})
        with self.assertRaisesRegex(gen.GrammarError, "kgp"):
            gen.expand(broken)

    def test_unknown_modifier_is_an_error(self):
        broken = copy.deepcopy(GRAMMAR)
        broken["blocks"]["bare"] = ["zz"]
        with self.assertRaisesRegex(gen.GrammarError, "unknown modifier 'zz'"):
            gen.expand(broken)


if __name__ == "__main__":
    unittest.main()
