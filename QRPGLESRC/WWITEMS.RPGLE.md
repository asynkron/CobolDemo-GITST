# WWITEMS.RPGLE Member Guide

## Overview
ILE RPG program `WWITEMS` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `WWITEMS`.
- **Outgoing:**
  - Calls programs/procedures: RTNMTX

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2011
     H*PROGRAM:  Work with Items
     H*--------------------------------------------------------------------
     H DATEDIT(*YMD)
     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     FWITEMSD   CF   E             WORKSTN
     F                                     SFILE(ZZSF01:SFLRRN)
     FITEMS     UF A E           K DISK
     F                                     INFDS(FILEDS)
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
     C                   MOVE      LOCATE        #ITEM                                    ||
     C                   EXSR      SFLWRT                                                 ||
     C                   ITER                                                             ||
     C                   ENDIF                                                  E--------02|
     C*Action command keys                                                                |
     C     *IN28         IFEQ      '1'                                          B--------02|
     C                   EXSR      CMDKEY                                                 ||
     C***                EXSR      CMDFUN
     C                   ELSE                                                   X........02|
     C*Else action selections                                                            ||
     C                   EXSR      ZSELEC                                                 ||
     C                   ENDIF                                                  E--------02|
     C*If changes made then update display                                                |
     C     SFLCHG        IFEQ      '1'                                          B--------02|
     C                   MOVE      *LOVAL        #ITEM                                    ||
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
     C***                SETON                                        717281
     C                   WRITE     ZZCT01                               99
     C                   SETOFF                                       74
     C*Write subfile
     C                   MOVE      *ZEROS        SFLRRN
     C     #ITEM         SETLL     ITEMS
     C                   ENDIF
     C*
     C                   MOVE      *ZEROS        SFLCTR
     C     *IN81         DOWEQ     '0'                                          B---------01
     C     SFLCTR        ANDLT     12
     C                   READ(N)   ITEMS                                  81
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
     C*Display screen
     C                   EXFMT     ZZFT01                                                |||
     C                   EXSR      MVSCDB

     C                   CALL      'XBCCLMSG'                                            |||
     C                   EXSR      OFFIND                                                |||


     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     VALID1        BEGSR
     C**********************************************************************
     C*Subroutine: Validation #1
     C**********************************************************************
     C* WHEN ADDING ITEM #  MUST NOT BE *BLANKS                                            |
     C     ZITEM         IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVE      *ON           *IN31                                    ||
     C                   MOVE      'ITM0001'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   ENDIF                                                  E--------02|
     C* WHEN ADDING ITEM # MUST NOT EXIST                                                |
     C     ACTDSP        IFEQ      'ADDITION'                                   B--------02|
     C     ZITEM         SETLL     ITEMS                                  99              ||
     C     *IN99         IFEQ      '1'                                          B-------03||
     C                   MOVE      *ON           *IN31                                   |||
     C                   MOVE      'Y2U0003'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID             7                     |||
     C                   PARM                    ERRMSG          132                     |||
     C                   ENDIF                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C*Item Description                                                                   |
     C     ZDESC         IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      *ON           *IN32                                    ||
     C                   MOVE      *ON           *IN99                                    ||
     C                   MOVE      'ITM0001'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   ENDIF                                                  E--------02|
     C*-Part #                                                                            |
     C     ZPART         IFEQ      *BLANKS                                                 |
     C                   MOVE      '1'           *IN33                                    ||
     C                   MOVE      'ITM0003'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   ENDIF                                                  E--------02|
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

     C                   clear                   ritems
     C                   exsr      mvdbsc

     C                   do

     C                   EXSR      DSPSCNS

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||

     C                   EXSR      VALID1                                               ||||

     C*If errors found                                                                 ||||
     C     *IN99         IFEQ      '1'                                          B-----05||||
     C*Display error message and re-display screen                                     ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   exsr      mvdbsc
     C                   iter                                                          |||||
     C                   else                                                   E-----05||||
     C                   leave
     c                   endif
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
     C                   WRITE     RITEMS                               99               |||
     C     *IN99         IFEQ      '1'                                          B------04|||
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
     C     *IN99         IFEQ      *OFF
     C     *IN66         ANDEQ     *OFF

     C*For each screen page                                                             |||
     C                   do                                                              |||

     C                   EXSR      DSPSCNS

     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||

     C                   EXSR      VALID1                                               ||||

     C*If errors found                                                                 ||||
     C     *IN99         IFEQ      '1'                                          B-----05||||
     C*Display error message and re-display screen                                     ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   exsr      mvdbsc                                              |||||
     C                   iter                                                          |||||
     C                   else                                                   E-----05||||
     c                   leave
     c                   endif

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
     C     zitem         chain(e)  ritems
     C                   if        %found(items)
     C                   exsr      mvscdb
     C                   UPDATE    RITEMS                               99               |||
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   MOVE      'Y2U0007'     MSGID                                  ||||
     C                   CALL      RTNMTX                                               ||||
     C                   PARM                    MSGID             7                    ||||
     C                   PARM                    ERRMSG          132                    ||||
     C* Display error message                                                           ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                 ||||
     C                   ENDIF                                                  X......04|||
     C                   else                                                           ||||
     C                   unlock(e) items                                                   |
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

     C                   EXSR      DSPSCNS

     C*If not F3/F12                                                                    |||
     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||

     C*Request confirmation                                                             |||
     C                   EXFMT     ZZCNF1                                                |||

     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||
     C*If confirmation received then delete record                                      |||
     C     zitem         chain(e)  ritems
     C                   if        %found(items)
     C                   delete(e) ritems                                               ||||
     C                   else                                                           ||||
     C                   unlock(e) items                                                   |
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

     C                   EXSR      DSPSCNS

     C                   MOVE      SFLRRN        SHWREC                                   ||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     GETREC        BEGSR
     C**********************************************************************
     C*Subroutine: Retrieve a record
     C**********************************************************************
     C     #ITEM         CHAIN(N)  ITEMS                              9966

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
     C                   MOVEL     'WWITEMS '    ZZPGM
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
     C     MVDBSC        BEGSR
     C                   MOVEL     #ITEM         ZITEM                                     |
     C                   MOVEL     #DESC         ZDESC                                     |
     C                   MOVEL     #PART         ZPART                                     |
     C                   ENDSR
     C**********************************************************************
     C     MVSCDB        BEGSR
     C                   MOVEL     ZITEM         #ITEM                                     |
     C                   MOVEL     ZDESC         #DESC                                     |
     C                   MOVEL     ZPART         #PART                                     |
     C                   ENDSR
     C**********************************************************************
````
