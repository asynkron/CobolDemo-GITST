# FAXSHT.CLP Member Guide

## Overview
Control Language (CL) program `FAXSHT` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `FAXSHT`.
- **Outgoing:**
  - File/display interactions: QSYSPRT
  - Calls programs: FAXSHT1

## Source
````cl
PGM          (&SKL &NRDS)
             DCL &SKL *CHAR 6 /* Letter No. */
             DCL &NRDS *DEC (3 0) /* Generate No */

             OVRDBF QSKLSRC cuslib2/QFAXSRC &SKL  secure(*yes)
             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          OVRFLW(66) OUTQ(FAXSTARPRT) HOLD(*NO) +
                          OUTPTY(7) SECURE(*YES)
             CRTSRCPF    QTEMP/QLETSRC
             /*MONMSG     MSGID(CPF0000) */
             ADDPFM      QTEMP/QLETSRC  LETTER
             /*MONMSG     MSGID(CPF0000) */
             OVRDBF      QLETSRC QTEMP/QLETSRC
             CALL  FAXSHT1 (&SKL &NRDS)
             /*MONMSG     MSGID(CPF0000) */
             DLTF QTEMP/QLETSRC
ENDPGM
````
