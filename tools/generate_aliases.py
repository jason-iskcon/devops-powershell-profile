#!/usr/bin/env python3
"""Expand k-grammar.toml into the kubectl alias files.

    python3 tools/generate_aliases.py           # write k-aliases.ps1
    python3 tools/generate_aliases.py --check   # fail if k-aliases.ps1 is out of date

Requires Python 3.11+ (tomllib). Standard library only.
"""

from __future__ import annotations

import argparse
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


class GrammarError(ValueError):
    """The grammar file is inconsistent."""


@dataclass(frozen=True)
class Alias:
    name: str
    args: tuple[str, ...]  # everything that follows "kubectl"


def load_grammar(path: Path) -> dict:
    with path.open("rb") as f:
        return tomllib.load(f)


def _lookup(table: dict, key: str, what: str, context: str):
    try:
        return table[key]
    except KeyError:
        raise GrammarError(f"unknown {what} {key!r} in {context}") from None


def _flag_tokens(flags: dict, code: str, verb: str, context: str) -> list[str]:
    spec = _lookup(flags, code, "modifier", context)
    if isinstance(spec, dict):
        spec = spec.get(verb, spec["default"])
    return spec.split()


def expand(grammar: dict) -> list[Alias]:
    """Return every alias the grammar defines, irregular aliases first.

    Raises GrammarError for unknown codes and for any name defined more than once
    (PowerShell silently lets a later definition override an earlier one).
    """
    verbs: dict[str, str] = grammar["verbs"]
    verb_codes = {word: code for code, word in verbs.items()}
    resources: dict[str, str] = grammar["resources"]
    flags: dict = grammar["flags"]
    blocks: dict[str, list[str]] = grammar["blocks"]
    system_code: str = grammar["system"]["code"]
    system_args: list[str] = grammar["system"]["args"].split()

    aliases = [Alias(a["name"], tuple(a["args"].split())) for a in grammar["aliases"]]

    for row in grammar["commands"]:
        verb = row["verb"]
        verb_code = _lookup(verb_codes, verb, "verb", "[[commands]]")
        prefix = "k" + (system_code if row["namespaced"] else "")
        lead = system_args if row["namespaced"] else []
        for res_code in row["resources"]:
            context = f"{verb} {res_code!r}"
            res_words = [_lookup(resources, res_code, "resource", context)] if res_code else []
            for block in row["blocks"]:
                for seq in _lookup(blocks, block, "block", context):
                    codes = seq.split()
                    tokens = [t for c in codes for t in _flag_tokens(flags, c, verb, context)]
                    aliases.append(
                        Alias(
                            prefix + verb_code + res_code + "".join(codes),
                            tuple(lead + [verb] + res_words + tokens),
                        )
                    )

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
