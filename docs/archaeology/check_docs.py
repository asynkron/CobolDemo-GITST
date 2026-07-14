#!/usr/bin/env python3
"""Validate local links and render Mermaid blocks in the archaeology suite."""

from __future__ import annotations

import argparse
import re
import subprocess
import tempfile
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[2]
DOCS = ROOT / "docs" / "archaeology"
LINK = re.compile(r"(?<!!)\[[^]]*]\(([^)]+)\)")
MERMAID = re.compile(r"^```mermaid\s*$\n(.*?)^```\s*$", re.MULTILINE | re.DOTALL)


def markdown_files() -> list[Path]:
    return sorted(DOCS.glob("*.md"))


def validate_links() -> None:
    failures: list[str] = []
    for source in markdown_files():
        text = source.read_text(encoding="utf-8")
        for raw in LINK.findall(text):
            target = raw.strip().split()[0].strip("<>")
            if target.startswith(("http://", "https://", "mailto:", "#")):
                continue
            relative, _, fragment = target.partition("#")
            destination = (source.parent / unquote(relative)).resolve()
            if not destination.exists():
                failures.append(f"{source.relative_to(ROOT)} -> {target}: missing target")
                continue
            if fragment and destination.suffix.lower() == ".md":
                headings = {
                    re.sub(r"[^a-z0-9 -]", "", heading.lower()).strip().replace(" ", "-")
                    for heading in re.findall(
                        r"^#{1,6}\s+(.+?)\s*$",
                        destination.read_text(encoding="utf-8"),
                        re.MULTILINE,
                    )
                }
                if unquote(fragment).lower() not in headings:
                    failures.append(f"{source.relative_to(ROOT)} -> {target}: missing heading")
    if failures:
        raise SystemExit("\n".join(failures))
    print(f"relative links: OK ({len(markdown_files())} Markdown files)")


def validate_mermaid() -> None:
    diagrams: list[tuple[Path, int, str]] = []
    for source in markdown_files():
        for index, match in enumerate(
            MERMAID.finditer(source.read_text(encoding="utf-8")), start=1
        ):
            diagrams.append((source, index, match.group(1)))
    with tempfile.TemporaryDirectory(prefix="archaeology-mermaid-") as directory:
        temporary = Path(directory)
        for sequence, (source, index, diagram) in enumerate(diagrams, start=1):
            input_path = temporary / f"diagram-{sequence}.mmd"
            output_path = temporary / f"diagram-{sequence}.svg"
            input_path.write_text(diagram, encoding="utf-8")
            try:
                subprocess.run(
                    [
                        "npx",
                        "--yes",
                        "@mermaid-js/mermaid-cli@11.12.0",
                        "--quiet",
                        "--input",
                        str(input_path),
                        "--output",
                        str(output_path),
                    ],
                    cwd=ROOT,
                    check=True,
                )
            except subprocess.CalledProcessError as error:
                raise SystemExit(
                    f"{source.relative_to(ROOT)} Mermaid block {index} failed to render"
                ) from error
    print(f"Mermaid render: OK ({len(diagrams)} diagrams)")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("check", choices=("links", "mermaid", "all"), nargs="?", default="all")
    args = parser.parse_args()
    if args.check in ("links", "all"):
        validate_links()
    if args.check in ("mermaid", "all"):
        validate_mermaid()


if __name__ == "__main__":
    main()
