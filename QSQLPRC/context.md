# QSQLPRC Context (SQL Procedures)

> 📘 **Per-member docs:** Each source member now includes a `<member>.<ext>.md` companion with dependency notes and full listings. Use these guides alongside this context during modernization.

`QSQLPRC` contains stored procedure source members demonstrating SQL-based business logic on IBM i. They complement the SQLRPGLE programs in [`QRPGLESRC`](../QRPGLESRC/context.md) and can serve as modernization anchors.

## Members
* **`CONCATSTR`** – Concatenates an input string with itself. Simple example illustrating IN/OUT parameters and string operations.
* **`SQL_PRC_01`**, **`SQL_PRC_02`**, **`SQL_PRC_03`** – Additional stored procedure samples (review contents before reuse) likely covering CRUD operations or data validation.

## Positive Findings
* Stored procedures provide centralized business logic accessible from multiple languages.
* Demonstrates awareness of schema qualification (`XAN4CDEM`), useful for multi-library deployments.

## Negative Findings / Risks
* Procedures are simplistic demos; production usage would need error handling, commitment control, and security review.
* Lack of documentation on input/output conventions may hinder reuse.

## Migration Suggestions
* Expand these procedures to encapsulate complex joins currently implemented in COBOL/RPG (see [`QCBLSRC`](../QCBLSRC/context.md) and [`QRPGLESRC`](../QRPGLESRC/context.md)).
* Expose the procedures via REST APIs or Db2 services to decouple front-end technologies from IBM i.
