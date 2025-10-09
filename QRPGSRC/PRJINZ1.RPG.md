# PRJINZ1.RPG Member Guide

## Overview
RPG III program `PRJINZ1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `PRJINZ1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
      * Initialise a Project:
     FPROJECT IF  E           K        DISK
     FPRODFT  IF  E           K        DISK
     FPROTRK  UF  E           K        DISK                      A
DBI  IAAJOBN      DS                              6
DBI  I                                        1   60AA1
     C           *ENTRY    PLIST
     C                     PARM           AAJOBN
     C           AA1       SETLLPROTRK                   81
      *
      *If no current records then initialise with defaults from PRODFT:
     C           *IN81     IFEQ *OFF
     C           AA1       CHAINPROJECT              82
     C                     MOVE XWFNDT    XWPLDT
     C                     MOVE XWFNDT    XWACDT
     C                     Z-ADDXWACQT    XWPLQT
     C           *LOVAL    SETLLPRODFT               LR
     C                     READ PRODFT                   LR
     C           *INLR     DOWEQ*OFF
     C                     ADD  1         XWSEQN
     C                     MOVE '01.01.01'XWACTM
     C                     WRITEPROTRKR
     C                     READ PRODFT                   LR
     C                     ENDDO
     C                     ENDIF
     C                     RETRN
````
