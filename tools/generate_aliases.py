#!/usr/bin/env python3
"""Expand k-grammar.toml into the kubectl alias files.

    python3 tools/generate_aliases.py           # write k-aliases.ps1
    python3 tools/generate_aliases.py --check   # fail if k-aliases.ps1 is out of date

Requires Python 3.11+ (tomllib). Standard library only.
"""

from __future__ import annotations

import argparse
import re
import sys
import tomllib
from collections import Counter
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_GRAMMAR = ROOT / "k-grammar.toml"
DEFAULT_POWERSHELL = ROOT / "k-aliases.ps1"

POWERSHELL_HEADER = """\
# GENERATED FILE - do not edit.
# Source: k-grammar.toml
# Regenerate: python3 tools/generate_aliases.py
# Naming scheme: see README.md ("Kubectl - The K System").
"""

# Alias and function names: "k" plus lowercase letters. Anything else would not be a safe
# function name in every shell.
NAME_RE = re.compile(r"k[a-z]*")
# "kubectl" would make the generated function call itself.
RESERVED_NAMES = frozenset({"kubectl"})
CODE_RE = re.compile(r"[a-z]+")
WORD_RE = re.compile(r"[a-z]+")
# The PowerShell file is written without quoting, so every argument token must be inert there
# (no spaces, quotes, $, `, ;, |, & or parentheses). The POSIX output quotes tokens as well,
# but this is the one check that protects both.
TOKEN_RE = re.compile(r"-{0,2}[A-Za-z0-9][A-Za-z0-9._=:/,@+%-]*")
SEQUENCE_RE = re.compile(r"([a-z]+( [a-z]+)*)?")
# Version in which an alias was added; aliases without it are the original 788.
ADDED_RE = re.compile(r"\d+\.\d+\.\d+")

TOP_LEVEL_KEYS = {"system", "verbs", "resources", "flags", "blocks", "commands", "aliases"}
COMMAND_KEYS = {"verb", "namespaced", "resources", "blocks", "added"}
ALIAS_KEYS = {"name", "args", "added"}


class GrammarError(ValueError):
    """The grammar file is inconsistent."""


@dataclass(frozen=True)
class Alias:
    name: str
    args: tuple[str, ...]  # everything that follows "kubectl"
    added: str | None = None  # None for the original aliases, else the version that added it


def load_grammar(path: Path) -> dict:
    with path.open("rb") as f:
        return tomllib.load(f)


def _is_str_list(value: object) -> bool:
    return isinstance(value, list) and all(isinstance(v, str) for v in value)


def validate(grammar: dict) -> list[str]:
    """Return every structural problem in the grammar (empty when it is well formed).

    Checks shape, types, unknown keys and references, and that every token that will be
    written into a generated file is inert. Name collisions are checked by expand().
    """
    problems: list[str] = []

    for key in sorted(set(grammar) - TOP_LEVEL_KEYS):
        problems.append(f"unknown top-level key {key!r}")
    for key in sorted(TOP_LEVEL_KEYS - set(grammar)):
        problems.append(f"missing top-level key {key!r}")
    if problems:
        return problems

    # --- vocabularies -------------------------------------------------------------------
    system = grammar["system"]
    if not isinstance(system, dict) or set(system) != {"code", "args"}:
        problems.append("[system] must have exactly 'code' and 'args'")
        return problems
    if not (isinstance(system["code"], str) and CODE_RE.fullmatch(system["code"])):
        problems.append(f"[system] code {system['code']!r} must be lowercase letters")
    problems += _check_tokens(system["args"], "[system] args")

    for table, what in (("verbs", "verb"), ("resources", "resource")):
        for code, word in grammar[table].items():
            if not CODE_RE.fullmatch(code):
                problems.append(f"{what} code {code!r} must be lowercase letters")
            if not (isinstance(word, str) and WORD_RE.fullmatch(word)):
                problems.append(f"{what} {code!r} has a bad expansion {word!r}")
    if system["code"] in grammar["verbs"]:
        problems.append(f"[system] code {system['code']!r} is also a verb code, so names would be ambiguous")
    if len(set(grammar["verbs"].values())) != len(grammar["verbs"]):
        problems.append("two verb codes expand to the same verb")

    for code, spec in grammar["flags"].items():
        if not CODE_RE.fullmatch(code):
            problems.append(f"modifier code {code!r} must be lowercase letters")
        if isinstance(spec, dict):
            if "default" not in spec:
                problems.append(f"modifier {code!r} has per-verb expansions but no 'default'")
            for verb in set(spec) - {"default"}:
                if verb not in grammar["verbs"].values():
                    problems.append(f"modifier {code!r} names unknown verb {verb!r}")
            specs = list(spec.values())
        else:
            specs = [spec]
        for text in specs:
            problems += _check_tokens(text, f"modifier {code!r}")

    # --- blocks -------------------------------------------------------------------------
    for name, seqs in grammar["blocks"].items():
        if not _is_str_list(seqs) or not seqs:
            problems.append(f"block {name!r} must be a non-empty list of strings")
            continue
        for dup in sorted(s for s, n in Counter(seqs).items() if n > 1):
            problems.append(f"block {name!r} lists {dup!r} more than once")
        for seq in seqs:
            if not SEQUENCE_RE.fullmatch(seq):
                problems.append(f"block {name!r}: malformed sequence {seq!r}")
                continue
            codes = seq.split()
            for repeated in sorted(c for c, n in Counter(codes).items() if n > 1):
                problems.append(f"block {name!r}: sequence {seq!r} repeats {repeated!r}")
            for code in codes:
                if code not in grammar["flags"]:
                    problems.append(f"unknown modifier {code!r} in block {name!r}")

    # --- command rows -------------------------------------------------------------------
    used_blocks: set[str] = set()
    for i, row in enumerate(grammar["commands"], 1):
        where = f"[[commands]] #{i}"
        if not isinstance(row, dict):
            problems.append(f"{where} is not a table")
            continue
        for key in sorted(set(row) - COMMAND_KEYS):
            problems.append(f"{where}: unknown key {key!r}")
        for key in sorted({"verb", "namespaced", "resources", "blocks"} - set(row)):
            problems.append(f"{where}: missing key {key!r}")
        if row.get("verb") not in grammar["verbs"].values():
            problems.append(f"{where}: unknown verb {row.get('verb')!r}")
        if not isinstance(row.get("namespaced"), bool):
            problems.append(f"{where}: 'namespaced' must be true or false")
        for key, known, what in (("resources", grammar["resources"], "resource"),
                                 ("blocks", grammar["blocks"], "block")):
            values = row.get(key)
            if not _is_str_list(values) or not values:
                problems.append(f"{where}: {key!r} must be a non-empty list of strings")
                continue
            for dup in sorted(v for v, n in Counter(values).items() if n > 1):
                problems.append(f"{where}: {key!r} lists {dup!r} more than once")
            for value in values:
                # "" (no resource) is allowed for resources only.
                if not (key == "resources" and value == "") and value not in known:
                    problems.append(f"{where}: unknown {what} {value!r}")
            if key == "blocks":
                used_blocks.update(values)
        if "added" in row and not (isinstance(row["added"], str) and ADDED_RE.fullmatch(row["added"])):
            problems.append(f"{where}: 'added' must look like 1.2.3")
    for name in sorted(set(grammar["blocks"]) - used_blocks):
        problems.append(f"block {name!r} is not used by any [[commands]] row")

    # --- irregular aliases --------------------------------------------------------------
    for i, alias in enumerate(grammar["aliases"], 1):
        where = f"[[aliases]] #{i}"
        if not isinstance(alias, dict):
            problems.append(f"{where} is not a table")
            continue
        for key in sorted(set(alias) - ALIAS_KEYS):
            problems.append(f"{where}: unknown key {key!r}")
        for key in sorted({"name", "args"} - set(alias)):
            problems.append(f"{where}: missing key {key!r}")
        problems += _check_name(alias.get("name"), where)
        problems += _check_tokens(alias.get("args"), f"{where} args")
        if "added" in alias and not (isinstance(alias["added"], str) and ADDED_RE.fullmatch(alias["added"])):
            problems.append(f"{where}: 'added' must look like 1.2.3")

    return problems


def _check_name(name: object, where: str) -> list[str]:
    if not (isinstance(name, str) and NAME_RE.fullmatch(name)):
        return [f"{where}: name {name!r} must be 'k' followed by lowercase letters"]
    if name in RESERVED_NAMES:
        return [f"{where}: name {name!r} is reserved"]
    return []


def _check_tokens(text: object, what: str) -> list[str]:
    if not isinstance(text, str):
        return [f"{what} must be a string"]
    return [f"{what}: unsafe or malformed token {t!r}" for t in text.split() if not TOKEN_RE.fullmatch(t)]


def _flag_tokens(flags: dict, code: str, verb: str) -> list[str]:
    spec = flags[code]
    if isinstance(spec, dict):
        spec = spec.get(verb, spec["default"])
    return spec.split()


def expand(grammar: dict) -> list[Alias]:
    """Return every alias the grammar defines, irregular aliases first.

    Raises GrammarError if the grammar is malformed (see validate) or if any name is
    defined more than once (PowerShell silently lets a later definition override an
    earlier one).
    """
    problems = validate(grammar)
    if problems:
        raise GrammarError("; ".join(problems))

    verb_codes = {word: code for code, word in grammar["verbs"].items()}
    resources: dict[str, str] = grammar["resources"]
    flags: dict = grammar["flags"]
    blocks: dict[str, list[str]] = grammar["blocks"]
    system_code: str = grammar["system"]["code"]
    system_args: list[str] = grammar["system"]["args"].split()

    aliases = [Alias(a["name"], tuple(a["args"].split()), a.get("added")) for a in grammar["aliases"]]

    for row in grammar["commands"]:
        verb = row["verb"]
        verb_code = verb_codes[verb]
        prefix = "k" + (system_code if row["namespaced"] else "")
        lead = system_args if row["namespaced"] else []
        for res_code in row["resources"]:
            res_words = [resources[res_code]] if res_code else []
            for block in row["blocks"]:
                for seq in blocks[block]:
                    codes = seq.split()
                    tokens = [t for c in codes for t in _flag_tokens(flags, c, verb)]
                    name = prefix + verb_code + res_code + "".join(codes)
                    problems += _check_name(name, f"{verb} {res_code!r} {seq!r}")
                    aliases.append(Alias(name, tuple(lead + [verb] + res_words + tokens), row.get("added")))

    if problems:
        raise GrammarError("; ".join(problems))
    duplicates = sorted(n for n, count in Counter(a.name for a in aliases).items() if count > 1)
    if duplicates:
        raise GrammarError("defined more than once: " + ", ".join(duplicates))
    return aliases


def render_powershell(aliases: list[Alias]) -> str:
    lines = [POWERSHELL_HEADER]
    for a in aliases:
        args = " ".join(("kubectl",) + a.args)
        lines.append(f"function {a.name}() {{ & {args} $args }}\n")
    return "".join(lines)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--grammar", type=Path, default=DEFAULT_GRAMMAR)
    parser.add_argument("--powershell", type=Path, default=DEFAULT_POWERSHELL,
                        help="output path (default: k-aliases.ps1)")
    parser.add_argument("--check", action="store_true",
                        help="do not write; exit 1 if the output file is out of date")
    args = parser.parse_args(argv)

    try:
        aliases = expand(load_grammar(args.grammar))
    except GrammarError as e:
        print(f"error: {args.grammar}: {e}", file=sys.stderr)
        return 2

    text = render_powershell(aliases)
    if args.check:
        current = args.powershell.read_text(encoding="utf-8") if args.powershell.exists() else None
        if current != text:
            print(f"{args.powershell} is out of date; run python3 tools/generate_aliases.py",
                  file=sys.stderr)
            return 1
        return 0

    args.powershell.write_text(text, encoding="utf-8", newline="\n")
    print(f"wrote {args.powershell} ({len(aliases)} aliases)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
