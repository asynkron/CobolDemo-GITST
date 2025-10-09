# Business Rules — ZBCUSTS Customer Master Maintenance
Generated using SSADM Structured Natural Language format.

- [BR-001](#rule-id-br-001)
- [BR-002](#rule-id-br-002)
- [BR-003](#rule-id-br-003)
- [BR-004](#rule-id-br-004)
- [BR-005](#rule-id-br-005)
- [BR-006](#rule-id-br-006)
- [BR-007](#rule-id-br-007)

### Rule ID: BR-001
**Name:** Customer Code Required
**Type:** Validation
**Applies To:** CUSTS
**Description:**
IF the customer code field is blank
THEN flag an error, show message `OEM0002`, and exit validation
**Rationale:** Prevent creation of customer records without identifiers.
**Source:** `VALID1-ROUTINE`, `ZBCUSTS.CBL`
**Affected Processes:** ZBCUSTS

**Example:**
```cobol
       IF XWBCCD OF ZZSF01-I = SPACES
           MOVE "Y" TO WS-ERROR
           MOVE "OEM0002" TO MSGID
           CALL "RTNMSGTEXT"
       END-IF
```
---

### Rule ID: BR-002
**Name:** No Duplicate Customer on Addition
**Type:** Constraint
**Applies To:** CUSTS
**Description:**
IF the screen is in addition mode AND the customer code already exists
THEN block the add and display message `Y2U0003`
**Rationale:** Maintain unique customer identifiers.
**Source:** `VALID1-ROUTINE`, `ZBCUSTS.CBL`
**Affected Processes:** ZBCUSTS

**Example:**
```cobol
       IF ACTDSP OF ZZFT01-O = "ADDITION"
           START CUSTS-FILE KEY EQUAL ...
           IF RECORD-FOUND = "N"
               MOVE "Y2U0003" TO MSGID
               CALL "RTNMSGTEXT"
           END-IF
       END-IF
```
---

### Rule ID: BR-003
**Name:** Customer Name Must Be Supplied
**Type:** Validation
**Applies To:** CUSTS
**Description:**
IF the customer name field is blank
THEN set indicator IN32, raise message `OEM0012`, and reject the transaction
**Rationale:** Guarantee descriptive information for customer service users.
**Source:** `VALID1-ROUTINE`, `ZBCUSTS.CBL`
**Affected Processes:** ZBCUSTS

**Example:**
```cobol
       IF ZWG4TX OF ZZFT01-I = SPACES
           MOVE INDIC-ON TO IN32 OF ZZFT01-O-INDIC
           MOVE "OEM0012" TO MSGID
           CALL "RTNMSGTEXT"
       END-IF
```
---

### Rule ID: BR-004
**Name:** Customer Group Must Exist
**Type:** Validation
**Applies To:** CUSGRP reference data
**Description:**
IF the customer group code cannot be found in `CUSGRP`
THEN set indicator IN33, display message `OES0374`, and clear the group description
**Rationale:** Enforce controlled hierarchy assignments.
**Source:** `VALID1-ROUTINE`, `ZBCUSTS.CBL`
**Affected Processes:** ZBCUSTS

**Example:**
```cobol
       READ CUSGRP-FILE INVALID KEY
           MOVE INDIC-ON TO IN33 OF ZZFT01-O-INDIC
           MOVE "OES0374" TO MSGID
           CALL "RTNMSGTEXT"
```
---

### Rule ID: BR-005
**Name:** Sales Representative Validation
**Type:** Validation
**Applies To:** SLMEN
**Description:**
IF the assigned salesperson code is not found in `SLMEN`
THEN set indicator IN34, display message `OEM0023`, and blank the salesperson name
**Rationale:** Ensure accountability for customer ownership.
**Source:** `VALID1-ROUTINE`, `ZBCUSTS.CBL`
**Affected Processes:** ZBCUSTS, ZBCONHDR

**Example:**
```cobol
       READ SLMEN-FILE INVALID KEY
           MOVE INDIC-ON TO IN34 OF ZZFT01-O-INDIC
           MOVE "OEM0023" TO MSGID
           CALL "RTNMSGTEXT"
```
---

### Rule ID: BR-006
**Name:** Distributor Code Validation
**Type:** Validation
**Applies To:** DISTS
**Description:**
IF the distributor code cannot be read from `DISTS`
THEN set indicator IN35, show message `OEM0018`, and clear the distributor name
**Rationale:** Maintain integrity of distribution assignments.
**Source:** `VALID1-ROUTINE`, `ZBCUSTS.CBL`
**Affected Processes:** ZBCUSTS

**Example:**
```cobol
       READ DISTS-FILE INVALID KEY
           MOVE INDIC-ON TO IN35 OF ZZFT01-O-INDIC
           MOVE "OEM0018" TO MSGID
           CALL "RTNMSGTEXT"
```
---

### Rule ID: BR-007
**Name:** Follow-up Metrics Must Be Positive
**Type:** Validation
**Applies To:** CUSFL3, Customer metrics
**Description:**
IF the follow-up customer number is zero OR the follow-up record does not exist
THEN set indicator IN37, display `CNP0008` or `CNP0002`, and reject the update
**Rationale:** Prevent invalid follow-up references and maintain positive identifiers.
**Source:** `VALID2-ROUTINE`, `ZBCUSTS.CBL`
**Affected Processes:** ZBCUSTS

**Example:**
```cobol
       IF ZCUSNO OF ZZFT02-I = ZEROS
           MOVE "CNP0008" TO MSGID
           CALL "RTNMSGTEXT"
       ELSE
           READ CUSFL3-FILE INVALID KEY
               MOVE "CNP0002" TO MSGID
               CALL "RTNMSGTEXT"
       END-IF
```
---
