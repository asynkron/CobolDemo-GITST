# Physical Design

## Runtime Environment
- IBM i environment with COBOL/400, RPG, and CL components compiled from corresponding source physical files.
- Library lists prepared by CL programs ensure DDS and copybooks are accessible during execution.
- Display files run in interactive subsystems, while printer programs execute as batch jobs producing spooled output.

## File Organization
- **DDS Physical Files:** Indexed by primary and secondary keys (e.g., `CONHDR` keyed by contract number; `CONDET` keyed by contract and item).
- **Logical Files:** Provide alternative access paths such as `CUSFL3` for follow-up sequencing and `TRNHST` logicals for chronological history.
- **Printer Files:** Configured for 132-column output and used by COBOL reports to format detail and summary listings.

## Batch Flow
```mermaid
flowchart LR
  OVROBJ[CL Overrides] --> MAINT[Interactive Maintenance]
  OVROBJ --> PRN[Printer Programs]
  MAINT --> SQLX[SQL Procedures / Modernization]
  PRN --> SPOOLED[Spooled Reports]
  %% Surface run-time responsibilities with targeted background fills.
  style OVROBJ fill:#2E8B57
  style MAINT fill:#7B3B7B
  style PRN fill:#CC7722
  style SQLX fill:#3A6EA5
  style SPOOLED fill:#B23A48
```

## Deployment Considerations
- **Scheduling:** Nightly or on-demand CL jobs submit printer programs and data refresh tasks. Overrides must be reset before each run.
- **Data Synchronization:** Copybooks must match DDS definitions; recompilation required after schema changes.
- **Modernization Hooks:** SQL procedures and RPGLE modules can be deployed as service programs, exposing REST or message-based APIs while legacy COBOL continues to operate.

## Performance Notes
- Heavy use of indexed DDS access ensures efficient retrieval; subfile pagination limits interactive load.
- Validation routines minimize disk I/O by checking reference masters before writing.
- Printer programs sequentially read logical files to generate summary totals, allowing future replacement with SQL-based reporting engines.
