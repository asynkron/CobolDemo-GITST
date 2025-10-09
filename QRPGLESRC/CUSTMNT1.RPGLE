     H DATEDIT(*YMD)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     FCUSTMNT1FMCF   E             WORKSTN
     FCUSTS     UF A E           K DISK
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
     C*‚Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    KWBCCD           11
     C*‚Initialise message subfile
     C                   MOVE      '1'           *IN82
     C                   MOVEL     'CUSTMNT1'    ZZPGM
     C                   MOVEL     KWBCCD        SWBCCD
     C                   EXSR      GETREC
     C*-‚Set date
     C                   MOVE      *DATE         ZZDATE
     C                   MOVE      *YEAR         ZYR
     C                   MOVE      '-'           FILLR1
     C                   MOVE      *MONTH        ZMTH
     C                   MOVE      '-'           FILLR2
     C                   MOVE      *DAY          ZDAY
     C                   EXSR      SCR1
     C     *IN03         IFEQ      '0'                                          B---------01
     C                   EXSR      SCR2
     C                   ENDIF
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C**********************************************************************
     C*‚L o g i c a l   E n d   o f   P r o g r a m
     C**********************************************************************
     C     SCR1          BEGSR
     C*‚Screen One
     C     *IN99         DOUEQ     '0'                                          B---------01
     C     *IN03         OREQ      '1'                                          B---------01
     C                   EXFMT     ZZFT01                                                  |
     C*‚Prompt                                                                             |
     C     *IN04         IFEQ      '1'                                          B--------02|
     C                   EXSR      SRPROM                                                 ||
     C                   ENDIF                                                  E--------02|
     C                   EXSR      VALID1                                                  |
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************
     C     SCR2          BEGSR
     C*‚Screen One
     C     *IN99         DOUEQ     '0'                                          B---------01
     C     *IN03         OREQ      '1'                                          B---------01
     C                   EXFMT     ZZFT02                                                  |
     C*‚Prompt                                                                             |
     C     *IN04         IFEQ      '1'                                          B--------02|
     C                   EXSR      SRPROM                                                 ||
     C                   ENDIF                                                  E--------02|
     C                   EXSR      VALID2                                                  |
     C                   ENDDO
     C*‚If not F3/F12
     C     *IN03         IFNE      '1'                                          B---------01
     C                   exsr      updrec                                                  |
     C                   ENDIF                                                  E---------01

     C                   ENDSR
     C**********************************************************************
     C     VALID1        BEGSR
     C**********************************************************************
     C*‚Subroutine: Validation #1
     C**********************************************************************
     C                   eval      *in99 = *off
     C                   eval      *in31 = *off
     C                   eval      *in32 = *off
     C                   eval      *in33 = *off
     C                   eval      *in34 = *off
     C                   eval      *in35 = *off
     C                   eval      errmsg = *blanks
     C*
     C* CUSTOMER MUST NOT BE BLANK                                                         |
     C     SWBCCD        IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVE      *ON           *IN31                                    ||
     C                   MOVE      'OEM0002'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   ENDIF                                                  E--------02|
     C*
     C*‚Customer name                                                                      |
     C     SWG4TX        IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      *ON           *IN32                                    ||
     C                   MOVE      *ON           *IN99                                    ||
     C                   MOVE      'OEM0012'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   ENDIF                                                  E--------02|
      *‚Customer group                                                                     |
     C     SWBNCD        setll     CUSGRP                                                  |
     C     SWBNCD        reade     CUSGRP                                                  |
     C                   IF        %eof and                                     B--------02|
     C                             swbncd <> *blanks
     C                   MOVE      '1'           *IN33                                    ||
     C                   MOVE      'OES0374'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   ELSE                                                   E--------02|
     C                   MOVEL     XWKHTX        SWKHTX                                   ||
     C                   ENDIF                                                  E--------02|
      *‚Salesman                                                                           |
     C     SPERSON       CHAIN     SLMEN                              99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN34                                    ||
     C                   MOVE      'OEM0023'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   ENDIF                                                  E--------02|
      *‚Distributor                                                                        |
     C     SDSDCDE       CHAIN     DISTS                              99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN35                                    ||
     C                   MOVE      'OEM0018'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   ENDIF                                                  E--------02|
     C                   MOVEL     ERRMSG        ZMSAGE                                   ||
     C*
     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     VALID2        BEGSR
     C**********************************************************************
     C*‚Subroutine: Validation #2
     C**********************************************************************
     C                   eval      *in99=*off
      *
     C*‚Balance                                                                            |
     C     SWGIVA        SUB       SWIDV0        SDIFF            15 2                    ||
     C     SDIFF         IFLT      *ZERO                                        B-------03||
     C                   MOVE      '1'           *IN99                                   |||
     C                   MOVE      '1'           *IN36                                   |||
     C                   MOVE      'OES0373'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID             7                     |||
     C                   PARM                    ERRMSG          132                     |||
     C                   ENDIF                                                  E-------03||
     C*
     C*‚Customer cannot be zero                                                            |
     C     CUSNO         IFEQ      *ZEROS                                       B--------02|
     C                   MOVE      '1'           *IN37                                    ||
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVE      'CNP0008'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   ENDIF                                                  E--------02|
     C*‚Customer                                                                           |
     C     CUSNO         CHAIN     CUSFL3                             99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN37                                    ||
     C                   MOVE      'CNP0002'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   MOVEL     ERRMSG        ZMSAGE                                   ||
     C                   ENDIF                                                  E--------02|
     C*
     C                   ENDSR
     C**********************************************************************
     C     GETREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Retrieve a record
     C**********************************************************************
     C     SWBCCD        CHAIN(N)  CUSTSR                             9966
      *
     C*‚Main data                                                                         ||
     C                   eval      SWBCCD=XWBCCD                                          ||
     C                   eval      SWG4TX=XWG4TX                                          ||
     C                   eval      SWB2CD=XWB2CD                                          ||
     C                   eval      SWB3CD=XWB3CD                                          ||
     C                   eval      SWHITX=XWHITX                                          ||
     C                   eval      SWE0NB=XWE0NB                                          ||
     C                   eval      SWJUN0=XWJUN0                                          ||
     C                   eval      SWDVCD=XWDVCD                                          ||
     C                   eval      SWBNCD=XWBNCD                                          ||
     C                   eval      SPERSON=PERSON                                         ||
     C*                  eval      PNAME =PNAME                                           ||
     C                   eval      SDSDCDE=DSDCDE                                         ||
     c                   eval      SWBTCD=XWBTCD                                          ||
     C                   eval      SWGIVA=XWGIVA                                          ||
     C                   eval      SWAOCD=XWAOCD                                          ||
     C                   eval      SWBBCD=XWBBCD                                          ||
     C                   eval      SWG4T0=XWG4T0                                          ||
     C                   eval      SWC7ST=XWC7ST                                          ||
     C                   eval      SWDAST=XWDAST                                          ||
     C                   eval      SWBPD0=XWBPD0                                          ||
     C                   eval      SWBAD0=XWBAD0                                          ||
     C                   eval      SWARDT=XWARDT                                          ||
     C                   eval      ZMSAGE=ZMSAGE                                          ||
     C                   eval      SWKHTX=XWKHTX                                          ||
     C*                  eval      DNAME =DNAME                                           ||
     C*‚Sales data                                                                        ||
     C                   eval      SWF0VA=XWF0VA                                          ||
     C                   eval      SWASDT=XWASDT                                          ||
     C                   eval      SWF0V0=XWF0V0                                          ||
     C                   eval      SWBQDT=XWBQDT                                          ||
     C                   eval      SWF1VA=XWF1VA                                          ||
     C                   eval      SWF1V0=XWF1V0                                          ||
     C                   eval      SWF2VA=XWF2VA                                          ||
     C                   eval      SWF3VA=XWF3VA                                          ||
     C                   eval      SWF4VA=XWF4VA                                          ||
     C                   eval      SWF6VA=XWF6VA                                          ||
     C                   eval      SWIDV0=XWIDV0                                          ||
     C                   eval      SWGAVA=XWGAVA                                          ||
     C                   eval      SWGBVA=XWGBVA                                          ||
     C                   eval      SWGCVA=XWGCVA                                          ||
     C                   eval      SWGDVA=XWGDVA                                          ||
     C                   eval      SWGEVA=XWGEVA                                          ||
     C                   eval      SWGFVA=XWGFVA                                          ||
     C                   eval      SWGGVA=XWGGVA                                          ||
     C                   exsr      zgetnames                                              ||
     C*
     C                   ENDSR
     C**********************************************************************
     C     UPDREC        BEGSR
     C     SWBCCD        CHAIN     CUSTSR                             9966
     C                   IF        %FOUND(CUSTS)
     C                   EVAL      XWBCCD=SWBCCD
     C                   EVAL      XWG4TX=SWG4TX
     C                   EVAL      XWB2CD=SWB2CD
     C                   EVAL      XWB3CD=SWB3CD
     C                   EVAL      XWHITX=SWHITX
     C                   EVAL      XWE0NB=SWE0NB
     C                   EVAL      XWJUN0=SWJUN0
     C                   EVAL      XWDVCD=SWDVCD
     C                   EVAL      XWBNCD=SWBNCD
     c                   EVAL      XWBTCD=SWBTCD
     C                   EVAL      XWGIVA=SWGIVA
     C                   EVAL      XWAOCD=SWAOCD
     C                   EVAL      XWBBCD=SWBBCD
     C                   EVAL      XWG4T0=SWG4T0
     C                   EVAL      XWC7ST=SWC7ST
     C                   EVAL      XWDAST=SWDAST
     C                   EVAL      XWBPD0=SWBPD0
     C                   EVAL      XWBAD0=SWBAD0
     C                   EVAL      XWARDT=SWARDT
     C                   EVAL      XWKHTX=SWKHTX
     C                   EVAL      XWF0VA=SWF0VA
     C                   EVAL      XWASDT=SWASDT
     C                   EVAL      XWF0V0=SWF0V0
     C                   EVAL      XWBQDT=SWBQDT
     C                   EVAL      XWF1VA=SWF1VA
     C                   EVAL      XWF1V0=SWF1V0
     C                   EVAL      XWF2VA=SWF2VA
     C                   EVAL      XWF3VA=SWF3VA
     C                   EVAL      XWF4VA=SWF4VA
     C                   EVAL      XWF6VA=SWF6VA
     C                   EVAL      XWIDV0=SWIDV0
     C                   EVAL      XWGAVA=SWGAVA
     C                   EVAL      XWGBVA=SWGBVA
     C                   EVAL      XWGCVA=SWGCVA
     C                   EVAL      XWGDVA=SWGDVA
     C                   EVAL      XWGEVA=SWGEVA
     C                   EVAL      XWGFVA=SWGFVA
     C                   EVAL      XWGGVA=SWGGVA
     C                   EVAL      PERSON=SPERSON
     C                   EVAL      DSDCDE=SDSDCDE
     C                   UPDATE    CUSTSR                               99
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************
     C     SRPROM        BEGSR
     C**********************************************************************
     C*‚Subroutine: prompts for F04
     C**********************************************************************
     C                   SELECT                                                 B---------01
     C     SFIELD        WHENEQ    'SPERSON'                                    W.........01
     C                   CALL      'SLMENSEL'                                              |
     C                   PARM                    SPERSON                                   |
     C                   PARM                    PNAME                                     |
     C     SFIELD        WHENEQ    'CUSNO'                                      W.........01
     C                   CALL      'CUSFSEL'                                               |
     C                   PARM      *ZEROS        CUSPRM            5 0                     |
     C     CUSPRM        IFNE      *ZEROS                                       B--------02|
     C                   MOVE      CUSPRM        CUSNO                                    ||
     C                   ENDIF                                                  E--------02|
     C     SFIELD        WHENEQ    'SWBNCD'                                     W.........01
     C                   CALL      'CUSGRSEL'                                              |
     C                   PARM                    SWBNCD                                    |
     C                   PARM                    SWKHTX                                    |
     C     SFIELD        WHENEQ    'SDSDCDE'                                    W.........01
     C                   CALL      'DISTSSEL'                                              |
     C                   PARM                    SDSDCDE                                   |
     C                   PARM                    DNAME                                     |
     C                   ENDSL                                                  E---------01
     C                   ENDSR
     C**********************************************************************
     C     ZGETNAMES     BEGSR
     C**********************************************************************
     C*‚Subroutine: Retrieve names for codes
     C**********************************************************************
     C     SWBNCD        CHAIN(E)  CUSGRP                                                  |
     C                   MOVEL     XWKHTX        SWKHTX                                   ||
     C     SPERSON       CHAIN(E)  SLMEN                                                   |
     C     SDSDCDE       CHAIN(E)  DISTS                                                   |
     C                   ENDSR                                                  E--------02|
     C**********************************************************************
