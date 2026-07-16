# Faktorial Configuration Context

This directory contains repository-owned configuration consumed by Faktorial.

## Key Assets

* [`main-verify.json`](main-verify.json) declares the repository verification
  command and its required runner-neutral quality-evidence producer.

## Verification Contract

Faktorial runs `python3 ./scripts/quality_evidence.py` with an isolated
`FAKTORIAL_QUALITY_EVIDENCE_DIR`. The adapter must atomically emit exactly one
`repository-quality.quality-evidence.json` envelope matching
`quality-evidence.v1` and `test-results.v1`, including when `make quality`
fails. Faktorial validates the envelope; repository-specific Make and Python
behavior remains in this repository.
