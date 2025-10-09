     H DATEDIT(*YMD)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     FWCONHDRD  CF   E             WORKSTN
     F                                     SFILE(ZZSF01:SFLRRN)
     FCONHDR    UF A E           K DISK
     F                                     INFDS(FILEDS)
     FCONHDRL1  IF   E           K DISK
     F                                     RENAME(CONHDRR:CONHDR2)
     FCUSTS     IF   E           K DISK
     FCUSFL3    IF   E           K DISK
     FSLMEN     IF   E           K DISK
     FORDSTS    IF   E           K DISK

     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D  sflrrn         s              5p 0
     D  sflchg         s              1a   inz('0')

     D*‚Set constants
     D RTNMTX          C                   CONST('RTNMSGTEXT')

     d FILEDS          ds
     d  FILESTS               11     15s 0

     D                 DS                  INZ
     D  ZDATE                  1     10
     D  ZYR                    1      4
     D  FILLR1                 5      5
     D  ZMTH                   6      7
     D  FILLR2                 8      8
     D  ZDAY                   9     10

     I**********************************************************************
     ICUSTSR
     I              PERSON                      PERCUS

     C*********************************************************************
     C*‚M a i n l i n e   C o d e
     C*********************************************************************
     C*‚Retrieve customer number data                                                     ||
     C     XWBCCD        CHAIN     CUSTS                              99                   |
     C     CUSNO         CHAIN     CUSFL3                             99                   |
     C     PERCUS        CHAIN     SLMEN                              99                   |
     C                   MOVEL     PNAME         SNAME                                     |
                                                                                           |
     C*‚Build subfile
     C                   EXSR      SFLWRT
                                                                                           |
     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C                   MOVE      *ZEROS        LOCATE                                    |
     C*‚Display screens                                                                    |
     C                   WRITE     ZZTR01                                                  |
     C   99              WRITE     ZZMC01                                                  |
     C                   EXFMT     ZZCT01                                                 ||
     C*‚Remove messages                                                                    |
     C                   CALL      'XBCCLMSG'                                              |

     C     *IN03         IFEQ      '1'                                          B--------02|
     C     *IN12         OREQ      '1'                                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|

     C*‚Action positioner request                                                          |
     C     LOCATE        IFNE      *ZEROS                                       B--------02|
     C                   MOVE      LOCATE        XWORDN                                   ||
     C                   EXSR      SFLWRT
     C                   ITER                                                             ||
     C                   ENDIF                                                  E--------02|

     C*‚Action command keys                                                                |
     C     *IN28         IFEQ      '1'                                          B--------02|
     C                   EXSR      CMDKEY                                                 ||
     C                   ELSE                                                   X........02|
     C*‚Else action selections                                                            ||
     C                   EXSR      ZSELEC                                                 ||
     C                   ENDIF                                                  E--------02|

     C*‚If changes made then update display                                                |
     C     SFLCHG        IFEQ      '1'                                          B--------02|
     C                   MOVE      *ZEROS        XWORDN
     C                   EXSR      SFLWRT
     C                   ENDIF                                                  E--------02|

     C                   ENDDO                                                  E---------01

     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*********************************************************************
     C*‚L o g i c a l   E n d   o f   P r o g r a m
     C*********************************************************************

     C*********************************************************************
     C     SFLWRT        BEGSR
     C*********************************************************************
     C*‚Subroutine: Write data to subfile
     C*********************************************************************
     C     KEY01         KLIST
     C                   KFLD                    XWBCCD
     C                   KFLD                    XWORDN

     C*‚Delete subfile
     C                   SETON                                        74
     C                   SETOFF                                       717231
     C                   WRITE     ZZCT01                               99                 |

     C     KEY01         SETLL     CONHDRL1                                                |
     C     XWBCCD        READE     CONHDRL1                               31               |

     C                   SETOFF                                       74

     C*‚Write subfile
     C                   MOVE      *ZEROS        SFLRRN

     C     *IN31         DOWEQ     '0'                                          B---------01
     C                   ADD       1             SFLRRN                                    |
     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   WRITE     ZZSF01                               99                ||
     C     XWBCCD        READE     CONHDRL1                               31               |
     C                   ENDDO                                                  E---------01

     C     SFLRRN        IFGT      *ZEROS                                       B---------01
     C     SFLCHG        IFEQ      '0'                                          B--------02|
     C                   Z-ADD     1             SHWREC                                   ||
     C                   ENDIF                                                  E--------02|
     C                   ENDIF                                                  E--------02|

     C     SHWREC        IFGT      SFLRRN                                       B--------02|
     C     SHWREC        ORLT      1                                                      ||
     C                   Z-ADD     1             SHWREC                                   ||
     C                   ENDIF                                                  E--------02|

      * Richard T 27/09/10
      * Set SFLDSP(*ON) only when there are records in the SFL!
     C*                  SETON                                        71                   |
     C                   If        SFLRRN > 0
     C                   Eval      *IN71 = *ON
     C                   Else
     C                   Eval      *IN71 = *OFF
     C**                 Eval      *in72 = *off
     C                   EndIf

     C                   SETON                                        72

     C                   ENDSR
     C*********************************************************************

     C*********************************************************************
     C     ZSELEC        BEGSR
     C*********************************************************************
     C*‚Subroutine: Action selection
     C*********************************************************************
     C                   MOVE      '0'           SFLCHG
     C                   READC     ZZSF01                                 35               |

     C*‚For each selection
     C     *IN35         DOWEQ     '0'                                          B---------01
     C                   MOVE      '1'           SFLCHG                                    |

     C                   SELECT                                                 B--------02|
     C*‚Change                                                                            ||
     C     DSSEL         WHENEQ    '2'                                          W........02|
     C                   EXSR      CHGREC                                                 ||
     C*‚Delete                                                                            ||
     C     DSSEL         WHENEQ    '4'                                                    ||
     C                   EXSR      DELREC                                                 ||
     C*‚Display                                                                           ||
     C     DSSEL         WHENEQ    '5'                                                    ||
     C                   EXSR      DSPREC                                                 ||
     C*‚Lines                                                                             ||
     C     DSSEL         WHENEQ    '7'                                          W........02|
     C                   MOVE      *BLANKS       XWG4TX                                   ||
     C                   EXSR      ZLINES                                                 ||
     C                   ENDSL                                                  E--------02|

     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   UPDATE    ZZSF01                               99                ||
     C                   READC     ZZSF01                                 35              ||
     C*‚End: For each selection                                                            |
     C                   ENDDO                                                  E---------01

     C                   MOVE      '0'           *IN12

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     DSPSCN        BEGSR
     C**********************************************************************
     C*‚Subroutine: Process screen
     C**********************************************************************
     C   99              WRITE     ZZMC01                               99               |||
     C                   EXFMT     ZZFT01                                               ||||

     C                   CALL      'XBCCLMSG'                                            |||

     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '0000'        *IN(40)                                 |||

     C                   SELECT                                                          |||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C* Lines                                                                           ||||
     C     *IN07         WHENEQ    '1'                                          W.....05||||
     C                   EXSR      ZLINES                                              |||||
     C                   ENDSL                                                  E----06|||||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     ZLINES        BEGSR
     C**********************************************************************
     C*‚Subroutine: Contract Detail
     C**********************************************************************
     C     XWORDN        CHAIN(N)  CONHDR                             36
     C     *IN36         IFEQ      '0'                                          B---------01
     C                   CALL      'WWCONDET'                                              |
     C                   PARM                    XWORDN                                    |
     C                   PARM                    XWBCCD                                    |
     C                   PARM                    XWG4TX                                    |
     C                   ENDIF                                                  E---------01
     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     ADDREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Add record
     C**********************************************************************
     C                   MOVE      '0'           *IN34
     C                   MOVE      '1'           *IN36
     C                   MOVE      '0'           *IN37
     C                   MOVEL     'ADDITION'    ACTDSP

     C                   CLEAR                   XWCREF
     C                   CLEAR                   XWDLDT
     C                   MOVEL     ZDATE         XWDLDT
     C                   CLEAR                   XWG4TX                                    |
     C                   MOVE      '01'          XWSTAT
     C     XWSTAT        CHAIN     ORDSTS                             99
     C   99              MOVEL     *ALL'-'       XWSDSC
     C                   CLEAR                   PERSON
     C                   CLEAR                   PNAME
     C                   CLEAR                   XWTAMT
     C                   CLEAR                   XWADD1
     C                   CLEAR                   XWADD2
     C                   CLEAR                   XWADD3
     C                   CLEAR                   XWADD4
     C                   CLEAR                   XWPCDE
     C                   CLEAR                   XWCNTR
     C                   CLEAR                   XWORDN
     C***                CLEAR                   XWCUSN

     C     *IN03         DOWNE     '1'                                          B---------01
     C     *IN12         ANDNE     '1'                                                     |
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '0000'        *IN(40)                                 |||
     C                   SELECT                                                          |||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C* Lines                                                                           ||||
     C     *IN07         WHENEQ    '1'                                          W.....05||||
     C                   EXSR      ZLINES                                              |||||
     C                   ENDSL                                                  E----06|||||
     C                   EXSR      VALIDT                                              |||||
     C     *IN99         IFEQ      '0'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ELSE                                                   E---07||||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   ENDIF                                                  E---07||||||
     C                   ENDDO                                                  E---07||||||

     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||

     C                   EXFMT     ZZCNF1                                             ||||||
     C     *IN03         IFNE      '1'                                          B---07||||||
     C     *IN12         ANDNE     '1'                                               |||||||
     C                   WRITE     CONHDRR                              99               |||
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   MOVE      'Y2U0004'     MSGID                                  ||||
     C                   CALL      RTNMTX                                               ||||
     C                   PARM                    MSGID             7                    ||||
     C                   PARM                    ERRMSG          132                    ||||
     C* Display error message                                                           ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                 ||||
     C                   ENDIF                                                  E------04|||
     C                   ENDIF                                                  E------04|||

     C                   ENDIF                                                  E--------02|

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     DSPREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Display a record
     C**********************************************************************
     C                   MOVE      '1'           *IN34
     C                   MOVE      '0'           *IN36
     C                   MOVE      '0'           *IN37
     C                   MOVEL     ' DISPLAY'    ACTDSP

     C     XWORDN        CHAIN(N)  CONHDR                             9966
     C     *IN99         IFEQ      '1'                                          B---------01
     C                   MOVE      'OES0115'     MSGID                                     |
     C                   CALL      RTNMTX                                                  |
     C                   PARM                    MSGID             7                       |
     C                   PARM                    ERRMSG          132                       |
     C                   MOVEL     ERRMSG        ZMSAGE                                    |
     C                   ELSE                                                   E---------01
     C     *IN66         IFEQ      *ON                                          B--------02|
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
     C                   ELSE                                                   X........02|
     C     XWSTAT        CHAIN     ORDSTS                             77                   |
     C     *IN77         IFEQ      '1'                                          B--------02|
     C                   MOVE      *ALL'-'       XWSDSC                                   ||
     C                   ENDIF                                                  X........02|
     C     PERSON        CHAIN     SLMEN                              77                   |
     C     *IN77         IFEQ      '1'                                          B--------02|
     C                   MOVE      *ALL'-'       PNAME                                    ||
     C                   ENDIF                                                  X........02|
     C                   ENDIF                                                  X........02|
     C                   ENDIF                                                  X.........01

     C     *IN03         DOWNE     *ON                                          B------04|||
     C     *IN12         ANDNE     *ON                                                  ||||
     C     *IN99         ANDNE     *ON                                                  ||||
     C     *IN66         ANDNE     *ON                                                  ||||
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '0000'        *IN(40)                                 |||
     C                   SELECT                                                          |||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C* Lines                                                                           ||||
     C     *IN07         WHENEQ    '1'                                          W.....05||||
     C                   EXSR      ZLINES                                              |||||
     C                   ENDSL                                                  E----06|||||
     C                   ENDDO                                                  E------04|||

     C                   MOVE      SFLRRN        SHWREC                                   ||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     CHGREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Change a record
     C**********************************************************************
     C                   MOVE      '0'           *IN34
     C                   MOVE      '0'           *IN36
     C                   MOVE      '0'           *IN37
     C                   MOVEL     ' UPDATE '    ACTDSP                                    |

     C     XWORDN        CHAIN(N)  CONHDR                             9966
     C     *IN99         IFEQ      '1'                                          B---------01
     C                   MOVE      'OES0115'     MSGID                                     |
     C                   CALL      RTNMTX                                                  |
     C                   PARM                    MSGID             7                       |
     C                   PARM                    ERRMSG          132                       |
     C                   MOVEL     ERRMSG        ZMSAGE                                    |
     C                   ELSE                                                   E---------01
     C     *IN66         IFEQ      *ON                                          B--------02|
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
     C                   ELSE                                                   X........02|
     C     XWSTAT        CHAIN     ORDSTS                             77                   |
     C     *IN77         IFEQ      '1'                                          B--------02|
     C                   MOVE      *ALL'-'       XWSDSC                                   ||
     C                   ENDIF                                                  X........02|
     C     PERSON        CHAIN     SLMEN                              77                   |
     C     *IN77         IFEQ      '1'                                          B--------02|
     C                   MOVE      *ALL'-'       PNAME                                    ||
     C                   ENDIF                                                  X........02|
     C                   ENDIF                                                  X........02|
     C                   ENDIF                                                  X.........01

     C     *IN03         DOWNE     '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||
     C     *IN99         ANDNE     *ON                                                  ||||
     C     *IN66         ANDNE     *ON                                                  ||||
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '0000'        *IN(40)                                 |||
     C                   SELECT                                                          |||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C* Lines                                                                           ||||
     C     *IN07         WHENEQ    '1'                                          W.....05||||
     C                   EXSR      ZLINES                                              |||||
     C                   ENDSL                                                  E----06|||||
     C                   EXSR      VALIDT                                              |||||
     C     *IN99         IFEQ      '0'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ELSE                                                   E---07||||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   ENDIF                                                  E---07||||||
     C                   ENDDO                                                  E---07||||||

     C     *IN03         IFNE      '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||

     C                   EXFMT     ZZCNF1                                             ||||||
     C     *IN03         IFNE      '1'                                          B---07||||||
     C     *IN12         ANDNE     '1'                                               |||||||
     C                   EXSR      SAVEDATA                                           ||||||
     C     XWORDN        CHAIN     CONHDR                             9966
     C     *IN99         IFNE      *ON                                                  ||||
     C     *IN66         ANDNE     *ON                                                  ||||
     C                   EXSR      RESTOREDATA                                        ||||||
     C                   UPDATE    CONHDRR                              99            ||||||
     C     *IN99         IFEQ      '1'                                          B---07||||||
     C                   MOVE      'Y2U0007'     MSGID                               |||||||
     C                   CALL      RTNMTX                                            |||||||
     C                   PARM                    MSGID             7                 |||||||
     C                   PARM                    ERRMSG          132                 |||||||
     C* Display error message                                                        |||||||
     C                   MOVEL     ERRMSG        ZMSAGE                              |||||||
     C                   ENDIF                                                  E---07||||||
     C                   ENDIF                                                  E---07||||||
     C                   ENDIF                                                  E---07||||||

     C                   ENDIF                                                  E---07||||||

     C                   MOVE      SFLRRN        SHWREC                                   ||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     DELREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Delete a record
     C**********************************************************************
     C                   MOVE      '1'           *IN34
     C                   MOVE      '0'           *IN36
     C                   MOVE      '1'           *IN37
     C                   MOVEL     ' DELETE '    ACTDSP                                    |

     C     XWORDN        CHAIN(N)  CONHDR                             9966
     C     *IN99         IFEQ      '1'                                          B---------01
     C                   MOVE      'OES0115'     MSGID                                     |
     C                   CALL      RTNMTX                                                  |
     C                   PARM                    MSGID             7                       |
     C                   PARM                    ERRMSG          132                       |
     C                   MOVEL     ERRMSG        ZMSAGE                                    |
     C                   ELSE                                                   E---------01
     C     *IN66         IFEQ      *ON                                          B--------02|
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
     C                   ELSE                                                   X........02|
     C     XWSTAT        CHAIN     ORDSTS                             77                   |
     C     *IN77         IFEQ      '1'                                          B--------02|
     C                   MOVE      *ALL'-'       XWSDSC                                   ||
     C                   ENDIF                                                  X........02|
     C     PERSON        CHAIN     SLMEN                              77                   |
     C     *IN77         IFEQ      '1'                                          B--------02|
     C                   MOVE      *ALL'-'       PNAME                                    ||
     C                   ENDIF                                                  X........02|
     C                   ENDIF                                                  X........02|
     C                   ENDIF                                                  X.........01

     C     *IN03         DOWNE     '1'                                          B------04|||
     C     *IN12         ANDNE     '1'                                                  ||||
     C     *IN99         ANDNE     *ON                                                  ||||
     C     *IN66         ANDNE     *ON                                                  ||||
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '0000'        *IN(40)                                 |||
     C                   SELECT                                                          |||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C* Lines                                                                           ||||
     C     *IN07         WHENEQ    '1'                                          W.....05||||
     C                   EXSR      ZLINES                                              |||||
     C                   ENDSL                                                  E----06|||||
     C     *IN23         IFEQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E---07||||||
     C                   ENDDO                                                  E---07||||||

     C     *IN23         IFEQ      '1'                                          B------04|||

     C                   EXFMT     ZZCNF1                                             ||||||
     C     *IN03         IFNE      '1'                                          B---07||||||
     C     *IN12         ANDNE     '1'                                               |||||||
     C     XWORDN        CHAIN     CONHDR                             9966
     C     *IN99         IFNE      *ON                                                  ||||
     C     *IN66         ANDNE     *ON                                                  ||||
     C                   DELETE    CONHDRR                              99            ||||||
     C                   ENDIF                                                  E---07||||||
     C                   ENDIF                                                  E---07||||||

     C                   ENDIF                                                  E---07||||||

     C                   MOVE      SFLRRN        SHWREC                                   ||

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     CMDKEY        BEGSR
     C**********************************************************************
     C*‚Subroutine: Action command keys
     C**********************************************************************
     C                   SELECT                                                 B---------01
     C     *IN06         WHENEQ    '1'                                          W.........01
     C                   EXSR      ADDREC                                                  |
     C                   Z-ADD     1             SHWREC                                    |
     C                   MOVE      '1'           SFLCHG                                    |
     C                   ENDSL                                                  E---------01
     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     VALIDT        BEGSR
     C**********************************************************************
     C*‚Subroutine: Validation
     C**********************************************************************
     C                   MOVE      '0'           *IN99
     C                   MOVEA     '0000'        *IN(40)
     C                   MOVE      *BLANKS       ZMSAGE
     C                   DO                                                     B---------01
     C* When adding contract must not be zero:                                             |
     C     XWORDN        IFEQ      *ZEROS                                       B--------02|
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVE      '1'           *IN40                                    ||
     C                   MOVE      'OEM0010'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C* When adding contract must not exist:                                               |
     C     *IN36         IFEQ      '1'                                          B--------02|
     C     XWORDN        SETLL     CONHDR                                 99              ||
     C     *IN99         IFEQ      '1'                                          B-------03||
     C                   MOVE      '1'           *IN40                                   |||
     C                   MOVE      'Y2U0003'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID             7                     |||
     C                   PARM                    ERRMSG          132                     |||
     C                   LEAVE                                                           |||
     C                   ENDIF                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C*- Customer No. must be valid:                                                       |
     C     XWBCCD        CHAIN     CUSTS                              99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN41                                    ||
     C                   MOVE      'OEM0002'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- Status Code must be valid:                                                        |
     C     XWSTAT        CHAIN     ORDSTS                             99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN42                                    ||
     C                   MOVE      'OEM0019'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- Salesman Code must be valid:                                                      |
     C     PERSON        CHAIN     SLMEN                              99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN43                                    ||
     C                   MOVE      'OEM0023'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C                   ENDDO                                                  E---------01
     C                   ENDSR
     C*********************************************************************

     C*********************************************************************
     C     *INZSR        BEGSR
     C*********************************************************************
     C*‚Subroutine: Initialisation routines
     C*********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    SWBCCD           11

     C*‚Set first key value                                                               ||
     C                   MOVE      SWBCCD        XWBCCD                                    |

     C*‚Initialise second key value                                                       ||
     C                   MOVE      *ZEROS        XWORDN                                    |

     C*‚Initialise message subfile
     C                   MOVE      '1'           *IN32
     C                   MOVEL     'WWCONHDR'    ZZPGM

     C*-‚Set date
     C                   MOVE      *DATE         ZZDATE
     C                   MOVE      *YEAR         ZYR
     C                   MOVE      '-'           FILLR1
     C                   MOVE      *MONTH        ZMTH
     C                   MOVE      '-'           FILLR2
     C                   MOVE      *DAY          ZDAY

     C                   ENDSR
     C*********************************************************************

     C*********************************************************************
     C     SRPROM        BEGSR
     C*********************************************************************
     C*‚Subroutine: prompts for F04
     C*********************************************************************
     C                   SELECT                                                 B---------01
     C*- Customer                                                                          |
     C     SFIELD        WHENEQ    'XWBCCD'                                     W.........01
     C                   CALL      'CUSTSSEL'                                              |
     C                   PARM                    XWBCCD                                    |
     C                   PARM                    XWG4TX                                    |
     C*- Status Code                                                                       |
     C     SFIELD        WHENEQ    'XWSTAT'                                     W.........01
     C                   CALL      'ORDSTSEL'                                              |
     C                   PARM                    XWSTAT                                    |
     C                   PARM                    XWSDSC                                    |
     C*- Representative                                                                    |
     C     SFIELD        WHENEQ    'PERSON'                                     W.........01
     C                   CALL      'SLMENSEL'                                              |
     C                   PARM                    PERSON                                    |
     C                   PARM                    PNAME                                     |
     C                   ENDSL                                                  E---------01
     C                   ENDSR
     C*********************************************************************

     C*********************************************************************
     C     SAVEDATA      BEGSR
     C*********************************************************************
     C*‚Subroutine: Save current data
     C*********************************************************************
     C                   MOVE      XWORDN        ZWORDN                         B---------01
     C                   MOVE      XWBCCD        ZWBCCD                         B---------01
     C                   MOVE      XWCREF        ZWCREF                         B---------01
     C                   MOVE      XWDLDT        ZWDLDT                         B---------01
     C                   MOVE      XWSTAT        ZWSTAT                         B---------01
     C                   MOVE      PERSON        ZPERSON                        B---------01
     C                   MOVE      XWTAMT        ZWTAMT                         B---------01
     C                   MOVE      XWADD1        ZWADD1                         B---------01
     C                   MOVE      XWADD2        ZWADD2                         B---------01
     C                   MOVE      XWADD3        ZWADD3                         B---------01
     C                   MOVE      XWADD4        ZWADD4                         B---------01
     C                   MOVE      XWPCDE        ZWPCDE                         B---------01
     C                   MOVE      XWCNTR        ZWCNTR                         B---------01

     C     *LIKE         DEFINE    XWORDN        ZWORDN                         B---------01
     C     *LIKE         DEFINE    XWBCCD        ZWBCCD                         B---------01
     C     *LIKE         DEFINE    XWCREF        ZWCREF                         B---------01
     C     *LIKE         DEFINE    XWDLDT        ZWDLDT                         B---------01
     C     *LIKE         DEFINE    XWSTAT        ZWSTAT                         B---------01
     C     *LIKE         DEFINE    PERSON        ZPERSON                        B---------01
     C     *LIKE         DEFINE    XWTAMT        ZWTAMT                         B---------01
     C     *LIKE         DEFINE    XWADD1        ZWADD1                         B---------01
     C     *LIKE         DEFINE    XWADD2        ZWADD2                         B---------01
     C     *LIKE         DEFINE    XWADD3        ZWADD3                         B---------01
     C     *LIKE         DEFINE    XWADD4        ZWADD4                         B---------01
     C     *LIKE         DEFINE    XWPCDE        ZWPCDE                         B---------01
     C     *LIKE         DEFINE    XWCNTR        ZWCNTR                         B---------01

     C                   ENDSR
     C*********************************************************************

     C*********************************************************************
     C     RESTOREDATA   BEGSR
     C*********************************************************************
     C*‚Subroutine: Restore current data
     C*********************************************************************
     C                   MOVE      ZWORDN        XWORDN                         B---------01
     C                   MOVE      ZWBCCD        XWBCCD                         B---------01
     C                   MOVE      ZWCREF        XWCREF                         B---------01
     C                   MOVE      ZWDLDT        XWDLDT                         B---------01
     C                   MOVE      ZWSTAT        XWSTAT                         B---------01
     C                   MOVE      ZPERSON       PERSON                         B---------01
     C                   MOVE      ZWTAMT        XWTAMT                         B---------01
     C                   MOVE      ZWADD1        XWADD1                         B---------01
     C                   MOVE      ZWADD2        XWADD2                         B---------01
     C                   MOVE      ZWADD3        XWADD3                         B---------01
     C                   MOVE      ZWADD4        XWADD4                         B---------01
     C                   MOVE      ZWPCDE        XWPCDE                         B---------01
     C                   MOVE      ZWCNTR        XWCNTR                         B---------01

     C                   ENDSR
     C*********************************************************************
