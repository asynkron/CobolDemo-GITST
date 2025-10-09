# ORDAUDIT01.CLP Member Guide

## Overview
Control Language (CL) program `ORDAUDIT01` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `ORDAUDIT01`.
- **Outgoing:**
  - Calls programs: ORDAUDIT1

## Source
````cl
             PGM

             CALL       PGM(ORDAUDIT1)
             MONMSG     MSGID(CPF0000)

             RETURN
````
