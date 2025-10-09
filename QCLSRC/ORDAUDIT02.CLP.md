# ORDAUDIT02.CLP Member Guide

## Overview
Control Language (CL) program `ORDAUDIT02` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `ORDAUDIT02`.
- **Outgoing:**
  - Calls programs: ORDAUDIT2

## Source
````cl
             PGM

             CALL       PGM(ORDAUDIT2)
             MONMSG     MSGID(CPF0000)

             RETURN
````
