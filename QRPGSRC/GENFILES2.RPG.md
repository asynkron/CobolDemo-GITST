# GENFILES2.RPG Member Guide

## Overview
RPG III program `GENFILES2` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `GENFILES2`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
      *
      *  Example program to demostrate Synonym generation
      *
      *  X@LIST gives a different length error
      *
      *  DEAL will generate synonyms for   DEALDA   field RECIA
      *     a size/type error occurs in    DEALDB   field CUS
      *     a missing field warning in     DEALH    field DLNO
      *
      *
     FX@LIST  UF  F     200            DISK
      *
     FDEAL    IF  F     250  6AI     2 DISK
      *
     IX@LIST  NS
     I                                        1   2 #SECT
     I                                        3  12 #OBJ
     I                                       13  18 #SUBR
     I                                       19  20 #OBTYP
     I                                       21  21 #RCTYP
     I                                    P  22  299#LSEQ
     I                                       30 103 #TEXT
     I                                      191 200 #EXTRA
     IDEAL    NS  02   1 CD  13 CA
     I                                        1   1 RECIA
     I                                        2   7 DLNOA
     I                                        8  17 CUSA
     I                                    P  18  220AMT
     I                                       32  50 DLNM
     I        NS  03   1 CD  13 CB
     I                                        1   1 RECI
     I                                        2   7 DLNOB
     I                                       32  50 DLNM
     I                                       60  70 COMET
     I                                        8  180CUS
     I                                    P  18  220AMT
     IDEAL    NS  01   1 CH
     I                                        1   1 RECI
     I                                        8  17 CUS
     I                                    P  18  210NORECS
     I                                    P  22  290HASH
````
