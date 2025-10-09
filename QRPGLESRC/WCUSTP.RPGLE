     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2007 - JORGE ESTEBAN SALDEÑA
     H*ˆPROGRAM:  Customer Detail Maintenance
     H*‚--------------------------------------------------------------------
     H DATEDIT(*YMD)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     FWCUSTRP   O    E             PRINTER
     FCUSTS     IF   E           K DISK
     FSLMEN     IF   E           K DISK
     FCUSFL3    IF   E           K DISK
     FCUSGRP    IF   E           K DISK
     FDISTS     IF   E           K DISK
     FCONHDRL1  IF   E           K DISK
     FTRNHSTL3  IF   E           K DISK
     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D*‚Set constants
     D RTNMTX          C                   CONST('RTNMSGTEXT')
     D INIDAT          C                   CONST('0001-01-01')

     D  pageno         s              3p 0
     D**pagcnt         s              3p 0
     D  screen         s              1s 0
     D  noofpages      s              3p 0 inz(2)
      *
     D                 DS                  INZ
     D  ZDATE                  1     10
     D  ZYR                    1      4
     D  FILLR1                 5      5
     D  ZMTH                   6      7
     D  FILLR2                 8      8
     D  ZDAY                   9     10

     I**********************************************************************
     IRCUSF
     I              DSDCDE                      XSDCDE

     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
      *
     C                   EXSR      GETREC
     C***                EXSR      UPDREC
      *                                                                                    |
     C                   eval      SWTOTA=SWGBVA+SWGCVA+SWGDVA+SWGEVA+SWGFVA
     C                             +SWGGVA
      *
     C                   WRITE     PPFT01

     C                   MOVE      '1'           *INLR

     C                   RETURN
     C**********************************************************************
     C*‚L o g i c a l   E n d   o f   P r o g r a m
     C**********************************************************************

     C**********************************************************************
     C     GETREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Retrieve a record
     C**********************************************************************
     C     SWBCCD        CHAIN     CUSTS                              9999
      *
     C*‚Main data                                                                          |
     C                   eval      SWBCCD=XWBCCD                                           |
     C                   eval      SWG4TX=XWG4TX                                           |
     C                   eval      SWB2CD=XWB2CD                                           |
     C                   eval      SWB3CD=XWB3CD                                           |
     C                   eval      SWHITX=XWHITX                                           |
     C                   eval      SWE0NB=XWE0NB                                           |
     C                   eval      SWJUN0=XWJUN0                                           |
     C                   eval      SWDVCD=XWDVCD                                           |
     C                   eval      SWBNCD=XWBNCD                                           |
     c                   eval      SWBTCD=XWBTCD                                           |
     C                   eval      SWGIVA=XWGIVA                                           |
     C                   eval      SWAOCD=XWAOCD                                           |
     C                   eval      SWBBCD=XWBBCD                                           |
     C                   eval      SWG4T0=XWG4T0                                           |
     C                   eval      SWC7ST=XWC7ST                                           |
     C                   eval      SWDAST=XWDAST                                           |
     C                   eval      SWBPD0=XWBPD0                                           |
     C                   eval      SWBAD0=XWBAD0                                           |
     C                   eval      SWARDT=XWARDT                                           |
     C                   eval      SWKHTX=XWKHTX                                           |
     C*                  eval      DNAME =DNAME                                            |
     C*                  eval      DCITY =DCITY                                            |
     C*‚Sales data                                                                         |
     C                   eval      SWF0VA=XWF0VA                                           |
     C                   eval      SWASDT=XWASDT                                           |
     C                   eval      SWF0V0=XWF0V0                                           |
     C                   eval      SWBQDT=XWBQDT                                           |
     C                   eval      SWF1VA=XWF1VA                                           |
     C                   eval      SWF1V0=XWF1V0                                           |
     C                   eval      SWF2VA=XWF2VA                                           |
     C                   eval      SWF3VA=XWF3VA                                           |
     C                   eval      SWF4VA=XWF4VA                                           |
     C                   eval      SWF6VA=XWF6VA                                           |
     C                   eval      SWIDV0=XWIDV0                                           |
     C                   eval      SWGAVA=XWGAVA                                           |
     C                   eval      SWGBVA=XWGBVA                                           |
     C                   eval      SWGCVA=XWGCVA                                           |
     C                   eval      SWGDVA=XWGDVA                                           |
     C                   eval      SWGEVA=XWGEVA                                           |
     C                   eval      SWGFVA=XWGFVA                                           |
     C                   eval      SWGGVA=XWGGVA                                           |

     C                   ENDSR

     C**********************************************************************
     C     *INZSR        BEGSR
     C**********************************************************************
     C*‚Subroutine: Initialisation routines
     C**********************************************************************
     C*‚Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    KWBCCD           11
     C*‚Initialise message subfile
     C                   MOVE      '1'           *IN82
     C**                 MOVE      '0'           *IN90
     C                   MOVEL     'WCUSTP  '    ZZPGM
     C                   MOVEL     KWBCCD        SWBCCD
     C*-‚Set date
     C*                  MOVE      *DATE         ZZDATE
     C                   MOVE      *YEAR         ZYR
     C                   MOVE      '-'           FILLR1
     C                   MOVE      *MONTH        ZMTH
     C                   MOVE      '-'           FILLR2
     C                   MOVE      *DAY          ZDAY
      *
     C                   ENDSR
