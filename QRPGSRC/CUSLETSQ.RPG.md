# CUSLETSQ.RPG Member Guide

## Overview
RPG III program `CUSLETSQ` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CUSLETSQ`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSFL3  UF  E           K        DISK
     C           *ENTRY    PLIST
     C                     PARM           CUSNC   5
     C                     PARM           LETNR   3
     C****                 MOVE TRSNO     CUSNO
     C                     MOVE CUSNC     CUSNO
     C           CUSNO     CHAINCUSFL3               81
     C                     MOVE LETNR     LLETSQ
     C***                  MOVE LETNR     TRSNOQ
     C  N81                UPDATRCUSF
     C                     SETON                     LR
````
