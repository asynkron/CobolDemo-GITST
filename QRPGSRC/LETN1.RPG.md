# LETN1.RPG Member Guide

## Overview
RPG III program `LETN1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `LETN1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSFL3  IF  E           K        DISK
     C           *ENTRY    PLIST
     C                     PARM           CUSNO
     C                     PARM           PREFIX                          007300
     C                     PARM           LLETSQ
     C           CUSNO     CHAINCUSFL3               81
     C           PREFIX    IFEQ *BLANK
     C                     MOVE CUSNO     PREFIX
     C**                   MOVE CUSNAM    PRENAM
     C                     END
     C                     RETRN
````
