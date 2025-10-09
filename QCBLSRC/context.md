# QCBLSRC Context (COBOL)

> 📘 **Per-member docs:** Each source member now includes a `<member>.<ext>.md` companion with dependency notes and full listings. Use these guides alongside this context during modernization.

This folder mirrors an IBM i `QCBLSRC` source file and contains COBOL programs focused on customer, contract, and transaction management.

## Member Summaries
* **`XACBLTST.CBL`** – Simple utility that concatenates two 10-character inputs (`FIL` and `LIB`) into a 21-character output buffer with a separator. Useful as a template for parameter passing patterns.
* **`ZBCONDET.CBL` / `ZBCONDETNW.CBL`** – Interactive contract detail maintenance programs that drive the `WCONDETD` display file. They coordinate multiple database files (`CONDET`, `CONHDR`, `CUSTS`, `STKMAS`, `STOMAS`, `STKBAL`, `SLMEN`, `ORDSTS`, `TRNTYP`) and populate both subfiles and printer outputs. `ZBCONDETNW` appears to be an updated version that switches to the `CONDETNW` record format copybook. Expect complex indicator handling and state flags for subfile pagination.
* **`ZBCONHDR.CBL`** – Header maintenance for contracts, aligning with `WCONHDRD` display resources and the `CONHDR` physical/logical files defined in [`QDDSSRC`](../QDDSSRC/context.md).
* **`ZBCUSFMNT.CBL`** – Customer follow-up maintenance, leveraging the `CUSFMAINTD` display file and the `CUSFL3`/`DISTS` data sets. Implements status filtering and distribution list lookups.
* **`ZBCUSTS.CBL`** – Core customer master program that relies on the `WCUSTSD` and related display files for search and selection. Works closely with copybooks from [`CPYBKSRC`](../CPYBKSRC/context.md).
* **`ZBPRNCUSF.CBL`** – Printer routine to generate customer follow-up listings via printer file definitions (`PRTWCUSTP`) from [`QDDSSRC`](../QDDSSRC/context.md).
* **`ZBTRNHST.CBL`** – Transaction history browser/printer with dependencies on `TRNHST` physical/logical files and `WTRNHSTD` display resources.

## Cross-Cutting Concepts
* **Copybooks:** Each program pulls shared record layouts via `COPY` statements that reference [`CPYBKSRC`](../CPYBKSRC/context.md) and DDS-generated copybooks. Ensure copybooks stay synchronized with DDS changes.
* **Display & Printer Files:** Programs are tightly bound to DDS definitions in [`QDDSSRC`](../QDDSSRC/context.md), relying on indicator-driven subfiles and record formats.
* **Status Management:** Working storage often defines flag records (e.g., `WS-FLAGS`, `RECORD-FOUND-*`) to emulate modal workflows.

## Positive Findings
* Consistent structure and naming aligned with DDS artifacts simplifies navigation.
* Separation between interactive maintenance and batch printing is clear (`ZBCONDET` vs `ZBPRNCUSF`).

## Negative Findings / Risks
* Extensive dependence on display file indicators makes logic brittle and hard to modernize.
* Error handling is indicator-based with minimal messaging abstraction, complicating reuse.
* Duplicate programs (`ZBCONDET` vs `ZBCONDETNW`) suggest ongoing transitions that require clarity before refactoring.

## Entanglement & Migration Notes
* **Entangled areas:** `ZBCONDET` and `ZBCUSFMNT` touch numerous database files and require synchronized DDS/UI behavior. Migrating them requires reproducing subfile UX and multi-file joins.
* **Less entangled:** `XACBLTST` and `ZBPRNCUSF` are straightforward candidates to convert into SQL stored procedures or external services.

### Migration Suggestions
1. **Abstract data access:** Introduce SQL views or stored procedures (see [`QSQLPRC`](../QSQLPRC/context.md)) to encapsulate joins performed manually here, easing porting to non-IBM i platforms.
2. **Externalize printing:** Replace printer files with PDF/report services by wrapping `ZBPRNCUSF` logic into a modern reporting engine, while legacy programs call the service through an API.
3. **Stepwise UI replacement:** For `ZBCONDET`/`ZBCUSFMNT`, build web-based frontends that call the same data services and phase out DDS displays. Until then, consider exposing limited functions via web services consumed by both UI stacks.
