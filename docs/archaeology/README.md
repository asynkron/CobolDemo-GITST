# Repository Archaeology

This directory is the evidence-led audit index for the repository. It complements the narrative system, architecture, business-rule, and migration documents elsewhere under `docs/`; it does not replace source members or claim that documented integrations are deployed.

## Start here

- [`00-evidence-map.md`](00-evidence-map.md) — tracked inventory, source-family map, historical layers, naming conventions, external-interface clues, tooling coverage, glossary, unknowns, and the coverage ledger.
- [`context.md`](context.md) — maintenance responsibilities for this archaeology corpus.

## Evidence conventions

Every substantive archaeology claim should use one of these statuses:

- **Fact** — directly observable in a tracked source, configuration, generated artifact, or reproducible repository inventory. Cite a repository path and, where useful, a member or symbol.
- **Inference** — a reasoned interpretation of facts whose chronology, intent, ownership, or runtime use is not explicit. State the supporting facts.
- **Unknown** — information the repository cannot establish. Record what evidence would resolve it instead of filling the gap with an assumption.

Generated files, per-member Markdown companions, `context.md` summaries, `files.md`, and generated analysis are secondary evidence. They are navigation aids, not substitutes for the tracked primary member or configuration they describe.

## Maintaining the audit

When a source or operational family changes:

1. Recount from `git ls-files`, not from the Source Atlas or an IDE view.
2. Update the matching row in the evidence map's coverage ledger, including the inventory basis and representative primary evidence.
3. Classify new conclusions as fact, inference, or unknown.
4. Record semantic/search support separately from text visibility; an indexed filename is not proof that references were resolved.
5. Add new unresolved dependencies to the unknowns register and remove an unknown only when path-evidenced proof resolves it.
6. Update this index and the relevant directory `context.md` when the corpus gains another audit artifact.

The baseline snapshot is tied to Git commit `3a05212` and the worktree inventory observed on 2026-07-14. Later audits should record their own commit and date so count changes are explainable.
