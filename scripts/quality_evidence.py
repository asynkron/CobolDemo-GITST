#!/usr/bin/env python3
"""Run the repository quality gate and emit runner-neutral Faktorial evidence."""

from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Sequence

ROOT = Path(__file__).resolve().parents[1]
PRODUCER_ID = "repository-quality"
ARTIFACT_NAME = f"{PRODUCER_ID}.quality-evidence.json"
QUALITY_COMMAND = ("make", "quality")


def complete_envelope(return_code: int) -> dict[str, object]:
    """Translate the one quality command into one exact terminal test result."""
    passed = return_code == 0
    payload: dict[str, object] = {
        "counts": {
            "total": 1,
            "passed": int(passed),
            "failed": int(not passed),
            "skipped": 0,
        },
        "failures": [],
        "omitted_failures": 0,
    }
    if not passed:
        if return_code < 0:
            outcome = f"terminated by signal {-return_code}"
        else:
            outcome = f"exited with status {return_code}"
        payload["failures"] = [
            {
                "suite": "repository-quality",
                "file": "Makefile",
                "test": "make quality",
                "message": f"make quality {outcome}",
            }
        ]
    return {
        "schema_version": "quality-evidence.v1",
        "producer_id": PRODUCER_ID,
        "kind": "test-results",
        "payload_schema": "test-results.v1",
        "status": "complete",
        "payload": payload,
    }


def translation_failed_envelope(reason: str) -> dict[str, object]:
    """Return an explicit blocking result when no exact result can be produced."""
    return {
        "schema_version": "quality-evidence.v1",
        "producer_id": PRODUCER_ID,
        "kind": "test-results",
        "payload_schema": "test-results.v1",
        "status": "translation_failed",
        "reason": reason,
    }


def write_atomic(evidence_dir: Path, envelope: dict[str, object]) -> Path:
    """Replace the declared artifact atomically inside the executor-owned dir."""
    evidence_dir.mkdir(parents=True, exist_ok=True)
    target = evidence_dir / ARTIFACT_NAME
    temporary_path: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            encoding="utf-8",
            dir=evidence_dir,
            prefix=f".{PRODUCER_ID}.",
            suffix=".tmp",
            delete=False,
        ) as temporary:
            temporary_path = Path(temporary.name)
            json.dump(envelope, temporary, ensure_ascii=False, separators=(",", ":"))
            temporary.write("\n")
            temporary.flush()
            os.fsync(temporary.fileno())
        os.replace(temporary_path, target)
    finally:
        if temporary_path is not None and temporary_path.exists():
            temporary_path.unlink()
    return target


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
        write_atomic(evidence_dir, translation_failed_envelope(reason))
        print(f"quality-evidence: {reason}", file=sys.stderr)
        return 2

    write_atomic(evidence_dir, complete_envelope(completed.returncode))
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
