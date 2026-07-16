#!/usr/bin/env python3
"""Focused conformance tests for the repository quality-evidence adapter."""

from __future__ import annotations

import contextlib
import io
import json
import sys
import tempfile
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path

import quality_evidence


class QualityEvidenceTests(unittest.TestCase):
    def run_in_temp(
        self, command: list[str]
    ) -> tuple[int, bytes, dict[str, object], str]:
        with tempfile.TemporaryDirectory() as raw_directory:
            directory = Path(raw_directory)
            standard_error = io.StringIO()
            with contextlib.redirect_stderr(standard_error):
                exit_code = quality_evidence.run_adapter(directory, command=command)
            self.assertEqual(
                [
                    quality_evidence.MANIFEST_NAME,
                    quality_evidence.ARTIFACT_NAME,
                ],
                sorted(path.name for path in directory.iterdir()),
            )
            report = (directory / quality_evidence.ARTIFACT_NAME).read_bytes()
            manifest = json.loads(
                (directory / quality_evidence.MANIFEST_NAME).read_text(
                    encoding="utf-8"
                )
            )
            return exit_code, report, manifest, standard_error.getvalue()

    def assert_manifest(self, manifest: dict[str, object]) -> None:
        self.assertEqual(
            {"started": ["repository-quality"], "categories": []}, manifest
        )

    def parse_report(self, report: bytes) -> tuple[ET.Element, ET.Element]:
        document = ET.fromstring(report)
        suite = document.find("testsuite")
        self.assertIsNotNone(suite)
        return document, suite

    def test_success_emits_exact_complete_counts(self) -> None:
        exit_code, report, manifest, standard_error = self.run_in_temp(
            [sys.executable, "-c", "raise SystemExit(0)"]
        )

        self.assertEqual(0, exit_code)
        self.assertEqual("", standard_error)
        self.assert_manifest(manifest)
        document, suite = self.parse_report(report)
        expected_counts = {
            "tests": "1",
            "failures": "0",
            "errors": "0",
            "skipped": "0",
        }
        self.assertEqual(expected_counts, document.attrib)
        self.assertEqual(
            {"name": "repository-quality", **expected_counts}, suite.attrib
        )
        case = suite.find("testcase")
        self.assertIsNotNone(case)
        self.assertEqual("repository-quality", case.attrib["classname"])
        self.assertEqual("Makefile", case.attrib["file"])
        self.assertEqual("make quality", case.attrib["name"])
        self.assertIsNone(case.find("failure"))

    def test_command_failure_emits_stable_failed_test_identity(self) -> None:
        exit_code, report, manifest, standard_error = self.run_in_temp(
            [sys.executable, "-c", "raise SystemExit(7)"]
        )

        self.assertEqual(7, exit_code)
        self.assertEqual("", standard_error)
        self.assert_manifest(manifest)
        _, suite = self.parse_report(report)
        self.assertEqual("1", suite.attrib["tests"])
        self.assertEqual("1", suite.attrib["failures"])
        case = suite.find("testcase")
        self.assertEqual("make quality", case.attrib["name"])
        self.assertEqual("Makefile", case.attrib["file"])
        failure = case.find("failure")
        self.assertEqual("quality-command", failure.attrib["type"])
        self.assertEqual(
            "make quality exited with status 7", failure.attrib["message"]
        )
        self.assertEqual("make quality exited with status 7", failure.text)

    def test_unexecutable_command_reports_translation_failure(self) -> None:
        exit_code, report, manifest, standard_error = self.run_in_temp(
            ["definitely-not-a-repository-quality-command"]
        )

        self.assertEqual(2, exit_code)
        self.assertIn("quality-evidence: could not execute make quality", standard_error)
        self.assert_manifest(manifest)
        self.assertIn(b"could not execute make quality", report)
        with self.assertRaises(ET.ParseError):
            ET.fromstring(report)

    def test_atomic_write_replaces_only_the_declared_native_files(self) -> None:
        with tempfile.TemporaryDirectory() as raw_directory:
            directory = Path(raw_directory)
            report_path = directory / quality_evidence.ARTIFACT_NAME
            manifest_path = directory / quality_evidence.MANIFEST_NAME
            report_path.write_text("stale report\n", encoding="utf-8")
            manifest_path.write_text("stale manifest\n", encoding="utf-8")

            quality_evidence.write_evidence(
                directory, quality_evidence.complete_report(0)
            )

            self.assertEqual(
                [quality_evidence.MANIFEST_NAME, quality_evidence.ARTIFACT_NAME],
                sorted(path.name for path in directory.iterdir()),
            )
            self.parse_report(report_path.read_bytes())
            self.assertEqual(
                {"started": ["repository-quality"], "categories": []},
                json.loads(manifest_path.read_text(encoding="utf-8")),
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
