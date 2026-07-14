# docs Directory Context

This directory stores SSADM-style documentation generated for the CobolDemo CRM/order management system, a holistic architectural overview, migration experiments, and an evidence-led repository archaeology corpus.

## Key Assets
- `01_system_overview.md` through `06_physical_design.md` — top-level SSADM documents covering overview, data model, process flows, module specifications, interfaces, and physical design considerations.
- `business_rules/` — structured English business rule catalogs for major COBOL modules (`ZBCONDET`, `ZBCONHDR`, `ZBCUSTS`). COBOL snippets
  in these catalogs use seven leading spaces so syntax highlighters treat the statements as column-8 source. Rule descriptions
  render their plain-English statements as blockquotes to improve readability when scanning the IF/THEN phrasing.
- `docs-create.md` — instructions for regenerating the SSADM documentation set.
- `context-create.md` — meta instructions for creating context files.
- `diagrams.md` — house style for diagrams referenced in generated documents.
- `architecture/overview.md` — cross-cutting view of system context, layered structure, data flows, module collaboration, and entity relationships.
- `migration/` — hands-on playbooks that describe how to peel specific COBOL capabilities into external services (currently the `XACBLTST` concat utility migration to ASP.NET Core).
- `graph_clustering_analysis.md` — Louvain-based dependency clustering of source members with an accompanying Mermaid summary.
- `graph_clustering_analysis.py` — helper script that rebuilds the clustering dataset by scanning CALL and COPY statements across the IBM i libraries.
- `archaeology/` — repository-wide tracked inventory, coverage ledger, domain/data report, and defect/risk audit. It separates facts, confirmed defects and risks, supported inferences, and unknowns; records tooling blind spots and verification ceilings; and treats generated/narrative documents as secondary evidence.
  Its `20-domain-and-data.md` report reconciles DDS, copybook, program, CL, and Query/400 evidence into the domain dictionary, lineage, rule catalog, privacy boundary, and runtime unknowns.
- `archaeology/10-architecture-and-flows.md` — source-backed subsystem, dependency, execution/data-flow, and change-impact reconstruction, with confirmed relationships kept distinct from inference and runtime unknowns.

## Maintenance Notes
- Update the relevant Markdown files and regenerate diagrams whenever program logic or data structures change.
- Keep business rule catalogs synchronized with COBOL source changes so validation logic remains traceable.
- Mermaid diagrams now apply the shared accent palette (see repository instructions) to highlight key components—reuse these
  fills when extending or adding visuals.
- When adding a migration guide, capture the integration contract (payloads, endpoints) and reference any companion sample code so future teams can replicate the pattern quickly.
- When source, operational, generated, configuration, or deployment families change, refresh `archaeology/00-evidence-map.md` from `git ls-files` and update its unknowns and tooling-coverage entries.
- When a record layout, logical access path, data operation, calculation, status/default, or active-variant/runtime fact changes, refresh `archaeology/20-domain-and-data.md` and preserve its Fact/Inference/Unknown and sensitivity annotations.
- When an interaction or execution path changes, update the architecture edge
  catalog and all affected diagrams/flows in the same change; update the
  evidence-map counts only when the tracked inventory or baseline facts change.
- When behavior or operational evidence changes, refresh the affected stable finding in `archaeology/30-defects-and-risks.md`; keep primary evidence, trigger, impact, and verification method together, and leave deployment-dependent claims as hypotheses until environment evidence resolves them.
