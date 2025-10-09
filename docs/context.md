# docs Directory Context

This directory now stores SSADM-style documentation generated for the CobolDemo CRM/order management system, plus a holistic architectural overview.

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

## Maintenance Notes
- Update the relevant Markdown files and regenerate diagrams whenever program logic or data structures change.
- Keep business rule catalogs synchronized with COBOL source changes so validation logic remains traceable.
- Mermaid diagrams now apply the shared accent palette (see repository instructions) to highlight key components—reuse these
  fills when extending or adding visuals.
- When adding a migration guide, capture the integration contract (payloads, endpoints) and reference any companion sample code so future teams can replicate the pattern quickly.
