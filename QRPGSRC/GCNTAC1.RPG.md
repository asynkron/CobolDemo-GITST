# GCNTAC1.RPG Member Guide

## Overview
RPG III program `GCNTAC1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `GCNTAC1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
      * SIMON       24/02/06  A0000001    Default Audit, delete if not required
     FCUSFL3  IF  E           K        DISK
     FCNTACS  O   E                    DISK
     E                    PK         10 50
     C           *ENTRY    PLIST
     C                     PARM           PK
     C                     MOVELPK,1      CUSNO
     C**                   MOVELPK,2      CUSNO
     C           CUSNO     CHAINCUSFL3               LR
     C  NLR                WRITERCNTAC
     C                     SETON                     LR
````
