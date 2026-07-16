# Repository Scripts Context

This directory contains portable repository-owned automation used by local and
Faktorial verification. Scripts use only the Python standard library so the
documentation-only quality gate does not acquire a project package dependency.

## Key Assets

* [`quality_evidence.py`](quality_evidence.py) runs `make quality`, treats that
  repository gate as one exact terminal test, and atomically writes the declared
  native JUnit report plus producer-scope manifest. A nonzero command exit is a
  complete failed test with the stable
  `repository-quality / Makefile / make quality` identity; inability to execute
  the command emits untranslatable native output so Faktorial reports
  `translation_failed` without guessed counts.
* [`test_quality_evidence.py`](test_quality_evidence.py) verifies successful and
  failed terminal counts, stable failure identity, the explicit
  translation-failure input, atomic replacement of both native files, and
  agreement with `.faktorial/main-verify.json`. Expected negative-path
  diagnostics are captured and asserted so they do not pollute a successful
  ordinary quality run.

## Dependencies

The adapter invokes the root `Makefile`; the focused tests are invoked by the
`quality-evidence-contract` target and therefore form part of ordinary
`make quality` verification. Faktorial supplies a fresh
`FAKTORIAL_QUALITY_EVIDENCE_DIR` for each adapter process.
