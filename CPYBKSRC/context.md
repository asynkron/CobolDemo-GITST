# CPYBKSRC Context (COBOL Copybooks)

> 📘 **Per-member docs:** Each source member now includes a `<member>.<ext>.md` companion with dependency notes and full listings. Use these guides alongside this context during modernization.

This directory contains COBOL copybooks that provide shared record layouts for customer and distribution data. They are consumed by the COBOL programs in [`QCBLSRC`](../QCBLSRC/context.md) and must remain synchronized with the DDS record definitions in [`QDDSSRC`](../QDDSSRC/context.md).

## Member Summaries
* **`CUSFL300.CBLINC`** – Full customer follow-up record with contact information, comments, and metadata (creator, verifier, last contact dates). Mirrors the `CUSFL3` logical file.
* **`CUSGRP00.CBLINC`** – Customer group structure containing group identifiers, names, and hierarchy references.
* **`CUSTS00.CBLINC`** – Customer master record layout (IDs, status, credit, contact numbers) consistent with the `CUSTS` physical file.
* **`DISTS00.CBLINC`** – Distribution list/member fields including sales representative codes and communication preferences.

## Usage Notes
* Programs typically include these copybooks in the `WORKING-STORAGE` or `FILE SECTION` to align local variables with DDS record formats.
* When DDS fields change, regenerate copybooks to prevent data misalignment.

## Positive Findings
* Copybooks centralize data structure definitions, enabling multi-program consistency.

## Negative Findings / Risks
* There is no automation to regenerate copybooks; manual synchronization with DDS is error-prone.
* Copybooks duplicate information already defined in DDS, complicating modernization.

## Migration Suggestions
* Replace copybook inclusion with externalized service responses (JSON/XML) or SQL row types once core data is exposed via services described in [`QSQLPRC`](../QSQLPRC/context.md).
* Consider generating copybooks directly from DDS or database metadata to reduce drift.
