# SECFO.RPG Member Guide

## Overview
RPG III program `SECFO` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `SECFO`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FSECF    IP  E                    DISK
     FCUSFL3  IF  E           K        DISK                      A
     FCUSFL3O IF  E           K        DISK
     F            RCUSF                             KRENAMEXX
     C           CUSNO     IFNE @CUSNO
     C                     Z-ADDCUSNO     @CUSNO
     C**                   Z-ADDCUSNAM    @CUSNAM
     C           *LIKE     DEFN CUSNO     @CUSNO
     C           CUSNO     SETLLCUSFL3                   30
     C           *IN30     IFEQ *OFF
     C           CUSNO     CHAINCUSFL3O              81
     C                     WRITERCUSF
     C                     ENDIF
     C                     ENDIF
````
