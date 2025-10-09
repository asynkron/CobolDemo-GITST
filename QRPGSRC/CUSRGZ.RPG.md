# CUSRGZ.RPG Member Guide

## Overview
RPG III program `CUSRGZ` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CUSRGZ`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSFL3  UF  E           K        DISK
     FSECF    IF  E           K        DISK
     E                    PK         12 10
     C           *ENTRY    PLIST
     C                     PARM           PK
     C                     MOVELPK,1      CUSNO
     C                     MOVELPK,2      SCDEXD
     C                     MOVELPK,3      SSRLNB
     C**         *LOVAL    SETLLRSECF
     C                     READ RSECF                    81
     C           *IN81     IFEQ *OFF
     C           CUSNO     CHAINCUSFL3               82
     C           *IN82     IFEQ *OFF
     C                     UPDATRCUSF
     C                     ENDIF
     C                     ENDIF
     C                     RETRN
````
