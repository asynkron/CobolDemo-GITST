# DLYFAXSHT.CLP Member Guide

## Overview
Control Language (CL) program `DLYFAXSHT` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `DLYFAXSHT`.
- **Outgoing:**
  - Calls programs: FAXSHT1

## Source
````cl
PGM          (&SKL &NRDS)
             DCL &SKL *CHAR 6 /* Letter No. */
             DCL &NRDS *DEC (3 0) /* Generate No */

             SBMJOB     CMD(CALL FAXSHT1 (&SKL &NRDS)) +
                          JOB(FAXSHT) JOBD(FAXJOBD) SCDTIME(200000)
          /* MONMSG     MSGID(CPF0000)  */
ENDPGM
````
