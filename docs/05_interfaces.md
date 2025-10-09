# Interfaces

## Batch and Control Interfaces
- **CL Programs:** `QCLSRC` and `QCLLESRC` members orchestrate overrides for display/printer files, initiate COBOL programs, and manage nightly refreshes. They prepare library lists and submit jobs to IBM i subsystems.
- **Commands:** `QCMDSRC` provides custom commands allowing operators to launch maintenance programs with prefilled parameters.
- **Scheduling:** CL scripts integrate with IBM i job scheduler; batch executions such as `ZBPRNCUSF` rely on overrides established by CL to target correct output queues.

## File-Based Interfaces
- **DDS Physical Files:** Core persistent storage resides in `QDDSSRC` definitions. COBOL/RPG modules perform indexed reads/writes via DDS-managed access paths.
- **Printer Files:** Reports such as contract details and follow-up listings write to printer files (`CONDET-REPORT`, `PRTWCUSTP`), producing spooled files for review.
- **Display Files:** Interactive programs interface with DDS display files, exchanging screen indicators and subfile buffers.

## External / Modernization Hooks
- **SQL Procedures:** `QSQLPRC` and `QSQLSRC` artifacts provide stored procedures and SQL DDL that mirror DDS definitions, enabling exposure to external analytics or integration platforms.
- **Selector Programs:** Modules call external selector utilities (`CUSTSSEL`, `ORDSTSEL`, `SLMENSEL`) to resolve lookup values, acting as modular interfaces within the interactive environment.
- **Messaging:** Standard IBM i message handling is accessed via `XBCCLMSG` and `RTNMSGTEXT`, which encapsulate retrieval of localized message text for display.
