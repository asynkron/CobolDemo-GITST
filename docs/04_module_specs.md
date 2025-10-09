# Module Specifications

## ZBCUSTS — Customer Master Maintenance
- **Description:** Two-page interactive maintenance for customer demographics, hierarchy, sales rep assignments, distributor mapping, and credit/volume metrics.
- **Inputs:**
  - Display file `WCUSTSD` subfiles (`ZZSF01`, `ZZFT01`, `ZZFT02`).
  - Files: `CUSTS`, `CUSGRP`, `CUSFL3`, `SLMEN`, `DISTS`.
  - Copybooks: `CUSTS00`, `CUSGRP00`, `CUSFL300`, `DISTS00`.
- **Outputs:** Updates to `CUSTS`; optional navigation to contract (`CBCONHDR`) and history (`CBTRNHST`) programs; message text via `RTNMSGTEXT`.
- **Sections:**
  - `FILE-CONTROL`: Indexed access to master and reference files.
  - `WORKING-STORAGE`: Indicator arrays, page number, and validation flags.
  - `PROCEDURE`: `VALID1-ROUTINE` checks identity page data; `VALID2-ROUTINE` enforces numeric and follow-up constraints; `MVSCDB-ROUTINE` moves screen data to database record.
- **Key Business Rules:** Customer name required; group, sales rep, distributor, and follow-up references must exist; credit limit checks during changes.
- **Snippet:**
```cobol
IF ZWG4TX OF ZZFT01-I = SPACES
    MOVE INDIC-ON  TO IN32 OF ZZFT01-O-INDIC
    MOVE "Y" TO WS-ERROR
    MOVE "OEM0012" TO MSGID
    CALL "RTNMSGTEXT" USING MSGID WS-ERRMSG
    GO VALID1-EXIT
END-IF
```

## ZBCONHDR — Contract Header Maintenance
- **Description:** Maintains contract header records, validating customer links, order status, and sales rep assignments; provides prompts and cascade deletes.
- **Inputs:** Display file `WCONHDRD` subfiles; files `CONHDR`, `CUSTS`, `ORDSTS`, `SLMEN`.
- **Outputs:** Updates to `CONHDR`; messages via `RTNMSGTEXT`; optional delete confirmation via `ZZCNF1` screen.
- **Sections:**
  - `VALIDT-ROUTINE` enforces non-zero contract numbers, uniqueness on add, and reference integrity.
  - `SRPROM-ROUTINE` calls selectors (`CUSTSSEL`, `ORDSTSEL`, `SLMENSEL`).
- **Key Business Rules:** Duplicate contract numbers blocked; customer, status, and salesperson must exist; delete requests show confirmation and attempt to remove header record.
- **Snippet:**
```cobol
IF ADD-MODE
    START CONHDR-FILE KEY EQUAL EXTERNALLY-DESCRIBED-KEY
         INVALID KEY MOVE "N" TO RECORD-FOUND
    END-START
    IF RECORD-FOUND = "N"
       MOVE "Y2U0003" TO MSGID
       CALL "RTNMSGTEXT" USING MSGID WS-ERRMSG
       GO VALIDT-EXIT
    END-IF
END-IF
```

## ZBCONDET — Contract Detail Maintenance
- **Description:** Provides subfile-based maintenance for contract line items, integrating item master data and status validation, plus printer spool generation.
- **Inputs:** Display file `WCONDETD`; files `CONDET`, `CONHDR`, `CUSTS`, `STKMAS`, `STOMAS`, `STKBAL`, `ORDSTS`, `SLMEN`, `TRNTYP`.
- **Outputs:** Updated `CONDET`, refreshed subfiles, `CONDET-REPORT` spooled output, and status messages.
- **Sections:**
  - `INIT-ROUTINE` loads header/customer context.
  - `PROCESS-SUBFILE-RECORD` routes add/change/delete/display actions.
  - `VALIDT-ROUTINE` checks contract number validity and reference table existence before committing updates.
- **Key Business Rules:** Contract number must be non-zero and pre-existing; customer, order status, and salesperson must resolve; invalid references trigger message retrieval via `RTNMSGTEXT`.
- **Snippet:**
```cobol
IF XWORDN OF ZZFT01-O = ZEROS
    MOVE "Y" TO WS-ERROR
    MOVE "OEM0010" TO MSGID
    CALL "RTNMSGTEXT" USING MSGID WS-ERRMSG
    GO VALIDT-EXIT
END-IF
```

## ZBTRNHST — Transaction History Inquiry
- **Description:** Displays and prints chronological transaction records for a selected customer.
- **Inputs:** Display file `WTRNHSTD`; files `TRNHST` logicals keyed by customer.
- **Outputs:** Inquiry subfiles and optional printer file spool.
- **Sections:**
  - Initialization fetches customer context and resets subfiles.
  - Looping read populates history records and handles user navigation.
- **Key Business Rules:** Only transactions matching the provided customer code populate the subfile; printer output mirrors displayed records.

## ZBPRNCUSF — Customer Follow-up Report
- **Description:** Batch-style printer program that generates follow-up listings filtered by follow-up codes and date criteria.
- **Inputs:** `CUSFL3` logical file, selection parameters from CL or calling program.
- **Outputs:** Printer file `PRTWCUSTP` lines summarizing follow-up commitments.
- **Sections:**
  - Driver reads customer follow-up entries and formats heading/detail lines.
  - Summary counters track totals for reporting.
- **Key Business Rules:** Only customers matching selection criteria appear; totals aggregated per distribution channel.
