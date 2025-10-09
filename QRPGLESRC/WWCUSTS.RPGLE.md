# WWCUSTS.RPGLE Member Guide

## Overview
ILE RPG program `WWCUSTS` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `WWCUSTS`.
- **Outgoing:**
  - Calls programs/procedures: RTNMTX

## Source
````rpg
     H* Changed on March 11th 2013
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
     C   99              WRITE     ZZMC01                                                  |
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
     C     *IN81         IFEQ      '0'                                          B---------01
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
     C     *IN35         DOWEQ     '0'                                          B---------01
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
     C     VALID1        BEGSR
     C**********************************************************************
     C*Subroutine: Validation #1
     C**********************************************************************
     C                   DO                                                     B---------01
     C* When adding customer must not be zero:                                             |
     C     XWBCCD        IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVE      *ON           *IN31                                    ||
     C                   MOVE      'OEM0002'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C* When adding customer must not exist:                                               |
     C     ACTDSP        IFEQ      'ADDITION'                                   B--------02|
     C     XWBCCD        SETLL     CUSTS                                  99              ||
     C     *IN99         IFEQ      '1'                                          B-------03||
     C                   MOVE      *ON           *IN31                                   |||
     C                   MOVE      'Y2U0003'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID             7                     |||
     C                   PARM                    ERRMSG          132                     |||
     C                   LEAVE                                                           |||
     C                   ENDIF                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C* Customer name must not be blank:                                                   |
     C     XWG4TX        IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      *ON           *IN32                                    ||
     C                   MOVE      *ON           *IN99                                    ||
     C                   MOVE      'OEM0012'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- Customer Group must be valid:                                                     |
     C     XWBNCD        CHAIN     CUSGRP                             99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN33                                    ||
     C                   MOVE      'OES0374'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- Salesman Code must be valid:                                                      |
     C     PERSON        CHAIN     SLMEN                              99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN34                                    ||
     C                   MOVE      'OEM0023'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- Distributor Code must be valid:                                                   |
     C     DSDCDE        CHAIN     DISTS                              99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN35                                    ||
     C                   MOVE      'OEM0018'     MSGID                                    ||
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

     C*For each screen page                                                             |||
     C     *IN03         DOWNE     '1'
     C     *IN12         ANDNE     '1'                                                  ||||

     C                   EXFMT     ZZFT01                                                |||
     C                   EXSR      MVSCDB
     C                   CALL      'XBCCLMSG'                                            |||
     C                   EXSR      OFFIND                                                |||
     C*Process Command Keys                                                             |||
     C                   SELECT
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

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE
     C                   ENDIF

     C     *IN04         IFEQ      '1'                                          B------04|||
     C     *IN08         OREQ      '1'                                                  ||||
     C     *IN09         OREQ      '1'                                                  ||||
     C                   ITER                                                           ||||
     C                   ENDIF                                                  E------04|||

     C                   EXSR      VALID1                                               ||||

     C*If errors found                                                                 ||||
     C     *IN99         IFEQ      '1'                                          B-----05||||
     C*Display error message and re-display screen                                     ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   exsr      mvdbsc
     C                   iter                                                          |||||
     C                   ENDIF                                                  E-----05||||

     C*Request confirmation                                                             |||
     C                   EXFMT     ZZCNF1                                                |||
     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||
     C*If confirmation received then write record                                       |||
     C                   WRITE     CUSTSR                               99               |||
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   MOVE      'Y2U0004'     MSGID                                  ||||
     C                   CALL      RTNMTX                                               ||||
     C                   PARM                    MSGID             7                    ||||
     C                   PARM                    ERRMSG          132                    ||||
     C* Display error message                                                           ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                 ||||
     C                   ELSE
     C                   LEAVE
     C                   ENDIF                                                          ||||
     C                   ENDIF                                                          ||||

     C                   ENDDO                                                  E-----05||||

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
     C     *IN99         IFEQ      *OFF
     C     *IN66         ANDEQ     *OFF

     C     *IN03         DOWNE     '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||

     C                   EXFMT     ZZFT01                                                |||
     C                   EXSR      MVSCDB
     C                   CALL      'XBCCLMSG'                                            |||
     C                   EXSR      OFFIND                                                |||
     C*Process Command Keys                                                             |||
     C                   SELECT
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

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||

     C     *IN04         IFEQ      '1'                                          B------04|||
     C     *IN08         OREQ      '1'                                                  ||||
     C     *IN09         OREQ      '1'                                                  ||||
     C                   ITER                                                           ||||
     C                   ENDIF                                                  E------04|||

     C                   EXSR      VALID1                                               ||||

     C*If errors found                                                                 ||||
     C     *IN99         IFEQ      '1'                                          B-----05||||
     C*Display error message and re-display screen                                     ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   exsr      mvdbsc                                              |||||
     C                   iter                                                          |||||
     C                   ENDIF                                                  E-----05||||

     C*Request confirmation                                                             |||
     C                   EXFMT     ZZCNF1                                                |||
     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||
     C*If confirmation received then update record                                      |||
     C     xwbccd        chain(e)  custsr
     C                   if        %found(custs)
     C                   exsr      mvscdb
     C                   UPDATE    CUSTSR                               99               |||
     C     *IN99         IFEQ      '1'                                          B------04|||
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

     C                   ENDDO                                                          ||||

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

     C     *IN03         DOWNE     '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||

     C                   EXFMT     ZZFT01                                                |||
     C                   EXSR      MVSCDB
     C                   CALL      'XBCCLMSG'                                            |||
     C                   EXSR      OFFIND                                                |||
     C*Process Command Keys                                                             |||
     C                   SELECT
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

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||

     C     *IN04         IFEQ      '1'                                          B------04|||
     C     *IN08         OREQ      '1'                                                  ||||
     C     *IN09         OREQ      '1'                                                  ||||
     C                   ITER                                                           ||||
     C                   ENDIF                                                  E------04|||

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
     C                   LEAVE
     C                   ENDIF                                                          ||||

     C*End: If not F3/F12                                                               |||
     C                   ENDDO                                                          ||||

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

     C     *IN03         DOWNE     '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||

     C                   EXFMT     ZZFT01                                                |||
     C                   EXSR      MVSCDB
     C                   CALL      'XBCCLMSG'                                            |||
     C                   EXSR      OFFIND                                                |||
     C*Process Command Keys                                                             |||
     C                   SELECT
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

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||

     C     *IN04         IFEQ      '1'                                          B------04|||
     C     *IN08         OREQ      '1'                                                  ||||
     C     *IN09         OREQ      '1'                                                  ||||
     C                   ITER                                                           ||||
     C                   ENDIF                                                  E------04|||

     C                   ENDDO

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
     C                   when      *in99 = *on                                  B---------01
     C                   MOVE      'OES0115'     MSGID                                     |
     C                   CALL      RTNMTX                                                  |
     C                   PARM                    MSGID             7                       |
     C                   PARM                    ERRMSG          132                       |
     C                   MOVEL     ERRMSG        ZMSAGE                                    |

     C*If file error                                                                      |
     C                   when      *in66 = *on                                  B---------01
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

     C*Retrieve Distributor's name                                                        |
     C     DSDCDE        CHAIN(E)  DISTS                                                   |

     C*Retrieve Customer Group's name                                                     |
     C     XWBNCD        CHAIN(E)  CUSGRP                                                  |

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
     C                   ENDSR
     C**********************************************************************
````
