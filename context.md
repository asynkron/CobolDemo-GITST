# Repository Context

This repository contains an IBM i (AS/400) demonstration application that spans COBOL, RPG/RPGLE, CL, SQL, and DDS assets. The code appears to implement a light-weight CRM/order management workflow with customer, contact, order, distribution, and audit capabilities. The structure mirrors traditional IBM i source libraries, where each top-level directory corresponds to a source physical file (e.g., `QCBLSRC` for COBOL, `QDDSSRC` for DDS display/database definitions).

## Directory Overview
* [`QCBLSRC`](QCBLSRC/context.md) – COBOL programs for contracts, customers, and transaction history maintenance.
* [`QRPGSRC`](QRPGSRC/context.md) – Fixed-format RPG programs for reporting and legacy batch processing.
* [`QRPGLESRC`](QRPGLESRC/context.md) – ILE RPG modules for interactive UI, CRUD logic, and SQLRPGLE integration.
* [`QCLSRC`](QCLSRC/context.md) / [`QCLLESRC`](QCLLESRC/context.md) – Control language programs orchestrating batch jobs, overrides, and emergency utilities.
* [`QCMDSRC`](QCMDSRC/context.md) – Custom command definitions for launching the RPG/CL drivers.
* [`QDDSSRC`](QDDSSRC/context.md) – DDS for display, printer, logical, and physical files, defining the UI and database schema.
* [`CPYBKSRC`](CPYBKSRC/context.md) – COBOL copybooks shared across COBOL components.
* [`QQMQRYSRC`](QQMQRYSRC/context.md) – Query/400 definitions for quick reports.
* [`QSQLPRC`](QSQLPRC/context.md) / [`QSQLSRC`](QSQLSRC/context.md) – SQL procedures and DDL artifacts for incremental modernization.
* [`ASIMPLTEST`](ASIMPLTEST/context.md) – Ad hoc testing sources combining RPG, CL, and DDS snippets.
* Tooling and configuration lives under [`.idea`](.idea/context.md) and [`.ibmi`](.ibmi/context.md).
* Repository verification is declared in [`.faktorial`](.faktorial/context.md),
  with its repository-owned adapter and focused contract tests under
  [`scripts`](scripts/context.md).
* SSADM documentation resides in [`docs`](docs/context.md), including generated overviews, process models, business rule catalogs, and the new graph-clustering analysis of module dependencies.
* [`files.md`](files.md) – Collapsible, link-rich map tying every non-Markdown artifact to its nearest documentation entry.
* The root [`Makefile`](Makefile) provides a deterministic `quality` gate for the complete archaeology document set, non-semantic trailing whitespace in tracked Markdown, and the repository native quality-evidence adapter contract. The adapter emits atomic JUnit plus producer-manifest evidence for Faktorial translation; expected negative-path diagnostics are asserted without leaking into successful gate output. Exact two-space Markdown hard breaks remain valid content. The gate is documentation-only and does not compile or validate IBM i runtime behavior.
* [`docs/archaeology`](docs/archaeology/README.md) – Evidence-led tracked inventory, naming/layering map, tooling coverage record, domain/data report, defect and reliability audit, glossary, unknowns register, and coverage ledger. Use it as the completeness and stabilization baseline; retain the narrative and generated documents as secondary evidence.
  The [`domain and data report`](docs/archaeology/20-domain-and-data.md) adds the source-reconciled record dictionary, lineage, business rules, privacy classifications, and variant/runtime evidence gaps used to shape safe migration contracts.
* [`docs/archaeology/10-architecture-and-flows.md`](docs/archaeology/10-architecture-and-flows.md) – Evidence-classified architecture source of truth for subsystem interactions, representative execution/data flows, diagrams, and change-impact hotspots. Read it with the evidence map; it is not proof of production deployment.
* [`docs/archaeology/40-operations-and-recovery.md`](docs/archaeology/40-operations-and-recovery.md) – Evidence-acquisition and go/no-go map for build, execution, scheduling, observation, backup, rerun, and recovery. It is not a production runbook.
* [`docs/archaeology/90-modernization-roadmap.md`](docs/archaeology/90-modernization-roadmap.md) – Risk- and dependency-ordered rescue path from ownership and runtime truth through characterization, stabilization, recovery contracts, decoupling, and incremental modernization.

## Key Concepts
* **Data-Centric Design:** DDS physical/logical files (`QDDSSRC`) underpin both COBOL and RPG programs. Many source members expect specific record formats (e.g., `CONDET`, `CUSTS`, `STKMAS`).
* **Mixed UI Layers:** Display files drive interactive screens, while CL programs manage overrides and job control. RPGLE modules often correspond to display file names (e.g., `WWCUSTS.RPGLE` works with `WCUSTSD.DSPF`).
* **Copybook-Driven Data Sharing:** COBOL programs rely on copybooks from `CPYBKSRC` to enforce record layouts.
* **SQL Modernization Hooks:** SQL procedures and SQLRPGLE sources show initial steps toward embedding SQL logic, offering footholds for migration.

## Positive Findings
* Comprehensive coverage of customer/order lifecycle across multiple languages.
* SQLRPGLE and stored procedure samples demonstrate modernization awareness.
* Query/400 definitions provide concise documentation of reporting needs.

## Negative Findings / Risks
* Heavy coupling to DDS record formats and indicators increases migration complexity.
* Sparse inline documentation; business rules must be inferred from code.
* Minimal automated testing—the `ASIMPLTEST` folder is informal and mixed-format.

## Entanglement & Migration Notes
* **Least entangled:** `QSQLSRC` table definitions and `QSQLPRC` procedures have minimal dependencies and can be migrated to modern SQL services quickly. Query/400 definitions (`QQMQRYSRC`) are also self-contained snapshots of data needs.
* **Moderately entangled:** COBOL copybooks (`CPYBKSRC`) and standalone CL utilities (e.g., `TESTWIMX.CLLE`) can move independently but interact via job control conventions.
* **Most entangled:** DDS display files (`QDDSSRC`) and their paired RPGLE programs rely on IBM i subfile indicators and program-to-display contracts; migrating them requires substantial UI rethinking.

### Migration Suggestions
1. **Expose core data via APIs:** Externalize key tables (`CUSTS`, `CONHDR`, `CONDET`, etc.) using REST services backed by the SQL DDL in [`QSQLSRC`](QSQLSRC/context.md). Legacy RPG/COBOL modules could call new HTTP endpoints via sockets or HTTP APIs instead of direct file I/O.
2. **Modularize business rules:** Refactor COBOL programs like `ZBCONDET` and RPGLE modules like `WWCONDET` into service routines callable from both legacy and modern environments. Gradually replace file I/O with SQL views or stored procedures from [`QSQLPRC`](QSQLPRC/context.md).
3. **Wrap CL orchestration:** Re-implement batch CL flows (see [`QCLSRC`](QCLSRC/context.md)) in modern schedulers while keeping IBM i overrides temporarily. Provide HTTP triggers or message queues for the hardest-to-migrate interactive screens.

---
**Tip for future agents:** consult these `context.md` files first—they summarize dependencies and modernization paths. Update the relevant `context.md` whenever you modify code in a directory to keep this index trustworthy.

For repository-wide discovery, start with the archaeology evidence map and refresh its Git-based counts whenever source, configuration, generated, or operational families change. Do not treat Source Atlas, per-member companions, context summaries, or heuristic graph output as proof of complete dependency coverage.

For domain or data migration work, start with the archaeology domain/data report, then validate any chosen contract against generated DDS copybooks, IBM i object metadata, approved masked profiles, and runtime traces before treating inferred relationships or variant precedence as authoritative.

For cross-family changes, use the architecture edge catalog to identify direct
calls, shared-data coupling, DDS-generated linkage, and configured/runtime
integration. Keep unverified object bindings, active variants, schedules, and
external services explicitly unknown until IBM i or deployment evidence is
available.

For stabilization work, use the archaeology defect/risk audit's stable finding IDs and preserve its distinction between source-confirmed behavior and unknown deployment reachability. Revalidate triggers against primary members plus compiler/runtime evidence before changing destructive or cross-file flows.

For operational or modernization work, apply the operations map's stop conditions and roadmap phase gates. Do not infer compile order, active libraries, schedules, journaling, backup/restore procedures, or external delivery from source-visible commands. Keep personal, financial, credential, and spool evidence synthetic or approved and masked.
