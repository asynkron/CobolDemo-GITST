# Business Rules — ZBCONDET Contract Detail Maintenance
Generated using SSADM Structured Natural Language format.

- [BR-001](#rule-id-br-001)
- [BR-002](#rule-id-br-002)
- [BR-003](#rule-id-br-003)
- [BR-004](#rule-id-br-004)
- [BR-005](#rule-id-br-005)

### Rule ID: BR-001
**Name:** Contract Number Must Be Provided
**Type:** Validation
**Applies To:** CONDET records
**Description:**

>IF the contract number entered on the detail screen is zero
THEN reject the transaction and display message `OEM0010`

**Rationale:** Prevent orphaned contract detail records.
**Source:** `VALIDT-ROUTINE`, `ZBCONDET.CBL`
**Affected Processes:** ZBCONDET

**Example:**
```cobol
       IF XWORDN OF ZZFT01-O = ZEROS
           MOVE "OEM0010" TO MSGID
           CALL "RTNMSGTEXT" USING MSGID WS-ERRMSG
       END-IF
```
---

### Rule ID: BR-002
**Name:** Contract Detail Requires Existing Header
**Type:** Validation
**Applies To:** CONDET, CONHDR
**Description:**

>IF the user is adding a detail line AND the contract header does not already exist
THEN reject the transaction and display message `Y2U0003`

**Rationale:** Maintain referential integrity between contract headers and detail lines.
**Source:** `VALIDT-ROUTINE`, `ZBCONDET.CBL`
**Affected Processes:** ZBCONDET, ZBCONHDR

**Example:**
```cobol
       IF ADD-MODE
           START CONHDR-FILE KEY EQUAL ...
           IF RECORD-FOUND = "N"
               MOVE "Y2U0003" TO MSGID
               CALL "RTNMSGTEXT"
           END-IF
       END-IF
```
---

### Rule ID: BR-003
**Name:** Customer Must Exist for Detail Maintenance
**Type:** Validation
**Applies To:** CUSTS master data
**Description:**

>IF the associated customer record cannot be read from `CUSTS`
THEN reject the update, display message `OEM0002`, and clear the customer description

**Rationale:** Ensure contract lines reference valid customers with descriptive text.
**Source:** `VALIDT-ROUTINE`, `ZBCONDET.CBL`
**Affected Processes:** ZBCONDET, ZBCUSTS

**Example:**
```cobol
       READ CUSTS-FILE INVALID KEY
           MOVE "OEM0002" TO MSGID
           CALL "RTNMSGTEXT"
           MOVE ALL "-" TO XWG4TX OF ZZFT01-O
```
---

### Rule ID: BR-004
**Name:** Order Status Code Validation
**Type:** Validation
**Applies To:** ORDSTS reference data
**Description:**

>IF the order status code entered on the detail screen is not found in `ORDSTS`
THEN display message `OEM0019` and exit validation without saving

**Rationale:** Enforce standardized order status descriptions.
**Source:** `VALIDT-ROUTINE`, `ZBCONDET.CBL`
**Affected Processes:** ZBCONDET, ZBCONHDR

**Example:**
```cobol
       READ ORDSTS-FILE INVALID KEY
           MOVE "OEM0019" TO MSGID
           CALL "RTNMSGTEXT"
           GO VALIDT-EXIT
```
---

### Rule ID: BR-005
**Name:** Sales Representative Must Be Valid
**Type:** Validation
**Applies To:** SLMEN reference data
**Description:**

>IF the salesperson code on the detail screen cannot be found in `SLMEN`
THEN display message `OEM0023` and reject the change

**Rationale:** Ensure each contract line references a legitimate sales representative.
**Source:** `VALIDT-ROUTINE`, `ZBCONDET.CBL`
**Affected Processes:** ZBCONDET, ZBCONHDR, ZBCUSTS

**Example:**
```cobol
       READ SLMEN-FILE INVALID KEY
           MOVE "OEM0023" TO MSGID
           CALL "RTNMSGTEXT"
           GO VALIDT-EXIT
```
---
