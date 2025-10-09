# WWCCONSC.CLP Member Guide

## Overview
Control Language (CL) program `WWCCONSC` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `WWCCONSC`.
- **Outgoing:**
  - Calls programs: PGM

## Source
````cl
             PGM
             DCL        VAR(&CUSTOMER) TYPE(*DEC) LEN(5 0) VALUE(0)

             CALL       PGM(*LIBL/WWCCONS) PARM(&CUSTOMER)
          /* MONMSG     MSGID(CPF0000)   */

             ENDPGM
````
