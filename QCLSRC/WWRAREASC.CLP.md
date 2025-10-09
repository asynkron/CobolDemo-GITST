# WWRAREASC.CLP Member Guide

## Overview
Control Language (CL) program `WWRAREASC` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `WWRAREASC`.
- **Outgoing:**
  - Calls programs: PGM

## Source
````cl
             PGM
             DCL        VAR(&REP) TYPE(*CHAR) LEN(3) VALUE('   ')

             CALL       PGM(*LIBL/WWRAREAS) PARM(&REP)
/*           MONMSG     MSGID(CPF0000)                    */

             ENDPGM
````
