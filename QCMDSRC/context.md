# QCMDSRC Context (Command Definitions)

> 📘 **Per-member docs:** Each source member now includes a `<member>.<ext>.md` companion with dependency notes and full listings. Use these guides alongside this context during modernization.

`QCMDSRC` contains IBM i command definitions that wrap underlying CL/RPG programs. They provide user-friendly prompts and enforce parameter validation for batch processes.

## Members
* **`ORDERAUDIT.CMD`** – Launches the order audit batch flow with a `LIB` parameter controlling which data library to process. Likely invokes `ORDAUDIT*` programs in [`QCLSRC`](../QCLSRC/context.md) and [`QRPGLESRC`](../QRPGLESRC/context.md).
* **`ORDAUDIT0/1/2.CMD`**, **`TRNHSTCMD.CMD`** – Additional commands for different phases of the audit and transaction history processes.

## Positive Findings
* Commands provide a stable interface regardless of underlying program changes.

## Negative Findings / Risks
* Commands currently expose minimal parameters; hard-coded defaults (like `*LIBL`) limit flexibility.

## Migration Suggestions
* Mirror command interfaces in modern tooling (CLI/REST) to preserve operator workflows during migration.
* Expand parameters to support new features (e.g., date ranges) and propagate them through CL/RPG programs.
