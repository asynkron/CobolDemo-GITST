# Repository Scripts Context

This directory contains portable repository-owned automation used by local and
Faktorial verification. Scripts use only the Python standard library so the
documentation-only quality gate does not acquire a project package dependency.

## Key Assets

* [`quality_evidence.py`](quality_evidence.py) runs `make quality`, treats that
  repository gate as one exact terminal test, and atomically writes the declared
  `quality-evidence.v1` envelope. A nonzero command exit is a complete failed
  test with the stable `repository-quality / Makefile / make quality` identity;
  inability to execute the command is `translation_failed`.
* [`test_quality_evidence.py`](test_quality_evidence.py) verifies successful and
  failed terminal counts, stable failure identity, explicit translation failure,
  atomic replacement, and agreement with `.faktorial/main-verify.json`.

## Dependencies

The adapter invokes the root `Makefile`; the focused tests are invoked by the
`quality-evidence-contract` target and therefore form part of ordinary
`make quality` verification. Faktorial supplies a fresh
`FAKTORIAL_QUALITY_EVIDENCE_DIR` for each adapter process.
