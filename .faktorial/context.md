# Faktorial Configuration Context

This directory contains repository-owned configuration consumed by Faktorial.

## Key Assets

* [`main-verify.json`](main-verify.json) declares the repository verification
  command and its required runner-neutral quality-evidence producer.

## Verification Contract

Faktorial runs `python3 ./scripts/quality_evidence.py` with an isolated
`FAKTORIAL_QUALITY_EVIDENCE_DIR`. The adapter must atomically emit the declared
`repository-quality.junit.xml` native test report plus `producers.json`,
including when `make quality` fails. Faktorial translates the report to
`test-results.v1`; repository-specific Make and Python behavior remains in this
repository. If the command cannot be executed, the adapter writes a bounded,
deliberately untranslatable report so collection produces `translation_failed`
instead of guessed counts.
