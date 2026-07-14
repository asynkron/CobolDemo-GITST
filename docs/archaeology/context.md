# docs/archaeology Context

This directory holds repository-wide, evidence-led archaeology artifacts. Its purpose is to make source coverage, evidence strength, tooling blind spots, and unresolved dependencies auditable before modernization decisions are made.

## Key assets

- `README.md` defines the corpus boundary, fact/inference/unknown convention, and maintenance workflow.
- `00-evidence-map.md` is the baseline tracked inventory and coverage ledger for source, data definition, orchestration, command, query, test, generated, documentation, configuration, build, deployment, and external-interface evidence.
- `20-domain-and-data.md` is the source-reconciled domain model, record/access-path dictionary, producer-consumer matrix, lineage and rule catalog, privacy boundary, and unresolved-runtime-evidence register.
- `10-architecture-and-flows.md` is the evidence-backed architecture source of truth for subsystem responsibilities, classified interaction edges, representative execution/data flows, diagrams, hidden coupling, and change-impact hotspots.

## Dependencies and evidence rules

- Reproduce counts from `git ls-files` at the recorded commit.
- Prefer primary source members and configuration over generated output, per-member Markdown companions, `files.md`, context summaries, or heuristic graph output.
- Treat semantic-index and Tree-sitter results as tool-coverage observations, not as proof that an unreported dependency does not exist.
- Keep out-of-repository programs, libraries, queues, job descriptions, mail/fax services, and deployed endpoints classified as unknown until runtime or external evidence is supplied.
- Keep domain and rule claims tied to primary DDS/program/query evidence. Never promote filename age, `BK`/`NW` naming, tracked copybook shape, or shared field names into deployed-variant or referential-integrity claims without compile/object/runtime proof.
- Keep the architecture edge catalog and diagrams aligned. Every confirmed edge needs a primary path; runtime/deployment claims remain inferred or unknown until external evidence resolves them.

## Modernization guidance

Use the evidence map to select later focused audits; do not derive migration order from file counts alone. Refresh the relevant ledger row and parent contexts whenever this directory gains a new audit artifact or a previously unknown dependency is resolved.

Use the domain/data report to define characterization tests and migration contracts. Preserve its sensitivity classifications and replace Unknowns only with named compile metadata, IBM i object evidence, approved masked profiles, or runtime traces.

For architecture changes, start with shared DDS/data hubs and object-resolution
configuration. Update the affected flow, edge classification, hotspot analysis,
and unknowns together; keep detailed domain-rule and defect adjudication in
their dedicated audits.
