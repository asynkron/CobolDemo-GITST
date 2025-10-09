# FAXERR1.RPG Member Guide

## Overview
RPG III program `FAXERR1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `FAXERR1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FSECF    IP  E                    DISK
     FCUSFL3  UF  E           K        DISK
     IFLUREF      DS
     I                                        2   60@@CUS1
     I                                        2   6 A@CUS1
     I                                        4   80@@CUS2
     I                                        4   8 A@CUS2
      * A = failure   - nothing else matters:
     C                     TESTN          A@CUS2     32
     C  N32                TESTN          A@CUS1     31
     C                     MOVELA@CUS1    FLSTAT 10
     C                     MOVELA@CUS2    FLSCOD 10
     C**                   MOVELA@CUS3    FLSCAT 10
     C           FLSTAT    IFEQ 'A'
     C           FLSCOD    ANDEQ'0006'
     C           *IN31     IFEQ *ON
     C           *IN32     OREQ *ON
     C   32      @@CUS2    CHAINCUSFL3               44
     C  N32 31   @@CUS1    CHAINCUSFL3               44
     C           *IN44     IFEQ *OFF
     C                     MOVEL'010101'  APDATE
     C**                   MOVEL'000101'  APDATE
     C                     UPDATRCUSF
     C                     ENDIF
     C                     ENDIF
     C                     ENDIF
````
