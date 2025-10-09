# QQMQRYSRC Context (Query/400 Definitions)

> 📘 **Per-member docs:** Each source member now includes a `<member>.<ext>.md` companion with dependency notes and full listings. Use these guides alongside this context during modernization.

This directory stores Query/400 source for quick reporting against DDS files defined in [`QDDSSRC`](../QDDSSRC/context.md).

## Members
* **`ORDERS`** – Produces an orders report joining `CONHDR`, `CONDET`, and `STKMAS` to calculate net values by contract/customer.
* **`BALANCEPRD`**, **`BALANCESTO`** – (Review before execution) likely generate inventory and production balance reports based on `STKBAL`, `STOMAS`, or related files.

## Positive Findings
* Queries provide concise documentation of required joins and columns, useful when rewriting reports in SQL or BI tools.
* They operate read-only, making them safe candidates for early migration.

## Negative Findings / Risks
* Query/400 definitions are IBM i specific; they must be translated to SQL for use elsewhere.
* Lack of parameterization; filtering or selection criteria must be hard-coded or provided interactively.

## Migration Suggestions
* Convert queries into SQL views or stored procedures in [`QSQLPRC`](../QSQLPRC/context.md) to reuse the logic across platforms.
* Use queries as acceptance tests when validating new reporting implementations.
