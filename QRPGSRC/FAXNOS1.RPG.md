# FAXNOS1.RPG Member Guide

## Overview
RPG III program `FAXNOS1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `FAXNOS1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSFL9  IP  E                    DISK
     FSECF    O   E                    DISK
     E                    BL         12  1
     IFAXNO       DS
     I                                       12  12 @@12
     I                                        1  12 BL
     I                                        5   5 @@5
     I                                        9   9 @@9
      * 12th not blank & at least 2 other blanks
     C           @@12      IFNE *BLANK
     C                     Z-ADD0         BLCNT   30
     C                     DO   11        X       30
     C           BL,X      IFGT '9'
     C           BL,X      ORLT '0'
     C                     ADD  1         BLCNT
     C                     ENDIF
     C                     ENDDO
     C           BLCNT     IFGE 2
     C                     WRITERSECF
     C                     END
     C                     END
````
