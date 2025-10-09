# SLSCND1.RPGLE Member Guide

## Overview
ILE RPG program `SLSCND1` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `SLSCND1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2007 - JORGE ESTEBAN SALDEA
     H*PROGRAM:  Sales Conditions
     H*--------------------------------------------------------------------
     H DATEDIT(*YMD)
     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     FSLSCND1FM CF   E             WORKSTN
     F                                     SFILE(ZZSF01:SFLRRN)
     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D*Set constants
     D RTNMTX          C                   CONST('RTNMSGTEXT')
     D INIDAT          C                   CONST('0001-01-01')

     D  sflrrn         s              5p 0
      *
     D zdata           s             60a   dim(14) ctdata perrcd(01)
      *
     D dataload        DS
     D zcode                          3a
     D zdesc                         50a
     D zdays                          3s 0
     D zrate                          4s 2
     D                 DS                  INZ
     D  ZDATE                  1     10
     D  ZYR                    1      4
     D  FILLR1                 5      5
     D  ZMTH                   6      7
     D  FILLR2                 8      8
     D  ZDAY                   9     10

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
     C*Build subfile
     C                   EXSR      SFLWRT

     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C*Display screens                                                                    |
     C                   WRITE     ZZTR01                                                  |
     C   99              WRITE     ZZMC01                                                  |
     C                   EXFMT     ZZCT01                                                  |
     C*Remove messages                                                                    |
     C                   CALL      'XBCCLMSG'                                              |
     C     *IN03         IFEQ      '1'                                          B--------02|
     C     *IN12         OREQ      '1'                                                    ||
     C                   LEAVE                                                            ||
     C***                iter
     C                   ENDIF                                                  E--------02|
     C                   ENDDO                                                  E---------01

     C                   MOVE      '1'           *INLR
      *
     C                   RETURN
     C**********************************************************************
     C*L o g i c a l   E n d   o f   P r o g r a m
     C**********************************************************************

     C**********************************************************************
     C     SFLWRT        BEGSR
     C**********************************************************************
     C*Subroutine: Write data to subfile
     C**********************************************************************
      *Clear subfile
     C                   SETON                                        74
     C                   SETOFF                                       717281
     C                   WRITE     ZZCT01                               99
     C                   SETOFF                                       74
     C                   SETON                                        81
      *Write subfile
     C                   MOVE      *ZEROS        SFLRRN
     C                   Z-ADD     1             XIND              2 0
     C     XIND          DOWLE     14                                           B---------01
     C                   ADD       1             SFLRRN                                    |
      *                                                                                    |
     C                   MOVEA     ZDATA(XIND)   DATALOAD                                  |
     C                   eval      SCCODE=ZCODE                                            |
     C                   eval      SCDESC=ZDESC                                            |
     C                   eval      SCDAYS=ZDAYS                                            |
     C                   eval      SCRATE=ZRATE                                            |
     C**                 eval      SCDATE=ZDATE                                            |
     C                   WRITE     ZZSF01                               99                 |
     C                   ADD       1             XIND                                      |
     C                   ENDDO                                                  E---------01
      *
     C     SFLRRN        IFGT      *ZEROS                                       B---------01
      *
     C     SHWREC        IFGT      SFLRRN                                       B--------02|
     C     SHWREC        ORLT      1                                                      ||
     C                   Z-ADD     1             SHWREC                                   ||
     C                   ENDIF                                                  E--------02|
      *
     C                   SETON                                        71                   |
     C                   ENDIF                                                  E--------02|
      *
     C                   SETON                                        72
      *
     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     *INZSR        BEGSR
     C**********************************************************************
     C*Subroutine: Initialisation routines
     C**********************************************************************
     C*Initialise message subfile
     C                   MOVE      '1'           *IN82
     C                   MOVEL     'SLSCND1 '    ZZPGM
     C*-Set date
     C                   MOVE      *DATE         ZZDATE
     C                   MOVE      *YEAR         ZYR
     C**                 MOVE      *CNTR         ZCT
     C                   MOVE      '-'           FILLR1
     C                   MOVE      *MONTH        ZMTH
     C                   MOVE      '-'           FILLR2
     C                   MOVE      *DAY          ZDAY
     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     OFFIND        BEGSR
     C**********************************************************************
     C*Subroutine: Set error indicators to OFF
     C**********************************************************************
     C                   MOVE      *OFF          *IN99
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
     C                   MOVE      *OFF          *IN37
     C                   MOVE      *BLANKS       ZMSAGE
     C                   ENDSR
     C**********************************************************************
**
001Cash Payments                                     0011000*
002Payment In Advance                                0050700*
003Check Payment                                     0050500*
00430 Days of Invoice                                0030400*
00560 Days of Invoice                                0040300*
006Credit Card Payment                               0010500*
007Bank Transfer                                     0011000*
008Electronic Funds Transfer                         0011000*
009Special offering                                  0011000*
010Special offering overchange                       0040200
011Regular Discount                                  0010500
012Preferential Discount                             0101500
013Account Transfer                                  0150700
014FOB Payment                                       0050300
````
