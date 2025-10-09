# GCUST1.RPG Member Guide

## Overview
RPG III program `GCUST1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `GCUST1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSFL3  IF  E           K        DISK
     F*CUSFL4  IF  E           K        DISK
     FCUSTS   O   E                    DISK
     E                    PK         10 50
     C           *ENTRY    PLIST
     C                     PARM           PK
     C                     MOVELPK,1      CUSNO
     C           CUSNO     CHAINCUSFL3               LR
     C  NLR                WRITECUSTSR
     C                     SETON                     LR
````
