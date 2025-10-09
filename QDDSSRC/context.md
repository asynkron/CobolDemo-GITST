# QDDSSRC Context (DDS Definitions)

> 📘 **Per-member docs:** Each source member now includes a `<member>.<ext>.md` companion with dependency notes and full listings. Use these guides alongside this context during modernization.

`QDDSSRC` hosts the DDS members that define the database schema (PF/LF), printer files (PRTF), and display files (DSPF) that drive the COBOL/RPG applications. These artifacts are heavily referenced by programs in [`QCBLSRC`](../QCBLSRC/context.md), [`QRPGSRC`](../QRPGSRC/context.md), and [`QRPGLESRC`](../QRPGLESRC/context.md).

## Structure Overview
* **Physical Files (`*.PF`):** Core data tables such as `CUSTS`, `CONHDR`, `CONDET(NW)`, `STKMAS`, `STKBAL`, `TRNHST`, `SLMEN`, `ORDSTS`, and supporting code tables (`PTYPES`, `SSTPF`, etc.).
* **Logical Files (`*.LF`):** Indexes/views for specific access paths (e.g., `CUSFL*`, `CONDETL*`, `TRNHSTL*`) enabling keyed reads and subset views for subfiles.
* **Display Files (`*.DSPF`):** Screen definitions for maintenance and inquiry functions (`WCONDETD`, `WCUSTSD`, `CUSFMAINTD`, etc.), including subfile control records and message lines.
* **Printer Files (`*.PRTF`):** Report layouts like `PRTWCUSTPD`, `OE006RT`, `WCUSTRP`, `STRBALRPT` used by batch output programs.

## Key Dependencies
* DDS members generate copybooks via IBM i compilation; these copybooks are included by COBOL/RPG programs.
* CL programs in [`QCLSRC`](../QCLSRC/context.md) configure overrides that assume specific record format names and library lists defined here.
* SQL-based assets in [`QSQLSRC`](../QSQLSRC/context.md) model similar structures, offering a migration path.

## Positive Findings
* Rich logical file coverage provides optimized access paths, reducing the need for manual sorting in code.
* Display/printer files adhere to IBM i conventions, facilitating reuse across languages.

## Negative Findings / Risks
* DDS technology is legacy; modern tooling prefers SQL DDL. Migration will require re-specification of display/printer logic.
* Large number of logical files may mask redundant or unused access paths—requires inventory before modernization.

## Entanglement & Migration Notes
* Display files are the most tightly coupled components; RPGLE programs expect exact indicator mappings.
* Physical files that already have SQL definitions (e.g., `CUSTS`, `COUNTRY`) are candidates for replacement via SQL tables in [`QSQLSRC`](../QSQLSRC/context.md).
* Printer files are less entangled and can be replaced with modern reporting/BI solutions once data is accessible.

### Migration Suggestions
1. **Reverse-engineer to SQL:** Use DDS-to-SQL conversion tools to regenerate tables, then adjust programs to use embedded SQL or external services.
2. **UI Replacement Strategy:** Map each display file to a web/mobile equivalent, using the field layouts here as the canonical reference. Modern services can expose the same data to both old and new UIs during transition.
3. **Access Path Rationalization:** Analyze logical file usage (via cross-references or code scanning) to determine which can be recreated as SQL indexes or materialized views, reducing duplication when moving off DDS.
