#!/usr/bin/env python3
"""Run the repository quality gate and emit native Faktorial test evidence."""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Sequence

ROOT = Path(__file__).resolve().parents[1]
PRODUCER_ID = "repository-quality"
ARTIFACT_NAME = f"{PRODUCER_ID}.junit.xml"
MANIFEST_NAME = "producers.json"
QUALITY_COMMAND = ("make", "quality")


def complete_report(return_code: int) -> bytes:
    """Translate the quality command into one exact terminal JUnit result."""
    failed = return_code != 0
    counts = {
        "tests": "1",
        "failures": str(int(failed)),
        "errors": "0",
        "skipped": "0",
    }
    document = ET.Element("testsuites", counts)
    suite = ET.SubElement(document, "testsuite", {"name": PRODUCER_ID, **counts})
    case = ET.SubElement(
        suite,
        "testcase",
        {
            "classname": PRODUCER_ID,
            "file": "Makefile",
            "name": "make quality",
        },
    )
    if failed:
        if return_code < 0:
            outcome = f"terminated by signal {-return_code}"
        else:
            outcome = f"exited with status {return_code}"
        message = f"make quality {outcome}"
        failure = ET.SubElement(
            case,
            "failure",
            {"message": message, "type": "quality-command"},
        )
        failure.text = message
    return ET.tostring(document, encoding="utf-8", xml_declaration=True) + b"\n"


def translation_failure_report(reason: str) -> bytes:
    """Emit deliberately untranslatable native output with a bounded reason."""
    clean_reason = " ".join(reason.split())[:4000]
    return f"quality-evidence translation failed: {clean_reason}\n".encode("utf-8")


def producer_manifest() -> bytes:
    """Mark the sole declared producer as started for strict reconciliation."""
    manifest = {"started": [PRODUCER_ID], "categories": []}
    return (json.dumps(manifest, separators=(",", ":")) + "\n").encode("utf-8")


def write_atomic(evidence_dir: Path, name: str, content: bytes) -> Path:
    """Replace one native evidence file atomically inside the executor-owned dir."""
    evidence_dir.mkdir(parents=True, exist_ok=True)
    target = evidence_dir / name
    temporary_path: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="wb",
            dir=evidence_dir,
            prefix=f".{name}.",
            suffix=".tmp",
            delete=False,
        ) as temporary:
            temporary_path = Path(temporary.name)
            temporary.write(content)
            temporary.flush()
            os.fsync(temporary.fileno())
        os.replace(temporary_path, target)
    finally:
        if temporary_path is not None and temporary_path.exists():
            temporary_path.unlink()
    return target


def write_evidence(evidence_dir: Path, report: bytes) -> None:
    """Write the native report and scope manifest without partial files."""
    write_atomic(evidence_dir, ARTIFACT_NAME, report)
    write_atomic(evidence_dir, MANIFEST_NAME, producer_manifest())


def run_adapter(
    evidence_dir: Path,
    command: Sequence[str] = QUALITY_COMMAND,
    cwd: Path = ROOT,
) -> int:
    """Run a fresh quality command, emit evidence, and preserve its exit status."""
    try:
        completed = subprocess.run(command, cwd=cwd, check=False)
    except OSError as error:
        reason = f"could not execute make quality: {error}"
        write_evidence(evidence_dir, translation_failure_report(reason))
        print(f"quality-evidence: {reason}", file=sys.stderr)
        return 2

    write_evidence(evidence_dir, complete_report(completed.returncode))
    if completed.returncode < 0:
        return 128 + (-completed.returncode)
    return completed.returncode


def main() -> int:
    evidence_dir = os.environ.get("FAKTORIAL_QUALITY_EVIDENCE_DIR", "").strip()
    if not evidence_dir:
        print(
            "quality-evidence: FAKTORIAL_QUALITY_EVIDENCE_DIR is required",
            file=sys.stderr,
        )
        return 2
    return run_adapter(Path(evidence_dir))


if __name__ == "__main__":
    raise SystemExit(main())
