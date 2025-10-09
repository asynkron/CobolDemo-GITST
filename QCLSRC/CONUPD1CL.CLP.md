# CONUPD1CL.CLP Member Guide

## Overview
Control Language (CL) program `CONUPD1CL` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `CONUPD1CL`.
- **Outgoing:**
  - Calls programs: CONUPD1

## Source
````cl
             PGM
             CALL       PGM(CONUPD1)
             CHGDTAARA  DTAARA(TSTPROCESS *ALL) VALUE('Updated value')
             ENDPGM
````
