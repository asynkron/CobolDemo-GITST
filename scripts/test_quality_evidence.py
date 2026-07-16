#!/usr/bin/env python3
"""Focused conformance tests for the repository quality-evidence adapter."""

from __future__ import annotations

import contextlib
import io
import json
import sys
import tempfile
import unittest
from pathlib import Path

import quality_evidence


class QualityEvidenceTests(unittest.TestCase):
    def run_in_temp(
        self, command: list[str]
    ) -> tuple[int, Path, dict[str, object], str]:
        with tempfile.TemporaryDirectory() as raw_directory:
            directory = Path(raw_directory)
            standard_error = io.StringIO()
            with contextlib.redirect_stderr(standard_error):
                exit_code = quality_evidence.run_adapter(directory, command=command)
            artifacts = list(directory.glob("*.quality-evidence.json"))
            self.assertEqual([directory / quality_evidence.ARTIFACT_NAME], artifacts)
            self.assertEqual([], list(directory.glob("*.tmp")))
            envelope = json.loads(artifacts[0].read_text(encoding="utf-8"))
            return exit_code, artifacts[0], envelope, standard_error.getvalue()

    def assert_declared_identity(self, envelope: dict[str, object]) -> None:
        self.assertEqual("quality-evidence.v1", envelope["schema_version"])
        self.assertEqual("repository-quality", envelope["producer_id"])
        self.assertEqual("test-results", envelope["kind"])
        self.assertEqual("test-results.v1", envelope["payload_schema"])

    def test_success_emits_exact_complete_counts(self) -> None:
        exit_code, _, envelope, standard_error = self.run_in_temp(
            [sys.executable, "-c", "raise SystemExit(0)"]
        )

        self.assertEqual(0, exit_code)
        self.assertEqual("", standard_error)
        self.assert_declared_identity(envelope)
        self.assertEqual("complete", envelope["status"])
        self.assertEqual(
            {"total": 1, "passed": 1, "failed": 0, "skipped": 0},
            envelope["payload"]["counts"],
        )
        self.assertEqual([], envelope["payload"]["failures"])
        self.assertEqual(0, envelope["payload"]["omitted_failures"])

    def test_command_failure_emits_stable_failed_test_identity(self) -> None:
        exit_code, _, envelope, standard_error = self.run_in_temp(
            [sys.executable, "-c", "raise SystemExit(7)"]
        )

        self.assertEqual(7, exit_code)
        self.assertEqual("", standard_error)
        self.assert_declared_identity(envelope)
        self.assertEqual("complete", envelope["status"])
        self.assertEqual(
            {"total": 1, "passed": 0, "failed": 1, "skipped": 0},
            envelope["payload"]["counts"],
        )
        self.assertEqual(
            {
                "suite": "repository-quality",
                "file": "Makefile",
                "test": "make quality",
                "message": "make quality exited with status 7",
            },
            envelope["payload"]["failures"][0],
        )

    def test_unexecutable_command_reports_translation_failure(self) -> None:
        exit_code, _, envelope, standard_error = self.run_in_temp(
            ["definitely-not-a-repository-quality-command"]
        )

        self.assertEqual(2, exit_code)
        self.assertIn("quality-evidence: could not execute make quality", standard_error)
        self.assert_declared_identity(envelope)
        self.assertEqual("translation_failed", envelope["status"])
        self.assertIn("could not execute make quality", envelope["reason"])
        self.assertNotIn("payload", envelope)

    def test_atomic_write_replaces_the_single_declared_artifact(self) -> None:
        with tempfile.TemporaryDirectory() as raw_directory:
            directory = Path(raw_directory)
            target = directory / quality_evidence.ARTIFACT_NAME
            target.write_text("stale\n", encoding="utf-8")

            quality_evidence.write_atomic(
                directory, quality_evidence.complete_envelope(0)
            )

            self.assertEqual([target], list(directory.iterdir()))
            self.assertEqual(
                "quality-evidence.v1",
                json.loads(target.read_text(encoding="utf-8"))["schema_version"],
            )

    def test_main_verify_declares_the_adapter_and_producer(self) -> None:
        config_path = quality_evidence.ROOT / ".faktorial" / "main-verify.json"
        config = json.loads(config_path.read_text(encoding="utf-8"))
        command = "python3 ./scripts/quality_evidence.py"

        self.assertEqual("main-verify.v2", config["schema_version"])
        self.assertEqual([command], config["commands"])
        self.assertEqual(
            [
                {
                    "command": command,
                    "producer_id": "repository-quality",
                    "kind": "test-results",
                    "payload_schema": "test-results.v1",
                    "required": True,
                }
            ],
            config["evidence"],
        )


if __name__ == "__main__":
    unittest.main()
