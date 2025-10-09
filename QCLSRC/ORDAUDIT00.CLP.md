# ORDAUDIT00.CLP Member Guide

## Overview
Control Language (CL) program `ORDAUDIT00` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `ORDAUDIT00`.
- **Outgoing:**
  - Calls programs: ORDAUDIT0

## Source
````cl
             PGM

             CALL       PGM(ORDAUDIT0)
             MONMSG     MSGID(CPF0000)

             RETURN
````
