# XTBATCH1.CLLE Member Guide

## Overview
ILE Control Language (CLLE) program `XTBATCH1` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `XTBATCH1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
             PGM
             DCL        VAR(&XREF) TYPE(*CHAR) LEN(10) +
                          VALUE('XAN$CDXAM5')
             DCL        VAR(&APPA) TYPE(*CHAR) LEN(10) +
                          VALUE('CONU1')
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
              /* Use regular lib list for first test *XA */
  TEST1:   /* TEST 1 If it succeeds we run test2 otherwise exit  */
             SNDPGMMSG  MSG('About to run XTSTAPP for RDTP1 Test1')
             XTSTAPPC   XRFLIB(&XREF) AREA(&APPA) TPNAME(CTP1) +
                          RTNCOD(&FLAG)
           SNDPGMMSG  MSG('Have run XTSTAPP for CTP1 Test1 WORKED : ')
             SNDPGMMSG &FLAG
             IF         COND(&FLAG = 'Y') THEN(GOTO CMDLBL(TEST2))
              ELSE GOTO ERROR
  TEST2:   /* Test two changing lib list so a different program is used  */
     /*    test should fail */
        /*   addlible rdwork2 */
             SNDPGMMSG  MSG('About to run XTSTAPP for RDTP2 Test2')
             XTSTAPPC   XRFLIB(&XREF) AREA(&APPA) TPNAME(RDTP2) +
                          LIBLST(*XA) RTNCOD(&FLAG)
             SNDPGMMSG  MSG('have run XTSTAPP for RDTP2 Test2 WWORKED :')
             SNDPGMMSG &FLAG
             rmvlible rdwork2
  ERROR:
 ENDPGM
````
