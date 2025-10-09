# SECFCPY.RPG Member Guide

## Overview
RPG III program `SECFCPY` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `SECFCPY`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H            Y
     FSECF    IF  E           K        DISK                      A
     E                    PK         10 50
     C           *ENTRY    PLIST
     C                     PARM           PK
     C                     MOVELPK,1      CUSNO
     C                     MOVELPK,2      SCDEXD
     C                     MOVELPK,3      SSRLNB
     C**                   MOVELPK,4      SSRLMA
     C           KL1       KLIST
     C                     KFLD           CUSNO
     C                     KFLD           PCODE
     C                     KFLD           SCDEXD
     C                     KFLD           SSRLNB
     C           KL1       CHAINSECF                 LR
     C  NLR                Z-ADDUDATE     SCDEXD
     C  NLR                WRITERSECF                  20
     C                     SETON                     LR
````
