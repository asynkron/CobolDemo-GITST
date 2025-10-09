# QSQLSRC Context (SQL DDL)

This directory holds SQL Data Definition Language (DDL) scripts that complement the DDS schema in [`QDDSSRC`](../QDDSSRC/context.md). They are valuable when migrating to a modern SQL-centric environment.

## Members
* **`COUNTRY.SQL`** – Creates a `COUNTRY` table with code, name, timestamps, user tracking, and publication flag. Defines defaults and a primary key.
* **`COUNTRYDTA.SQL`** – (Inspect before use) likely contains INSERT statements or sample data for the `COUNTRY` table.

## Positive Findings
* Provides a direct SQL representation of at least one reference table, easing replication in non-IBM i databases.
* Uses standard SQL features (defaults, primary keys) compatible with many RDBMS platforms.

## Negative Findings / Risks
* Limited coverage—only the `COUNTRY` table is defined. Broader schema translation is still required.
* No scripts for constraints beyond the primary key; referential integrity remains manual.

## Migration Suggestions
* Use these scripts as templates to translate key DDS physical files (`CUSTS`, `CONHDR`, etc.) into SQL DDL.
* Incorporate the SQL definitions into migration pipelines (Liquibase/Flyway) for controlled deployment outside IBM i.
