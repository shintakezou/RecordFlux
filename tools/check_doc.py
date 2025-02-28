#!/usr/bin/env python3

"""
Check the correctness of the documentation.

   - Make sure code examples parse / compile
   - Enforce one sentence of text per line
   - Flag mutiple consecutive and trailing whitespace
"""

from __future__ import annotations

import argparse
import enum
import os
import re
import subprocess
import sys
import tempfile
import textwrap
from pathlib import Path

from ruamel.yaml import YAML
from ruamel.yaml.parser import ParserError

from rflx.common import STDIN
from rflx.const import BASIC_STYLE_CHECKS
from rflx.lang import AnalysisContext, GrammarRule
from rflx.rapidflux import RecordFluxError
from rflx.specification import Parser, style
from rflx.specification.parser import diagnostics_to_error
from tests.const import GENERATED_DIR


class CheckDocError(Exception):
    pass


class CodeBlockType(enum.Enum):
    UNKNOWN = enum.auto()
    RFLX = enum.auto()
    ADA = enum.auto()
    PYTHON = enum.auto()
    YAML = enum.auto()
    IGNORE = enum.auto()

    def __str__(self) -> str:
        return self.name.title()


class State(enum.Enum):
    OUTSIDE = enum.auto()
    HEADER = enum.auto()
    INSIDE = enum.auto()
    EMPTY = enum.auto()


class StyleChecker:
    def __init__(self, filename: Path):
        self._filename = filename
        self._previous: tuple[int, str] | None = None
        self._headings_re = re.compile(r"^(=+|-+|~+|\^+|\*+|\"+)$")

    def check(self, lineno: int, line: str) -> None:
        if not self._previous:
            self._previous = lineno, line
            return

        previous_lineno, previous_line = self._previous
        self._previous = lineno, line

        # No trailing whitespace
        if re.match(r".* $", previous_line) is not None:
            raise CheckDocError(f"{self._filename}:{previous_lineno}: trailing whitespace")

        if self._skip(line, previous_line, previous_lineno):
            return

        # Trailing punctuations
        if re.match(r"\S.*[.:?]$", previous_line) is None:
            raise CheckDocError(f"{self._filename}:{previous_lineno}: no trailing punctuation")

        # No multiple consecutive whitespace
        if "  " in previous_line:
            raise CheckDocError(
                f"{self._filename}:{previous_lineno}: multiple consecutive whitespace",
            )

        # No punctuation inside a line
        if re.match(r".*[.?!] [A-Z]", previous_line) is not None:
            raise CheckDocError(
                f"{self._filename}:{previous_lineno}: multiple sentences on one line",
            )

    def finish(self) -> None:
        if self._previous:
            # Handle final line
            self.check(*self._previous)

    def _skip(self, line: str, previous_line: str, previous_lineno: int) -> bool:
        # Headings
        if self._headings_re.match(line):
            if re.match(r"^$", previous_line):
                return True
            if len(line) != len(previous_line):
                raise CheckDocError(
                    f"{self._filename}:{previous_lineno}: "
                    "heading marker length does not match heading length",
                )
            return True

        # Empty lines
        if re.match(r"^$", previous_line):
            return True

        # Lines without spaces
        if " " not in previous_line:
            return True

        # Sphinx directives
        if re.match(r"^(\.\.|- |\s+|\*\*)", previous_line):
            return True

        # Template elements
        if re.match(r"{[^}]*}", previous_line):
            return True

        return False


class CodeChecker:
    def __init__(self, filename: Path):
        self._filename = filename

    def check(
        self,
        lineno: int | None,
        block: str,
        code_type: CodeBlockType | None,
        indent: int,
        subtype: str | None = None,
    ) -> None:
        assert lineno
        # Remove trailing empty line as this is an error for RecordFlux style checks. It could be
        # filtered out in the code block parser, but that would complicate things significantly.
        block = textwrap.indent(textwrap.dedent(block).rstrip("\n"), indent * " ")
        try:
            if code_type == CodeBlockType.IGNORE:
                pass
            elif code_type == CodeBlockType.RFLX:
                self._check_rflx(block, subtype)
            elif code_type == CodeBlockType.ADA:
                self._check_ada(block, subtype)
            elif code_type == CodeBlockType.PYTHON:
                self._check_python(block)
            elif code_type == CodeBlockType.YAML:
                self._check_yaml(block)
            elif code_type == CodeBlockType.UNKNOWN:
                # ignore code blocks of unknown type
                pass
            else:
                raise NotImplementedError(f"Unsupported code type: {code_type}\n{block}")
        except CheckDocError as error:
            raise CheckDocError(
                f"{self._filename}:{lineno}: error in code block\n{error}",
            ) from error

    def _check_rflx(self, block: str, subtype: str | None = None) -> None:
        try:
            if subtype is None:
                parser = Parser()
                parser.parse_string(block)
                parser.create_model()
            else:
                if not hasattr(GrammarRule, f"{subtype}_rule"):
                    raise CheckDocError(f'invalid code block subtype "{subtype}"')
                parse(data=block, rule=getattr(GrammarRule, f"{subtype}_rule"))
        except RecordFluxError as rflx_error:
            raise CheckDocError(str(rflx_error)) from rflx_error

    def _check_ada(self, block: str, subtype: str | None = None) -> None:
        args = []
        unit = "main"

        if subtype is None:
            data = block
        elif subtype == "declaration":
            data = f"procedure {unit.title()} is {block} begin null; end {unit.title()};"
        elif subtype == "api":
            args = ["-gnats", "-gnaty", "-gnatwe"]
            formated_block = textwrap.indent(textwrap.dedent(block), "   ")
            data = f"package {unit.title()} is\n{formated_block}\nend {unit.title()};"
        else:
            raise CheckDocError(f"invalid Ada subtype '{subtype}'")

        with tempfile.TemporaryDirectory() as tmpdirname:
            tmpdir = Path(tmpdirname).resolve()

            (tmpdir / f"{unit}.adb").write_text(data, encoding="utf-8")
            os.symlink(GENERATED_DIR.resolve(), tmpdir / "generated", target_is_directory=True)

            result = subprocess.run(
                [
                    "gprbuild",
                    "-j0",
                    "--no-project",
                    "-q",
                    "-u",
                    "--src-subdirs=generated",
                    unit,
                    *args,
                ],
                check=False,
                capture_output=True,
                encoding="utf-8",
                cwd=tmpdir,
            )
            try:
                result.check_returncode()
            except subprocess.CalledProcessError as gprbuild_error:
                raise CheckDocError(result.stderr) from gprbuild_error

    def _check_python(self, block: str) -> None:
        with tempfile.TemporaryDirectory() as tmpdirname:
            tmpdir = Path(tmpdirname)
            filename = tmpdir / "test.py"
            filename.write_text(block, encoding="utf-8")

            result = subprocess.run(
                ["python3", filename],
                check=False,
                capture_output=True,
                encoding="utf-8",
            )
            try:
                result.check_returncode()
            except subprocess.CalledProcessError as python_error:
                raise CheckDocError(result.stderr) from python_error

    def _check_yaml(self, block: str) -> None:
        yaml = YAML(typ="safe")
        try:
            yaml.load(block)
        except ParserError as yaml_error:
            raise CheckDocError(f"{yaml_error}") from yaml_error


def parse_code_block_type(type_str: str) -> CodeBlockType:
    normalized = type_str.lower()
    types = {
        "rflx": CodeBlockType.RFLX,
        "ada": CodeBlockType.ADA,
        "python": CodeBlockType.PYTHON,
        "yaml": CodeBlockType.YAML,
        "ignore": CodeBlockType.IGNORE,
    }
    if normalized not in types:
        return CodeBlockType.UNKNOWN
    return types[normalized]


def check_file(filename: Path, content: str) -> bool:  # noqa: PLR0912, PLR0915
    found = False
    state = State.OUTSIDE
    block = ""
    block_start: int | None = None
    doc_check_type: CodeBlockType | None = None
    indent: int = 0
    subtype: str | None = None
    style_checker = StyleChecker(filename)
    code_checker = CodeChecker(filename)

    for lineno, line in enumerate(content.splitlines(), start=1):
        style_checker.check(lineno, line)

        if state == State.INSIDE:
            match = re.match(r"^\S", line)
            if match:
                code_checker.check(block_start, block, doc_check_type, indent, subtype)
                state = State.OUTSIDE
                doc_check_type = None
                indent = 0
                subtype = None
                block_start = None
                block = ""
                found = True
            else:
                block += f"{line}\n"

            # fall-through: continue matching this line as it may already be the start of
            # the next block

        match = re.match(r"^\s*\.\. code-block::", line)
        if match:
            raise CheckDocError(
                f"{filename}:{lineno}: code-block directive forbidden (use 'code::' instead)",
            )

        match = re.match(r"^\s*\.\. doc-check: (?P<type>\S+)\s*$", line)
        if match:
            state = State.HEADER
            check = match.group("type").split(",")
            doc_check_type = parse_code_block_type(check[0])
            if doc_check_type == CodeBlockType.UNKNOWN:
                raise CheckDocError(f'{filename}:{lineno}: invalid doc-check type "{check[0]}"')
            if len(check) > 1:
                subtype = check[1]

                # Indent by 3 by default if a subtype is give but no indentation.
                # Most often we test type declaration for which 3 is a valid indentation.
                indent = int(check[2]) if len(check) > 2 else 3

            continue

        match = re.match(r"^\s*\.\. code:: (?P<tag>\S+)\s*$", line)
        if match:
            code_type = parse_code_block_type(match.group("tag"))
            if doc_check_type:
                if doc_check_type not in (CodeBlockType.IGNORE, code_type):
                    raise CheckDocError(
                        f"{filename}:{lineno}: "
                        "inconsistent code block type "
                        f"(block: {code_type}, doc: {doc_check_type})",
                    )
            else:
                doc_check_type = code_type

            state = State.HEADER
            continue

        if state == State.HEADER:
            if re.match(r"^ +:[^:]+:$", line):
                continue

            match = re.match("^$", line)
            if not match:
                raise CheckDocError(f"{filename}:{lineno}: missing empty line in code block")

            block_start = lineno
            state = State.INSIDE
            continue

    if state == State.INSIDE:
        code_checker.check(block_start, block, doc_check_type, indent, subtype)
        found = True

    style_checker.finish()

    return found


def check_files(files: list[Path]) -> None:
    found = False

    for filename in files:
        # Avoid inclusion of byte order mark: https://stackoverflow.com/a/49150749
        found = check_file(filename, filename.read_text(encoding="utf-8-sig")) or found

    if not found:
        files_str = ", ".join(str(f) for f in files)
        raise CheckDocError(f"No code blocks found (checked {files_str})")


def parse(data: str, rule: str) -> None:
    unit = AnalysisContext().get_from_buffer("<stdin>", data, rule=rule)
    error = RecordFluxError()
    if diagnostics_to_error(unit.diagnostics, error, STDIN):
        error.propagate()
    style.check_string(error, data, BASIC_STYLE_CHECKS)
    error.propagate()


def main() -> None:
    argument_parser = argparse.ArgumentParser()
    argument_parser.add_argument(
        "-d",
        "--dir",
        type=Path,
        required=True,
        help="Directory to check recursively",
    )
    argument_parser.add_argument("-x", "--exclude", type=Path, nargs="*", help="File to exclude")
    arguments = argument_parser.parse_args()

    exclude = arguments.exclude or []

    try:
        check_files([doc for doc in Path(arguments.dir).glob("**/*.rst") if doc not in exclude])
    except CheckDocError as e:
        sys.exit(f"{e}")


if __name__ == "__main__":
    main()
