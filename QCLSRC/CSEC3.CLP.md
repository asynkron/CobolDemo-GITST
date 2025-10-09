# CSEC3.CLP Member Guide

## Overview
Control Language (CL) program `CSEC3` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `CSEC3`.
- **Outgoing:**
  - Calls programs: CSEC2

## Source
````cl
             PGM        PARM(&PK)
             DCL        VAR(&PK) TYPE(*CHAR) LEN(500)

             CALL CSEC2
         /*  MONMSG     MSGID(CPF0000)   */

             ENDPGM
````
