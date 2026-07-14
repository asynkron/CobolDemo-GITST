# Repository Archaeology

## Executive summary

This suite is the evidence-led entry point for understanding and stabilizing the repository. The source shows a DDS-centered IBM i application spanning COBOL, RPG/RPGLE, CL, Query/400, SQL, 5250 screens, spool output, and a later HTTP experiment. It also shows high-consequence defect and recovery risks. It does **not** prove which source variants are compiled, which objects are deployed, how jobs are scheduled, or how production backup and recovery work.

Use the suite to decide what to inspect and what evidence to acquire. Do not use it as an executable production runbook. A source-visible command proves that a mechanism exists in source; it does not prove authority, deployed configuration, safe parameters, or successful external delivery.

## Newcomer reading order

1. [`00-evidence-map.md`](00-evidence-map.md) — inventory baseline, evidence rules, terminology, coverage, and unresolved questions.
2. [`10-architecture-and-flows.md`](10-architecture-and-flows.md) — subsystem relationships, execution/data flows, and change-impact hotspots.
3. [`20-domain-and-data.md`](20-domain-and-data.md) — record dictionary, lineage, business rules, privacy boundaries, and variant reconciliation.
4. [`30-defects-and-risks.md`](30-defects-and-risks.md) — stable defect, risk, inference, and hypothesis IDs with verification procedures.
5. [`40-operations-and-recovery.md`](40-operations-and-recovery.md) — evidence-grounded build, run, observation, rerun, backup, and recovery map with operator stop points.
6. [`90-modernization-roadmap.md`](90-modernization-roadmap.md) — risk- and dependency-ordered rescue path from evidence acquisition through incremental modernization.
7. [`context.md`](context.md) — maintenance responsibilities for the corpus and its validation helper.

## Decision views

- [Ownership and operational impact](40-operations-and-recovery.md#ownership-and-impact-matrix)
- [Audit coverage by evidence state](00-evidence-map.md#publication-coverage-matrix)
- [Open questions and evidence needed](00-evidence-map.md#open-question-register)
- [Highest-value next investigations](90-modernization-roadmap.md#highest-value-next-investigations)
- [Operational go/no-go boundary](40-operations-and-recovery.md#operator-gono-go-boundary)
- [Modernization phases and stop conditions](90-modernization-roadmap.md#roadmap)

## Evidence conventions

Every substantive archaeology claim uses one of these statuses:

- **Fact** — directly observable in a tracked source, configuration, generated artifact, or reproducible repository inventory. Cite a repository path and, where useful, a member or symbol.
- **Inference** — a reasoned interpretation of facts whose chronology, intent, ownership, or runtime use is not explicit. State the supporting facts.
- **Unknown** — information the repository cannot establish. Record what evidence would resolve it instead of filling the gap with an assumption.

Generated files, per-member Markdown companions, `context.md` summaries, `files.md`, and generated analysis are secondary evidence. They are navigation aids, not substitutes for the tracked primary member or configuration they describe. A confirmed source defect is not a confirmed production incident unless deployment evidence establishes reachability.

## Maintaining the audit

When source, configuration, behavior, or operational evidence changes:

1. Recount inventory from `git ls-files`, not an IDE or generated atlas.
2. Update the matching coverage row and record the revision so historical counts remain explainable.
3. Update related architecture flows, domain rules, stable D/R/H findings, operational stop conditions, and roadmap gates together.
4. Preserve the distinction among source member, compiled program/object, DDS file/access path, table/data store, job, and service.
5. Add unresolved dependencies to the open-question register; remove one only when named evidence resolves it.
6. Run the documentation gate after changing the suite.

The original evidence-map baseline is tied to Git commit `3a05212`. The publication reconciliation records the later `00a6d2d` snapshot separately so provenance is preserved rather than silently replacing historical counts. The architecture, domain, and defect reports retain their own inspection revisions for durable source locators.

The repository documentation gate checks the seven required documents, local relative links, Mermaid rendering, and bounded Markdown whitespace. Passing it verifies documentation structure only; it does not compile IBM i members or validate deployed behavior.
