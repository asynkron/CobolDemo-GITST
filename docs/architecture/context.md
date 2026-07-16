# architecture Directory Context

This directory centralizes cross-cutting architectural documentation for the CobolDemo CRM/order management system.

## Key Assets
- `overview.md` — consolidated architectural narrative with system context, layered architecture, data flow diagrams, module interactions, and entity relationships.
- `trace-component-model.ai.json` — machine-checkable designed architecture model. Its initial bounded scope maps the source-proven `CBCUSTS` customer-master-maintenance program, `CBCUSTSD` 5250 display, `CUSTS` master file, and directly consulted `SLMEN`, `DISTS`, `CUSGRP`, and `CUSFL3` stores. Codegraph refs are repository-relative and identify files or stable symbols without raw node IDs or routine line numbers.

## Maintenance Notes
- Update the overview when adding new integrations, modules, or modernization initiatives so diagrams stay accurate.
- Align diagram syntax (Mermaid) with the conventions captured in `../diagrams.md` to ensure consistency across documentation.
- Preserve the new accent fills applied to architecture diagrams so future highlights remain consistent with the shared palette.
- Extend the designed model from source and codegraph evidence rather than narrative documentation. Keep runtime counters and timestamps out of the AI file, validate changes with `GET /api/otel/component-model/ai/validate`, and inspect `GET /api/otel/component-model?view=merged` to confirm designed and observed content remain readable together.
