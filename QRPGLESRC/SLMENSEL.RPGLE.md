# SLMENSEL.RPGLE Member Guide

## Overview
ILE RPG program `SLMENSEL` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `SLMENSEL`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     FSLMNSELD  CF   E             WORKSTN
     F                                     SFILE(ZZSFL:SFLRRN)
     FSLMEN     IF   E           K DISK
     C*******************************************************************
     C*M a i n l i n e   C o d e
     C*******************************************************************
     C*Build subfile
     C***                EXSR      ZCLRFLD
     C                   EXSR      ZBUILD
     C*Until Exit/Cancel
     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C*Display screen                                                                     |
     C                   EXFMT     ZZCTL                                                   |
     C*If Exit/Cancel                                                                     |
     C     *IN03         IFEQ      '1'                                          B--------02|
     C     *IN12         OREQ      '1'                                                    ||
     C***                  MOVE *BLANKS   PER                                             ||
     C***                  MOVE *BLANKS   PARNAM                                          ||
     C***                  MOVE *BLANKS   PCATG                                           ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*If selection made                                                                  |
     C                   READC     ZZSFL                                  30               |
     C     *IN30         IFEQ      '0'                                          B--------02|
     C                   MOVEL     PERSON        PER                                      ||
     C                   MOVEL     PNAME         PARNAM                                   ||
     C***                MOVEL     PCATG         PCATGS                                   ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*End: Until Exit/Cancel                                                             |
     C                   ENDDO                                                  E---------01
     C*Terminate program
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*******************************************************************
     C* L o g i c a l   E n d   o f   P r o g r a m
     C*******************************************************************
     C*******************************************************************
     C     ZBUILD        BEGSR
     C******************************************************************
     C*Subroutine: Build subfile
     C******************************************************************
     C                   MOVE      *ZEROS        SFLRRN            5 0
     C     *LOVAL        SETLL     SLMEN
     C                   READ(N)   SLMEN                                  31
     C     *IN31         DOWEQ     '0'                                          B---------01
     C                   ADD       1             SFLRRN                                    |
     C                   WRITE     ZZSFL                                                   |
     C                   READ(N)   SLMEN                                  31               |
     C                   ENDDO                                                  E---------01
     C     SFLRRN        IFGT      0                                            B---------01
     C                   MOVE      '1'           *IN31                                     |
     C***                MOVE      '0'           *IN81                                     |
     C                   ENDIF                                                  E---------01
     C                   ENDSR
     C*******************************************************************
     C*******************************************************************
     C*N o n - e x e c u t a b l e   C o d e
     C*******************************************************************
     C**ENTRY Parameter List
     C     *ENTRY        PLIST
     C                   PARM                    PER               3
     C                   PARM                    PARNAM           34
     C**********************************************************************
````
