# WKCUS8P.RPG Member Guide

## Overview
RPG III program `WKCUS8P` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `WKCUS8P`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FQLETSRC IF  F      92            DISK
     FQSYSPRT O   F     132     OA     PRINTER
     IQLETSRC AA
     I                                       13  92 SRCDTA
     C                     MOVE '1'       *INOA
     C                     READ QLETSRC                  LR
     C           *INLR     DOWEQ'0'
     C                     EXCPTPRTDET
     C                     READ QLETSRC                  LR
     C                     END
     C**
     OQSYSPRT H 00 1   OA
     O        EF 1             PRTDET
     O                         SRCDTA    80
````
