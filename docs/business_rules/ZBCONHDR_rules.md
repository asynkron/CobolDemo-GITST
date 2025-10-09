# Business Rules — ZBCONHDR Contract Header Maintenance
Generated using SSADM Structured Natural Language format.

- [BR-001](#rule-id-br-001)
- [BR-002](#rule-id-br-002)
- [BR-003](#rule-id-br-003)
- [BR-004](#rule-id-br-004)
- [BR-005](#rule-id-br-005)

### Rule ID: BR-001
**Name:** Contract Number Required
**Type:** Validation
**Applies To:** CONHDR
**Description:**

>IF the contract number entered is zero
THEN raise message `OEM0010`, set an error indicator, and stop processing

**Rationale:** Prevent insertion of invalid header keys.
**Source:** `VALIDT-ROUTINE`, `ZBCONHDR.CBL`
**Affected Processes:** ZBCONHDR, ZBCONDET

**Example:**
```cobol
       IF XWORDN OF ZZFT01-O = ZEROS
           MOVE INDIC-ON TO IN40 OF ZZFT01-O-INDIC
           MOVE "OEM0010" TO MSGID
           CALL "RTNMSGTEXT"
       END-IF
```
---

### Rule ID: BR-002
**Name:** No Duplicate Contract on Add
**Type:** Constraint
**Applies To:** CONHDR
**Description:**

>IF the user is in add mode AND the contract number already exists in `CONHDR`
THEN block the add and display message `Y2U0003`

**Rationale:** Preserve uniqueness of contract numbers.
**Source:** `VALIDT-ROUTINE`, `ZBCONHDR.CBL`
**Affected Processes:** ZBCONHDR, ZBCONDET

**Example:**
```cobol
       IF ADD-MODE
           START CONHDR-FILE KEY EQUAL ...
           IF RECORD-FOUND = "N"
               MOVE "Y2U0003" TO MSGID
               CALL "RTNMSGTEXT"
               GO VALIDT-EXIT
           END-IF
       END-IF
```
---

### Rule ID: BR-003
**Name:** Customer Must Exist Before Saving Header
**Type:** Validation
**Applies To:** CONHDR, CUSTS
**Description:**

>IF the referenced customer code cannot be read from `CUSTS`
THEN set error indicator IN41, show message `OEM0002`, and blank the customer description

**Rationale:** Ensure contract headers reference valid customer masters.
**Source:** `VALIDT-ROUTINE`, `ZBCONHDR.CBL`
**Affected Processes:** ZBCONHDR, ZBCUSTS

**Example:**
```cobol
       READ CUSTS-FILE INVALID KEY
           MOVE INDIC-ON TO IN41 OF ZZFT01-O-INDIC
           MOVE "OEM0002" TO MSGID
           CALL "RTNMSGTEXT"
           MOVE ALL "-" TO XWG4TX OF ZZFT01-O
```
---

### Rule ID: BR-004
**Name:** Status Code Must Be Valid
**Type:** Validation
**Applies To:** CONHDR, ORDSTS
**Description:**

>IF the status code entered cannot be found in `ORDSTS`
THEN set IN42, display message `OEM0019`, and blank the status description

**Rationale:** Maintain standardized contract lifecycle statuses.
**Source:** `VALIDT-ROUTINE`, `ZBCONHDR.CBL`
**Affected Processes:** ZBCONHDR

**Example:**
```cobol
       READ ORDSTS-FILE INVALID KEY
           MOVE INDIC-ON TO IN42 OF ZZFT01-O-INDIC
           MOVE "OEM0019" TO MSGID
           CALL "RTNMSGTEXT"
           MOVE ALL "-" TO XWSDSC OF ZZFT01-O
```
---

### Rule ID: BR-005
**Name:** Sales Representative Must Exist
**Type:** Validation
**Applies To:** CONHDR, SLMEN
**Description:**

>IF the salesperson code cannot be read from `SLMEN`
THEN set IN43, display message `OEM0023`, and blank the salesperson name

**Rationale:** Ensure accountability for each contract.
**Source:** `VALIDT-ROUTINE`, `ZBCONHDR.CBL`
**Affected Processes:** ZBCONHDR, ZBCUSTS, ZBCONDET

**Example:**
```cobol
       READ SLMEN-FILE INVALID KEY
           MOVE INDIC-ON TO IN43 OF ZZFT01-O-INDIC
           MOVE "OEM0023" TO MSGID
           CALL "RTNMSGTEXT"
           MOVE ALL "-" TO PNAME OF ZZFT01-O
```
---
