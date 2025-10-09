# WKSECFC.CLP Member Guide

## Overview
Control Language (CL) program `WKSECFC` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `WKSECFC`.
- **Outgoing:**
  - Calls programs: WKSECF

## Source
````cl
             PGM (&CUSNO)
             DCL  &CUSNO *DEC  (5 0)
             DCL  &RTN   *CHAR  1
             DCL  &CURLIB *CHAR  10
             DCL  &CUSLIB *LGL
          /* DCL  &SEC *LGL    */
             RTVJOBA  CURLIB(&CURLIB)
          /* MONMSG CPF0000 */
             CHGLIBL  CURLIB(X@PASS)
             ADDLIBLE CUSLIB *LAST
             MONMSG   MSGID(CPF0000) EXEC(CHGVAR &CUSLIB '1')
             CALL WKSECF (&CUSNO &RTN)
          /* MONMSG CPF0000 */
             IF (&CURLIB *EQ '*NONE') THEN(CHGVAR  &CURLIB '*CRTDFT')
             CHGLIBL  CURLIB(&CURLIB)
             IF (*NOT &CUSLIB) THEN(RMVLIBLE CUSLIB)
             ENDPGM
````
