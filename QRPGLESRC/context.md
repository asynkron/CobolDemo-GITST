# QRPGLESRC Context (ILE RPG & SQLRPGLE)

This source directory houses modernized RPG code (free-format RPGLE and SQLRPGLE) responsible for most interactive workflows, reports, and database maintenance tasks. Members often map directly to DDS display files in [`QDDSSRC`](../QDDSSRC/context.md) and are launched via CL/command wrappers in [`QCLSRC`](../QCLSRC/context.md) and [`QCMDSRC`](../QCMDSRC/context.md).

## Functional Areas
* **Customer Maintenance (`CUS*`, `WWCUST*`, `WCUST*`):** Interactive programs for customer search (`CUSFSEL`, `WWCUSTS`), maintenance (`CUSFMAINT`, `CUSUPD*`), and printing (`PRTWCUSTP`). SQLRPGLE members like `UPDATEENT.SQLRPGLE` provide reusable data operations.
* **Contact & Contract Management (`CON*`, `WWCON*`, `ZAUDCON`):** Programs such as `CONUPD*`, `WWCONDET`, and `WWCONHDR` manage contract headers/details, aligning with COBOL counterparts in [`QCBLSRC`](../QCBLSRC/context.md) for shared business rules.
* **Audit & Reporting (`ORDAUDIT*`, `ZAUD*`):** Batch and inquiry programs for auditing orders, customers, stock balances, etc. They frequently produce spool reports defined by printer files in [`QDDSSRC`](../QDDSSRC/context.md).
* **Selection & Inquiry (`DISTSSEL`, `STKMASEL`, `WWITEMS`, `WWTRNHST`):** Subfile-driven inquiries across distribution lists, stock balances, and transaction history.
* **SQL Integration (`CONCATPGM.SQLRPGLE`, `DELETEENT.SQLRPGLE`, `INSERTENT.SQLRPGLE`, `TSTPGM*.SQLRPGLE`):** Demonstrates embedding SQL for CRUD operations and tests, bridging DDS-based code with modern database access.
* **Utilities:** `PROFILE.RPGLE`, `SNDEMAIL.RPGLE`, `TRIGGER1.RPGLE`, `XRPGM*` provide supporting services and prototypes.

## Positive Findings
* Adoption of RPGLE and SQLRPGLE indicates an active modernization path compared with fixed-format RPG.
* Modules encapsulate specific UI flows, easing identification of entry points and dependencies.
* SQLRPGLE members offer reusable data services that could be exposed externally.

## Negative Findings / Risks
* Despite using RPGLE, many programs still depend on indicator-based DDS interactions, limiting portability.
* Naming conventions can be opaque without DDS context (e.g., `WW` prefix for “work with” screens); rely on linked contexts for clarity.
* There is limited unit testing—behavior is validated through interactive execution only.

## Entanglement & Migration Notes
* Strong coupling to DDS displays and printer files persists; the UI logic is the hardest portion to migrate.
* SQLRPGLE routines are the least entangled and can be extracted into standalone services or stored procedures, similar to assets in [`QSQLPRC`](../QSQLPRC/context.md).
* Programs share data structures with COBOL via the same DDS-based copybooks, requiring coordinated changes.

### Migration Suggestions
1. **Service Layer Extraction:** Convert SQLRPGLE CRUD programs (e.g., `INSERTENT`, `UPDATEENT`) into standalone APIs so both legacy RPGLE UI code and new applications can reuse the same logic.
2. **UI Modernization:** Replace `WW*` subfile programs with web or desktop UIs that call the new service layer. Maintain compatibility temporarily using 5250 emulation wrappers.
3. **Refactor for Free-Format:** When touching these members, convert indicator-heavy routines into free-format and modular procedures to simplify eventual migration.
