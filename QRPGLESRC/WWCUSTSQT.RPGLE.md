# WWCUSTSQT.RPGLE Member Guide

## Overview
ILE RPG program `WWCUSTSQT` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `WWCUSTSQT`.
- **Outgoing:**
  - Calls programs/procedures: RTNMTX

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2007
     H*PROGRAM:  Work with Customers
     H*--------------------------------------------------------------------
     H DATEDIT(*YMD)
     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     FWCUSTSD   CF   E             WORKSTN
     F                                     SFILE(ZZSF01:SFLRRN)
     FCUSTS     UF A E           K DISK
     F                                     INFDS(FILEDS)
     FSLMEN     IF   E           K DISK
     FCUSFL3    IF   E           K DISK
     FCUSGRP    IF   E           K DISK
     FDISTS     IF   E           K DISK
     FCONHDRL1  IF   E           K DISK
     FTRNHSTL3  IF   E           K DISK
     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D*Set constants
     D RTNMTX          C                   CONST('RTNMSGTEXT')
     D INIDAT          C                   CONST('0001-01-01')

     d FILEDS          ds
     d  FILESTS               11     15s 0

     D  pageno         s              3p 0
     D  noofpages      s              3p 0 inz(2)
     D  sflrrn         s              5p 0
     D  sflchg         s              1a   inz('0')
     D  sflCTR         s              3P 0

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
     C*M a i n l i n e   C o d e
     C**********************************************************************
     C*Build subfile
     C                   EXSR      SFLWRT

     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C                   MOVE      *BLANKS       LOCATE                                    |
     C*Display screens                                                                    |
     C                   WRITE     ZZTR01                                                  |
!ADD!C                   IF        %ERROR(WCUSTSD)
     C                   WRITE     ZZMC01                                                  |
!ADD!C                   ENDIF
     C                   EXFMT     ZZCT01                                                  |
     C*Remove messages                                                                    |
     C                   CALL      'XBCCLMSG'                                              |
     C     *IN03         IFEQ      '1'                                          B--------02|
     C     *IN12         OREQ      '1'                                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*Action positioner request                                                          |
     C     LOCATE        IFNE      *BLANKS                                      B--------02|
     C                   MOVE      *ZEROS        SFLRRN                                   ||
     C                   MOVE      LOCATE        XWBCCD                                   ||
     C                   EXSR      SFLWRT                                                 ||
     C                   ITER                                                             ||
     C                   ENDIF                                                  E--------02|
     C*Action command keys                                                                |
     C     *IN28         IFEQ      '1'                                          B--------02|
     C                   EXSR      CMDKEY                                                 ||
     C                   ELSE                                                   X........02|
     C*Else action selections                                                            ||
     C                   EXSR      ZSELEC                                                 ||
     C                   ENDIF                                                  E--------02|
     C*If changes made then update display                                                |
     C     SFLCHG        IFEQ      '1'                                          B--------02|
     C                   MOVE      *LOVAL        XWBCCD                                   ||
     C                   EXSR      SFLWRT                                                 ||
     C                   ENDIF                                                  E--------02|

     C                   ENDDO                                                  E---------01

     C                   MOVE      '1'           *INLR
     C                   RETURN
     C**********************************************************************
     C*L o g i c a l   E n d   o f   P r o g r a m
     C**********************************************************************

     C**********************************************************************
     C     SFLWRT        BEGSR
     C**********************************************************************
     C*Subroutine: Write data to subfile
     C**********************************************************************
     C*Delete subfile
     C                   IF        SFLRRN = 0
     C                   SETON                                        74
     C                   SETOFF                                       717281
     C                   WRITE     ZZCT01                               99
     C                   SETOFF                                       74
     C*Write subfile
     C                   MOVE      *ZEROS        SFLRRN
     C     XWBCCD        SETLL     CUSTS
     C                   ENDIF
     C*
     C                   MOVE      *ZEROS        SFLCTR
     C     *IN81         DOWEQ     '0'                                          B---------01
     C     SFLCTR        ANDLT     12
     C                   READ(N)   CUSTS                                  81
XI   C                   IF        NOT %EOF(CUSTS)                              B---------01
     C                   ADD       1             SFLRRN                                    |
     C                   ADD       1             SFLCTR                                    |
     C                   IF        SFLCTR = 1
     C                   Z-ADD     SFLRRN        SHWREC
     C                   ENDIF
     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   WRITE     ZZSF01                               99                 |
     C                   ENDIF                                                  E---------01
     C                   ENDDO                                                  E---------01

     C     SFLRRN        IFGT      0
     C                   SETON                                        71                   |
     C                   ENDIF                                                  E---------01
     C                   SETON                                        72

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     CMDKEY        BEGSR
     C**********************************************************************
     C*Subroutine: Action command keys
     C**********************************************************************
     C                   SELECT                                                 B---------01

     C     *IN26         WHENEQ    '1'                                          W.........01
     C                   EXSR      SFLWRT                                                 ||

     C     *IN06         WHENEQ    '1'                                          W.........01
     C                   EXSR      addrec                                                 ||
     C                   Z-ADD     1             SHWREC                                    |
     C                   MOVE      '1'           SFLCHG                                    |
     C                   ENDSL                                                  E---------01

     C                   MOVE      '0'           *IN12

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     ZSELEC        BEGSR
     C**********************************************************************
     C*Subroutine: Action selection
     C**********************************************************************
     C                   MOVE      '0'           SFLCHG
     C                   READC     ZZSF01                                 35

     C*For each selection
XI   C                   DOW       NOT %EOF(WCUSTSD)                            B---------01
     C                   MOVE      '1'           SFLCHG                                    |

     C                   SELECT                                                 B--------02|
     C*Change                                                                            ||
     C     DSSEL         WHENEQ    '2'                                          W........02|
     C                   EXSR      chgrec                                                 ||
     C*Delete                                                                            ||
     C     DSSEL         WHENEQ    '4'                                                    ||
     C                   EXSR      delrec                                                 ||
     C*Display                                                                           ||
     C     DSSEL         WHENEQ    '5'                                                    ||
     C                   EXSR      dsprec                                                 ||
     C*Customer Detail Maintenance                                                       ||
     C     DSSEL         WHENEQ    '6'                                                    ||
     C                   call      'CUSTMNT1'                                             ||
     C                   parm                    XWBCCD
     C*Work with Orders                                                                  ||
     C     DSSEL         WHENEQ    '8'                                          W........02|
     C                   EXSR      ZORDER                                                 ||
     C*Work with Transaction history                                                     ||
     C     DSSEL         WHENEQ    '9'                                          W........02|
     C                   EXSR      ZHISTO                                                 ||
     C                   ENDSL                                                  E--------02|

     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   UPDATE    ZZSF01                               99                 |
     C                   READC     ZZSF01                                 35               |

     C*End: For each selection                                                            |
     C                   ENDDO                                                  E---------01

     C                   MOVE      '0'           *IN12

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     dspscns       BEGSR
     C**********************************************************************
     C*Subroutine: Display detail screens
     C**********************************************************************
     C*Display screen, depending upon page no.                                          |||
     C                   select                                                          |||
     C                   when      pageno = 1                                            |||
     C                   EXFMT     ZZFT01                                                |||
     C                   when      pageno = 2                                            |||
     C                   EXFMT     ZZFT02                                                |||
     C                   endsl                                                           |||
     C                   EXSR      MVSCDB

     C                   CALL      'XBCCLMSG'                                            |||
     C                   EXSR      OFFIND                                                |||

     C*Process Command Keys                                                             |||
     C                   SELECT                                                 B------04|||
     C*Prompt                                                                          ||||
     C     *IN04         WHENEQ    '1'                                          W......04|||
     C                   EXSR      SRPROM                                               ||||
     C*Orders                                                                          ||||
     C     *IN08         WHENEQ    '1'                                          W......04|||
     C                   EXSR      ZORDER                                               ||||
     C*Transaction history                                                             ||||
     C     *IN09         WHENEQ    '1'                                          W......04|||
     C                   EXSR      ZHISTO                                               ||||
     C                   ENDSL                                                  E------04|||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     VALID1        BEGSR
     C**********************************************************************
     C*Subroutine: Validation #1
     C**********************************************************************
     C                   DO                                                     B---------01
     C* WHEN ADDING CUSTOMER MUST NOT BE ZERO                                              |
     C     XWBCCD        IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVE      *ON           *IN31                                    ||
     C                   MOVE      'OEM0002'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C* WHEN ADDING CUSTOMER MUST NOT EXIST                                                |
     C     ACTDSP        IFEQ      'ADDITION'                                   B--------02|
     C     XWBCCD        SETLL     CUSTS                                  99              ||
XI   C                   IF        %EQUAL(CUSTS)                                B-------03||
     C                   MOVE      *ON           *IN31                                   |||
     C                   MOVE      'Y2U0003'     MSGID                                   |||
     C                   MOVEL     *ALL'-'       XWG4TX                                  |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID             7                     |||
     C                   PARM                    ERRMSG          132                     |||
     C                   LEAVE                                                           |||
     C                   ENDIF                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C*Customer name                                                                      |
     C     XWG4TX        IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      *ON           *IN32                                    ||
     C                   MOVE      *ON           *IN99                                    ||
     C                   MOVE      'OEM0012'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- CUSTOMER GROUP                                                                    |
     C     XWBNCD        CHAIN     CUSGRP                             99                   |
XI   C                   IF        NOT %FOUND(CUSGRP)                           B--------02|
     C                   MOVE      '1'           *IN33                                    ||
     C                   MOVE      'OES0374'     MSGID                                    ||
     C                   MOVEL     *ALL'-'       XWKHTX                                   ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- SALESMAN                                                                          |
     C     PERSON        CHAIN     SLMEN                              99                   |
XI   C                   IF        NOT %FOUND(SLMEN)                            B--------02|
     C                   MOVE      '1'           *IN34                                    ||
     C                   MOVE      'OEM0023'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   MOVE      *ALL'-'       PNAME                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- Distributor                                                                       |
     C     DSDCDE        CHAIN     DISTS                              99                   |
XI   C                   IF        NOT %FOUND(DISTS)                            B--------02|
     C                   MOVE      '1'           *IN35                                    ||
     C                   MOVE      'OEM0018'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   MOVE      *ALL'-'       DNAME                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C                   ENDDO                                                  E---------01
     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     VALID2        BEGSR
     C**********************************************************************
     C*Subroutine: Validation #2
     C**********************************************************************
     C                   DO                                                     B---------01
     C*- BALANCE                                                                           |
     C     ACTDSP        IFNE      'ADDITION'                                   B--------02|
     C     XWGIVA        SUB       XWIDV0        XDIFF            15 2                    ||
     C     XDIFF         IFLT      *ZERO                                        B-------03||
     C                   MOVE      '1'           *IN99                                   |||
     C                   MOVE      '1'           *IN36                                   |||
     C                   MOVE      'OES0373'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID             7                     |||
     C                   PARM                    ERRMSG          132                     |||
     C                   LEAVE                                                           |||
     C                   ENDIF                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C*- CUSTOMER CANNOT BE ZERO                                                           |
     C     CUSNO         IFEQ      *ZEROS                                       B--------02|
     C                   MOVE      '1'           *IN37                                    ||
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVE      'CNP0008'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- CUSTOMER                                                                          |
     C     CUSNO         CHAIN     CUSFL3                             99                   |
XI   C                   IF        NOT %FOUND(CUSFL3)                           B--------02|
     C                   MOVE      '1'           *IN37                                    ||
     C                   MOVE      'CNP0002'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C                   ENDDO                                                  E---------01
     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     ADDREC        BEGSR
     C**********************************************************************
     C*Subroutine: Add a record
     C**********************************************************************
     C                   MOVE      '0'           *IN94
     C                   MOVE      '1'           *IN96
     C                   MOVE      '0'           *IN97
     C                   MOVEL     'ADDITION'    ACTDSP
     C                   EXSR      OFFIND

     C                   clear                   custsr
     C                   eval      pname = *blanks                                         |
     C                   eval      dname = *blanks                                         |
     C                   eval      xwkhtx = *blanks                                        |
     C                   exsr      mvdbsc

     C                   eval      pageno = 1                                              |

     C*For each screen page                                                             |||
     C                   dow       pageno <= noofpages                                   |||

     C                   EXSR      DSPSCNS

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||

     C     *IN04         IFEQ      '1'                                          B------04|||
     C     *IN08         OREQ      '1'                                                  ||||
     C     *IN09         OREQ      '1'                                                  ||||
     C                   ITER                                                           ||||
     C                   ENDIF                                                  E------04|||

     C                   select                                                          |||
     C                   when      pageno = 1                                            |||
     C                   EXSR      VALID1                                               ||||
     C                   when      pageno = 2                                            |||
     C                   EXSR      VALID2                                               ||||
     C                   endsl                                                           |||

     C*If errors found                                                                 ||||
XI   C                   IF        NOT %FOUND(CUSFL3)                           B-----05||||
     C*Display error message and re-display screen                                     ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   exsr      mvdbsc
     C                   iter                                                          |||||
     C                   ENDIF                                                  E-----05||||

     C                   eval      pageno = pageno + 1                          E------04|||

     C*End: For each screen page                                                        |||
     C                   ENDDO                                                  E-------03||

     C*If not F3/F12                                                                    |||
     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||

     C*Request confirmation                                                             |||
     C                   EXFMT     ZZCNF1                                                |||
     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||
     C*If confirmation received then write record                                       |||
     C                   WRITE     CUSTSR                               99               |||
XI   C                   IF        %ERROR(CUSTS)                                B------04|||
     C                   MOVE      'Y2U0004'     MSGID                                  ||||
     C                   CALL      RTNMTX                                               ||||
     C                   PARM                    MSGID             7                    ||||
     C                   PARM                    ERRMSG          132                    ||||
     C* Display error message                                                           ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                 ||||
     C                   ENDIF                                                          ||||
     C                   ENDIF                                                          ||||

     C*End: If not F3/F12                                                               |||
     C                   ENDIF                                                          ||||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     CHGREC        BEGSR
     C**********************************************************************
     C*Subroutine: Change a record
     C**********************************************************************
     C                   MOVEL     '  UPDATE'    ACTDSP                                    |
     C                   MOVE      '0'           *IN94                                     |
     C                   MOVE      '0'           *IN96
     C                   MOVE      '0'           *IN97
     C                   EXSR      OFFIND

     C                   EXSR      GETREC                                                  |

     C*If no record or file error
XI   C                   IF        %FOUND(CUSTS)
XI   C                              AND NOT %ERROR(CUSTS)

     C                   eval      pageno = 1                                              |

     C*For each screen page                                                             |||
     C                   dow       pageno <= noofpages                                   |||

     C                   EXSR      DSPSCNS

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||

     C     *IN04         IFEQ      '1'                                          B------04|||
     C     *IN08         OREQ      '1'                                                  ||||
     C     *IN09         OREQ      '1'                                                  ||||
     C                   ITER                                                           ||||
     C                   ENDIF                                                  E------04|||

     C                   select                                                          |||
     C                   when      pageno = 1                                            |||
     C                   EXSR      VALID1                                               ||||
     C                   when      pageno = 2                                            |||
     C                   EXSR      VALID2                                               ||||
     C                   endsl                                                           |||

     C*If errors found                                                                 ||||
XI   C                   IF        NOT %FOUND(CUSFL3)                           B-----05||||
     C*Display error message and re-display screen                                     ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   exsr      mvdbsc                                              |||||
     C                   iter                                                          |||||
     C                   ENDIF                                                  E-----05||||

     C                   eval      pageno = pageno + 1                          E------04|||

     C*End: For each screen page                                                        |||
     C                   ENDDO                                                  E-------03||

     C*If not F3/F12                                                                    |||
     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||

     C*Request confirmation                                                             |||
     C                   EXFMT     ZZCNF1                                                |||
     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||
     C*If confirmation received then update record                                      |||
     C     xwbccd        chain(e)  custsr
     C                   if        %found(custs)
     C                   exsr      mvscdb
     C                   UPDATE    CUSTSR                               99               |||
XI   C                   IF        %ERROR(CUSTS)                                B------04|||
     C                   MOVE      'Y2U0007'     MSGID                                  ||||
     C                   CALL      RTNMTX                                               ||||
     C                   PARM                    MSGID             7                    ||||
     C                   PARM                    ERRMSG          132                    ||||
     C* Display error message                                                           ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                 ||||
     C                   ENDIF                                                  X......04|||
     C                   else                                                           ||||
     C                   unlock(e) custs                                                   |
     C                   endif                                                          ||||
     C                   ENDIF                                                          ||||

     C*End: If not F3/F12                                                               |||
     C                   ENDIF                                                          ||||

     C*End: If no record or file error
     C                   ENDIF                                                          ||||

     C                   MOVE      SFLRRN        SHWREC                                   ||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     DELREC        BEGSR
     C**********************************************************************
     C*Subroutine: Delete a record
     C**********************************************************************
     C                   MOVEL     '  DELETE'    ACTDSP                                    |
     C                   MOVE      '1'           *IN94
     C                   MOVE      '0'           *IN96
     C                   MOVE      '1'           *IN97                                     |
     C                   EXSR      OFFIND

     C                   EXSR      GETREC                                                  |

     C                   eval      pageno = 1                                              |

     C*For each screen page                                                             |||
     C                   dow       pageno <= noofpages                                   |||

     C                   EXSR      DSPSCNS

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||

     C     *IN04         IFEQ      '1'                                          B------04|||
     C     *IN08         OREQ      '1'                                                  ||||
     C     *IN09         OREQ      '1'                                                  ||||
     C                   ITER                                                           ||||
     C                   ENDIF                                                  E------04|||

     C                   eval      pageno = pageno + 1                          E------04|||

     C*End: For each screen page                                                        |||
     C                   ENDDO                                                  E-------03||

     C*If not F3/F12                                                                    |||
     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||

     C*Request confirmation                                                             |||
     C                   EXFMT     ZZCNF1                                                |||

     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||
     C*If confirmation received then delete record                                      |||
     C     xwbccd        chain(e)  custsr
     C                   if        %found(custs)
     C                   delete(e) custsr                                               ||||
     C                   else                                                           ||||
     C                   unlock(e) custs                                                   |
     C                   endif
     C                   ENDIF                                                          ||||

     C*End: If not F3/F12                                                               |||
     C                   ENDIF                                                          ||||

     C                   MOVE      SFLRRN        SHWREC                                   ||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     DSPREC        BEGSR
     C**********************************************************************
     C*Subroutine: Display a record
     C**********************************************************************
     C                   MOVE      '1'           *IN94
     C                   MOVE      '0'           *IN96
     C                   MOVE      '0'           *IN97
     C                   MOVEL     ' DISPLAY'    ACTDSP                                    |
     C                   EXSR      OFFIND

     C                   EXSR      GETREC                                                  |

     C                   eval      pageno = 1                                              |

     C*For each screen page                                                             |||
     C                   dow       pageno <= noofpages                                   |||

     C                   EXSR      DSPSCNS

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||

     C     *IN04         IFEQ      '1'                                          B------04|||
     C     *IN08         OREQ      '1'                                                  ||||
     C     *IN09         OREQ      '1'                                                  ||||
     C                   ITER                                                           ||||
     C                   ENDIF                                                  E------04|||

     C                   eval      pageno = pageno + 1                          E------04|||

     C*End: For each screen page                                                        |||
     C                   ENDDO                                                  E-------03||

     C                   MOVE      SFLRRN        SHWREC                                   ||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     GETREC        BEGSR
     C**********************************************************************
     C*Subroutine: Retrieve a record
     C**********************************************************************
     C     XWBCCD        CHAIN(N)  CUSTS                              9966

     C                   select                                                 B---------01
     C*If record error                                                                    |
     C                   WHEN      NOT %FOUND(CUSTS)                            B---------01
     C                   MOVE      'OES0115'     MSGID                                     |
     C                   CALL      RTNMTX                                                  |
     C                   PARM                    MSGID             7                       |
     C                   PARM                    ERRMSG          132                       |
     C                   MOVEL     ERRMSG        ZMSAGE                                    |

     C*If file error                                                                      |
     C                   WHEN      %ERROR(CUSTS)                                B---------01
     C     FILESTS       IFEQ      1218                                         B-------03||
     C                   MOVE      'Y3U9999'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID             7                     |||
     C                   PARM                    ERRMSG          132                     |||
     C                   MOVEL     ERRMSG        ZMSAGE                                  |||
     C                   ELSE                                                   E-------03||
     C                   MOVE      'OEM0004'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID             7                     |||
     C                   PARM                    ERRMSG          132                     |||
     C                   MOVEL     ERRMSG        ZMSAGE                                  |||
     C                   ENDIF                                                  X.......03||

     C*If no errors                                                                       |
     C                   other                                                  B---------01

     C*Retrieve Salesman's name                                                           |
     C     PERSON        CHAIN(E)  SLMEN                                                   |
     C                   if        not %found(slmen)                            B--------02|
     C                   eval      pname = *all'-'                                        ||
     C                   endif                                                  X.........01

     C*Retrieve Distributor's name                                                        |
     C     DSDCDE        CHAIN(E)  DISTS                                                   |
     C                   if        not %found(dists)                            B--------02|
     C                   eval      dname = *all'-'                                        ||
     C                   endif                                                  X.........01

     C*Retrieve Customer Group's name                                                     |
     C     XWBNCD        CHAIN(E)  CUSGRP                                                  |
     C                   if        not %found(cusgrp)                           B--------02|
     C                   eval      xwkhtx = *all'-'                                       ||
     C                   endif                                                  X.........01

     C                   exsr      mvdbsc

     C                   endsl                                                  X.........01

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     *INZSR        BEGSR
     C**********************************************************************
     C*Subroutine: Initialisation routines
     C**********************************************************************
     C*Initialise message subfile
     C                   MOVE      '1'           *IN82
     C                   MOVEL     'WWCUSTS '    ZZPGM
     C*-Set date
     C                   MOVE      *DATE         ZZDATE
     C                   MOVE      *YEAR         ZYR
     C                   MOVE      '-'           FILLR1
     C                   MOVE      *MONTH        ZMTH
     C                   MOVE      '-'           FILLR2
     C                   MOVE      *DAY          ZDAY
     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     SRPROM        BEGSR
     C**********************************************************************
     C*Subroutine: prompts for F04
     C**********************************************************************
     C                   SELECT                                                 B---------01
     C     SFIELD        WHENEQ    'ZPERSON'                                    W.........01
     C                   CALL      'SLMENSEL'                                              |
     C                   PARM                    ZPERSON                                   |
     C                   PARM                    PNAME                                     |
     C     SFIELD        WHENEQ    'ZCUSNO'                                     W.........01
     C                   CALL      'CUSFSEL'                                               |
     C                   PARM      *ZEROS        CUSPRM            5 0                     |
     C     CUSPRM        IFNE      *ZEROS                                       B--------02|
     C                   MOVE      CUSPRM        ZCUSNO                                   ||
     C                   ENDIF                                                  E--------02|
     C     SFIELD        WHENEQ    'ZWBNCD'                                     W.........01
     C                   CALL      'CUSGRSEL'                                              |
     C                   PARM                    ZWBNCD                                    |
     C                   PARM                    ZWKHTX                                    |
     C     SFIELD        WHENEQ    'ZDSDCDE'                                    W.........01
     C                   CALL      'DISTSSEL'                                              |
     C                   PARM                    ZDSDCDE                                   |
     C                   PARM                    DNAME                                     |
     C                   ENDSL                                                  E---------01
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

     C**********************************************************************
     C     ZORDER        BEGSR
     C**********************************************************************
     C*Subroutine: Customer Orders
     C**********************************************************************
     C*    XWBCCD        CHAIN     CONHDRL1                           77
     C*    *IN77         IFEQ      '0'                                          B---------01
     C                   CALL      'WWCONHDR'                                              |
     C                   PARM                    XWBCCD                                    |
     C*                  ELSE                                                   X.........01
     C*                  MOVE      '1'           *IN99                                     |
     C*                  MOVE      'YYG0012'     MSGID                                     |
     C*                  CALL      RTNMTX                                                  |
     C*                  PARM                    MSGID             7                       |
     C*                  PARM                    ERRMSG          132                       |
     C* Display error message                                                              |
     C*                  MOVEL     ERRMSG        ZMSAGE                                    |
     C*                  ENDIF                                                  E---------01
     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     ZHISTO        BEGSR
     C**********************************************************************
     C*Subroutine: Transaction history
     C**********************************************************************
     C*    XWBCCD        CHAIN     TRNHSTL3                           77
     C*    *IN77         IFEQ      '0'                                          B---------01
     C                   CALL      'WWTRNHST'                                              |
     C                   PARM                    XWBCCD                                    |
     C*                  ELSE                                                   X.........01
     C*                  MOVE      '1'           *IN99                                     |
     C*                  MOVE      'YYG0012'     MSGID                                     |
     C*                  CALL      RTNMTX                                                  |
     C*                  PARM                    MSGID             7                       |
     C*                  PARM                    ERRMSG          132                       |
     C* Display error message                                                              |
     C*                  MOVEL     ERRMSG        ZMSAGE                                    |
     C*                  ENDIF                                                  E---------01
     C                   ENDSR
     C**********************************************************************
     C     MVDBSC        BEGSR
     C                   MOVEL     XWBCCD        ZWBCCD                                    |
     C                   MOVEL     XWG4TX        ZWG4TX                                    |
     C                   MOVEL     XWB2CD        ZWB2CD                                    |
     C                   MOVEL     XWB3CD        ZWB3CD                                    |
     C                   MOVEL     XWHITX        ZWHITX                                    |
     C                   MOVEL     XWE0NB        ZWE0NB                                    |
     C                   MOVEL     XWJUN0        ZWJUN0                                    |
     C                   MOVEL     XWDVCD        ZWDVCD                                    |
     C                   MOVEL     XWBNCD        ZWBNCD                                    |
     C                   MOVEL     PERSON        ZPERSON                                   |
     C                   MOVEL     DSDCDE        ZDSDCDE                                   |
     C                   MOVEL     XWBTCD        ZWBTCD                                    |
     C                   MOVEL     XWGIVA        ZWGIVA                                    |
     C                   MOVEL     XWAOCD        ZWAOCD                                    |
     C                   MOVEL     XWBBCD        ZWBBCD                                    |
     C                   MOVEL     XWG4T0        ZWG4T0                                    |
     C                   MOVEL     XWC7ST        ZWC7ST                                    |
     C                   MOVEL     XWDAST        ZWDAST                                    |
     C                   MOVEL     XWBPD0        ZWBPD0                                    |
     C                   MOVEL     XWBAD0        ZWBAD0                                    |
     C                   MOVEL     XWKHTX        ZWKHTX                                    |
     C                   MOVEL     XWF0VA        ZWF0VA                                    |
     C                   MOVEL     XWASDT        ZWASDT                                    |
     C                   MOVEL     XWF0V0        ZWF0V0                                    |
     C                   MOVEL     XWBQDT        ZWBQDT                                    |
     C                   MOVEL     XWF1VA        ZWF1VA                                    |
     C                   MOVEL     XWF1V0        ZWF1V0                                    |
     C                   MOVEL     XWF2VA        ZWF2VA                                    |
     C                   MOVEL     XWF3VA        ZWF3VA                                    |
     C                   MOVEL     XWF4VA        ZWF4VA                                    |
     C                   MOVEL     XWF6VA        ZWF6VA                                    |
     C                   MOVEL     XWIDV0        ZWIDV0                                    |
     C                   MOVEL     XWGAVA        ZWGAVA                                    |
     C                   MOVEL     XWGBVA        ZWGBVA                                    |
     C                   MOVEL     XWGCVA        ZWGCVA                                    |
     C                   MOVEL     XWGDVA        ZWGDVA                                    |
     C                   MOVEL     XWGEVA        ZWGEVA                                    |
     C                   MOVEL     XWGFVA        ZWGFVA                                    |
     C                   MOVEL     XWGGVA        ZWGGVA                                    |
     C                   MOVEL     CUSNO         ZCUSNO                                    |
     C                   ENDSR
     C**********************************************************************
     C     MVSCDB        BEGSR
     C                   MOVEL     ZWBCCD        XWBCCD                                    |
     C                   MOVEL     ZWG4TX        XWG4TX                                    |
     C                   MOVEL     ZWB2CD        XWB2CD                                    |
     C                   MOVEL     ZWB3CD        XWB3CD                                    |
     C                   MOVEL     ZWHITX        XWHITX                                    |
     C                   MOVEL     ZWE0NB        XWE0NB                                    |
     C                   MOVEL     ZWJUN0        XWJUN0                                    |
     C                   MOVEL     ZWDVCD        XWDVCD                                    |
     C                   MOVEL     ZWBNCD        XWBNCD                                    |
     C                   MOVEL     ZPERSON       PERSON                                    |
     C                   MOVEL     ZDSDCDE       DSDCDE                                    |
     C                   MOVEL     ZWBTCD        XWBTCD                                    |
     C                   MOVEL     ZWGIVA        XWGIVA                                    |
     C                   MOVEL     ZWAOCD        XWAOCD                                    |
     C                   MOVEL     ZWBBCD        XWBBCD                                    |
     C                   MOVEL     ZWG4T0        XWG4T0                                    |
     C                   MOVEL     ZWC7ST        XWC7ST                                    |
     C                   MOVEL     ZWDAST        XWDAST                                    |
     C                   MOVEL     ZWBPD0        XWBPD0                                    |
     C                   MOVEL     ZWBAD0        XWBAD0                                    |
     C                   MOVEL     ZWKHTX        XWKHTX                                    |
     C                   MOVEL     ZWF0VA        XWF0VA                                    |
     C                   MOVEL     ZWASDT        XWASDT                                    |
     C                   MOVEL     ZWF0V0        XWF0V0                                    |
     C                   MOVEL     ZWBQDT        XWBQDT                                    |
     C                   MOVEL     ZWF1VA        XWF1VA                                    |
     C                   MOVEL     ZWF1V0        XWF1V0                                    |
     C                   MOVEL     ZWF2VA        XWF2VA                                    |
     C                   MOVEL     ZWF3VA        XWF3VA                                    |
     C                   MOVEL     ZWF4VA        XWF4VA                                    |
     C                   MOVEL     ZWF6VA        XWF6VA                                    |
     C                   MOVEL     ZWIDV0        XWIDV0                                    |
     C                   MOVEL     ZWGAVA        XWGAVA                                    |
     C                   MOVEL     ZWGBVA        XWGBVA                                    |
     C                   MOVEL     ZWGCVA        XWGCVA                                    |
     C                   MOVEL     ZWGDVA        XWGDVA                                    |
     C                   MOVEL     ZWGEVA        XWGEVA                                    |
     C                   MOVEL     ZWGFVA        XWGFVA                                    |
     C                   MOVEL     ZWGGVA        XWGGVA                                    |
     C                   MOVEL     ZCUSNO        CUSNO                                     |
     C                   ENDSR
     C**********************************************************************
````
