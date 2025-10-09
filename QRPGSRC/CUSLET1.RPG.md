# CUSLET1.RPG Member Guide

## Overview
RPG III program `CUSLET1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CUSLET1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     E                    DT        100 80
     E                    KY         20 80
     I@DATA       DS                           8000
     I@CURKY      DS                           1600
     I@PK         DS                            500
      * Standard Action Exit Program (Local Call):
      ****************************************************************
     C           *ENTRY    PLIST
     C                     PARM           @CURKY
     C                     PARM           @DATA
     C                     MOVEA@CURKY    KY
     C                     MOVEA@DATA     DT
     C                     EXSR XXACT
     C                     SETON                     LR
     C                     RETRN
      ****************************************************************
      * User Validation/Action Code:
     C           XXACT     BEGSR
     C                     MOVELKY,1      @PK
     C                     CALL 'CLET'
     C                     PARM           @PK
     C                     ENDSR
      ****************************************************************
````
