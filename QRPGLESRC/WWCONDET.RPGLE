     H DATEDIT(*YMD)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     FWCONDETD  CF   E             WORKSTN
     F                                     SFILE(ZZSF01:SFLRRN)
     FCONDET    UF A E           K DISK
     FCUSTS     IF   E           K DISK
     F                                     INFDS(FILEDS)
     FSTKMAS    IF   E           K DISK
     FSTOMAS    IF   E           K DISK
     FSTKBAL    IF   E           K DISK
     F*-
     FCONHDR    IF   E           K DISK
     FSLMEN     IF   E           K DISK
     FORDSTS    IF   E           K DISK
     FTRNTYP    IF   E           K DISK
     D**********************************************************************

     d FILEDS          ds
     d  FILESTS               11     15s 0

     D UM              S             11    DIM(1) CTDATA PERRCD(1)
     D RTNMTX          C                   CONST('RTNMSGTEXT')
     I**********************************************************************
     ICUSTSR
     I              PERSON                      PERCUS
     ISTKBALR
     I              XWA2CD                      WA2CD
     C**********************************************************************
     C*‚D e f i n i t i o n s
     C**********************************************************************
     C                   MOVE      '0'           SFLCHG            1
     C                   MOVE      *ZEROS        SFLRRN            5 0
     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C*‚Build subfile                                                                      |
     C                   EXSR      SFLWRT                                                  |
     C*‚Display screens                                                                    |
     C                   WRITE     ZZTR01                                                  |
     C                   EXFMT     ZZCT01                                                  |
     C*‚Remove messages                                                                    |
     C                   CALL      'XBCCLMSG'                                              |
     C     *IN03         IFEQ      '1'                                          B--------02|
     C     *IN12         OREQ      '1'                                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C                   MOVE      *BLANKS       ZMSAGE                                    |
     C***                MOVE      *BLANKS       ZName                                     |
     C*‚Action command keys                                                                |
     C     *IN28         IFEQ      '1'                                          B--------02|
     C                   EXSR      CMDKEY                                                 ||
     C                   ELSE                                                   X........02|
     C*‚Else action selections                                                            ||
     C                   EXSR      ZSELEC                                                 ||
     C                   ENDIF                                                  E--------02|
     C                   ENDDO                                                  E---------01

     C                   MOVE      '1'           *INLR
     C                   RETURN
     C**********************************************************************
     C*‚L o g i c a l   E n d   o f   P r o g r a m
     C**********************************************************************
     C*
     C**********************************************************************
     C     SFLWRT        BEGSR
     C**********************************************************************
     C*‚Subroutine: Write data to subfile
     C**********************************************************************
     C*‚Delete subfile
     C                   SETON                                        74
     C                   SETOFF                                       717231
     C                   WRITE     ZZCT01
     C                   SETOFF                                       74
     C*‚Write subfile
     C                   MOVE      *ZEROS        SFLRRN
     C     XWORDN        SETLL     CONDET
     C     XWORDN        READE(N)  CONDET                                 31
     C     *IN31         DOWEQ     '0'                                          B---------01
     C                   ADD       1             SFLRRN                                    |
     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   MOVEL     XWABCD        SWABCD                                    |
     C                   MOVEL     XWT8TX        SWT8TX                                    |
     C     XWABCD        CHAIN     STKMAS                             99                   |
     C     *IN99         IFEQ      '1'                                          B---------01
     C                   MOVEL     *ALL'-'       XWHLTX                                    |
     C                   ENDIF                                                  E---------01
     C                   WRITE     ZZSF01                                                  |
     C     XWORDN        READE(N)  CONDET                                 31               |
     C                   ENDDO                                                  E---------01
     C*-
     C     SFLRRN        IFGT      *ZEROS                                       B---------01
     C     SFLCHG        IFEQ      '0'                                          B--------02|
     C                   Z-ADD     1             SHWREC                                   ||
     C                   ENDIF                                                  E--------02|
     C     SHWREC        IFGT      SFLRRN                                       B--------02|
     C     SHWREC        ORLT      1                                                      ||
     C                   Z-ADD     1             SHWREC                                   ||
     C                   ENDIF                                                  E--------02|

      *  Richard T: 27 Sep 2010
      *  Ensure SFLDSP is on only when there are records to display:
     C                   If        SFLRRN > 0
     C                   Eval      *IN71 = *ON
     C                   Else
     C                   Eval      *IN71 = *OFF
     C                   EndIf

     C                   ENDIF                                                  E---------01
     C                   SETON                                        72
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     ZSELEC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Action selection
     C**********************************************************************
     C                   MOVE      '0'           SFLCHG
     C                   READC     ZZSF01                                 35
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
     C                   ENDSL                                                  E--------02|
     C                   MOVE      SFLRRN        SHWREC                                   ||
     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   UPDATE    ZZSF01                                                  |
     C                   READC     ZZSF01                                 35               |
     C*‚End: For each selection                                                            |
     C                   ENDDO                                                  E---------01
     C                   MOVE      '0'           *IN12
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     DSPSCN        BEGSR
     C**********************************************************************
     C*‚Subroutine: Process screen
     C**********************************************************************
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   WRITE     ZZMC01                                                |||
     C                   ENDIF                                                  X.....05||||
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      *BLANKS       ZMSAGE                                  |||
     C                   SELECT                                                 X.....05||||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C                   ENDSL                                                  X.....05||||
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     DSPREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Display a record
     C**********************************************************************
     C                   MOVE      '1'           *IN34
     C                   MOVE      '0'           *IN37
     C                   MOVEL     ' DISPLAY'    ACTDSP                                    |
     C                   EXSR      GETREC                                                  |
     C     *IN03         DOWEQ     '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   WRITE     ZZMC01                                                |||
     C                   ENDIF                                                  X.....05||||
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      *BLANKS       ZMSAGE                                  |||
     C                   SELECT                                                 X.....05||||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C                   ENDSL                                                  X.....05||||
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     CHGREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Change a record
     C**********************************************************************
     C                   MOVEL     '  UPDATE'    ACTDSP                                    |
     C                   MOVE      '0'           *IN34                                     |
     C                   MOVE      '0'           *IN37
     C                   EXSR      GETREC                                                  |
     C*
     C     *IN03         DOWEQ     '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C*
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   WRITE     ZZMC01                                                |||
     C                   ENDIF                                                  X.....05||||
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      *BLANKS       ZMSAGE                                  |||
     C                   SELECT                                                 X.....05||||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C                   ENDSL                                                  X.....05||||
     C                   EXSR      VALIDT                                             ||||||
     C     *IN99         IFEQ      '1'                                          B-------03||
     C                   MOVEL     ERRMSG        ZMSAGE                              |||||||
     C                   ITER
     C                   ENDIF
     C*
     C     *IN03         IFEQ      '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C                   EXFMT     ZZCNF1                                            |||||||
     C     *IN03         IFEQ      '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C                   EXSR      UPDREC                                            |||||||
     C                   LEAVE                                                       |||||||
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDDO
     C*
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     DELREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Delete a record
     C**********************************************************************
     C                   MOVEL     '  DELETE'    ACTDSP                                    |
     C                   MOVE      '1'           *IN34                                     |
     C                   MOVE      '1'           *IN37                                     |
     C                   EXSR      GETREC                                                  |
     C*
     C     *IN03         DOWEQ     '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   WRITE     ZZMC01                                                |||
     C                   ENDIF                                                  X.....05||||
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      *BLANKS       ZMSAGE                                  |||
     C                   SELECT                                                 X.....05||||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C                   ENDSL                                                  X.....05||||
     C     *IN23         IFEQ      '1'                                          B-------03||
     C                   LEAVE                                                        ||||||
     C                   ENDIF
     C                   ENDDO
     C*
     C     *IN23         IFEQ      '1'                                          B-------03||
     C                   EXFMT     ZZCNF1                               99            ||||||
     C     *IN03         IFNE      '1'                                          B---------01
     C     *IN12         ANDNE     '1'                                          B---------01
     C     KEY001        CHAIN     CONDET                             3666
     C     *IN36         IFEQ      *OFF                                         B---------01
     C     *IN66         ANDEQ     *OFF                                         B---------01
     C                   DELETE    CONDETR                              99            ||||||
     C                   ENDIF                                                  X.....05||||
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     ADDREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Add record
     C**********************************************************************
     C                   MOVE      '0'           *IN34
     C                   MOVE      '1'           *IN36
     C                   MOVE      '0'           *IN37
     C                   MOVEL     'ADDITION'    ACTDSP
     C                   CLEAR                   XWABCD
     C                   CLEAR                   XWAACS
     C                   CLEAR                   XWT8TX
     C                   MOVE      'INV'         XWRICD
     C     XWRICD        CHAIN     TRNTYP                             99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *ALL'-'       XWTDSC
     C                   ENDIF
     C                   CLEAR                   XWA5QT
     C                   MOVE      'EAC'         XWA2CD
     C                   MOVEL     UM(1)         UMDES
     C                   CLEAR                   XWPRIC
     C                   CLEAR                   XWHLTX
     C                   CLEAR                   XWDESC
     C**                 CLEAR                   XWNAME
     C*
     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C*
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   WRITE     ZZMC01                                                |||
     C                   ENDIF                                                  X.....05||||
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      *BLANKS       ZMSAGE                                  |||
     C                   SELECT                                                 X.....05||||
     C*- Prompt                                                                          |||
     C     *IN04         WHENEQ    '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C                   ENDSL                                                  X.....05||||
     C                   EXSR      VALIDT                                                |||
     C     *IN99         IFEQ      '0'                                          W......04|||
     C                   Z-ADD     XWANPR        XWPRIC                                  |||
     C                   ENDIF                                                  B------04|||
     C     *IN99         IFEQ      '1'                                          B-------03||
     C                   MOVEL     ERRMSG        ZMSAGE                              |||||||
     C                   ITER
     C                   ENDIF
     C*
     C     *IN03         IFEQ      '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C                   EXFMT     ZZCNF1                                            |||||||
     C     *IN03         IFEQ      '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C                   WRITE     CONDETR                              99              ||||
     C     *IN99         IFEQ      '1'                                          B-----05||||
     C                   MOVE      'Y2U0004'     MSGID                                 |||||
     C                   CALL      RTNMTX                                              |||||
     C                   PARM                    MSGID             7                   |||||
     C                   PARM                    ERRMSG          132                   |||||
     C* Display error message                                                          |||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   ENDIF
     C                   LEAVE                                                        ||||||
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDDO
     C*
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     CMDKEY        BEGSR
     C**********************************************************************
     C*‚Subroutine: Action command keys
     C**********************************************************************
     C                   SELECT                                                 B---------01
     C     *IN06         WHENEQ    '1'                                          W.........01
     C                   EXSR      ADDREC                                                  |
     C                   ENDSL                                                  E---------01
     C                   MOVE      '0'           *IN12
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     VALIDT        BEGSR
     C**********************************************************************
     C*‚Subroutine: Validation
     C**********************************************************************
     C     KEY002        KLIST
     C                   KFLD                    XWABCD
     C                   KFLD                    XWAACS
     C*-
     C                   MOVE      '0'           *IN99
     C                   MOVE      *BLANKS       ZMSAGE
     C                   DO                                                     B---------01
     C     XWABCD        CHAIN     STKMAS                             99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      'OEM0003'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- If addition, pull the price from file:                                            |
     C     *IN06         IFEQ      '1'                                          B--------02|
     C                   Z-ADD     XWANPR        XWPRIC                                   ||
     C                   END                                                    E--------02|
     C*-                                                                                   |
     C     XWAACS        CHAIN     STOMAS                             99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      'OES0369'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C     KEY002        CHAIN     STKBAL                             99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C     XWA5QT        ORGT      XWBHQT                                                 ||
     C                   MOVE      'OES0370'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   MOVE      '1'           *IN99                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- Transaction Type:                                                                 |
     C     XWRICD        CHAIN     TRNTYP                             99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVEL     *ALL'-'       XWTDSC                                   ||
     C                   MOVE      'OES0371'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- Unit of measure:                                                                  |
     C                   CLEAR                   UMDES                                     |
     C                   SELECT                                                 B--------02|
     C     XWA2CD        WHENEQ    'EAC'                                        W........02|
     C                   MOVEL     UM(1)         UMDES                                    ||
     C                   OTHER                                                  W........02|
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVE      'OES0372'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDSL                                                  E--------02|
     C                   ENDDO                                                  E---------01
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     GETREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Retrieve record
     C**********************************************************************
     C     KEY001        CHAIN(N)  CONDET                             3666
     C     *IN36         IFEQ      '1'                                          B---------01
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
     C                   ELSE                                                   E........02|
     C                   EXSR      VALIDT                                                 ||
     C                   ENDIF                                                  X.......03||
     C                   ENDIF                                                  X.......03||
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     UPDREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Update record
     C**********************************************************************
     C                   EXSR      SAVEDATA                                           ||||||
     C     KEY001        CHAIN     CONDET                             3666
     C     *IN36         IFEQ      *OFF                                         B---------01
     C     *IN66         ANDEQ     *OFF                                         B---------01
     C                   EXSR      RESTOREDATA                                        ||||||
     C                   UPDATE    CONDETR                              99           |||||||
     C     *IN99         IFEQ      '1'                                          B--08|||||||
     C                   MOVE      'Y2U0007'     MSGID                              ||||||||
     C                   CALL      RTNMTX                                           ||||||||
     C                   PARM                    MSGID             7                ||||||||
     C                   PARM                    ERRMSG          132                ||||||||
     C* Display error message                                                       ||||||||
     C                   MOVEL     ERRMSG        ZMSAGE                             ||||||||
     C                   ENDIF                                                  E--08|||||||
     C                   ELSE                                                   X..08|||||||
     C                   MOVE      'Y2U0007'     MSGID                              ||||||||
     C                   CALL      RTNMTX                                           ||||||||
     C                   PARM                    MSGID             7                ||||||||
     C                   PARM                    ERRMSG          132                ||||||||
     C* Display error message                                                       ||||||||
     C                   MOVEL     ERRMSG        ZMSAGE                             ||||||||
     C                   ENDIF                                                  E--08|||||||
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     *INZSR        BEGSR
     C**********************************************************************
     C*‚Subroutine: Initialisation routines
     C**********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    XWORDN
     C                   PARM                    XWBCCD
     C                   PARM                    XWG4TX
     C*‚Initialise message subfile
     C                   MOVE      '1'           *IN32
     C                   MOVEL     'WWCONDET'    ZZPGM
     C*-‚Set date
     C                   MOVE      *DATE         ZZDATE
     C*-
     C*- CONTRACT
     C     XWORDN        CHAIN     CONHDR                             99
     C*- CUSTOMER
     C     XWBCCD        CHAIN     CUSTS                              99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *ALL'-'       XWG4TX
     C                   ENDIF
     C*- REPRESENTATIVE
     C     PERSON        CHAIN     SLMEN                              99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *ALL'-'       PNAME
     C                   ENDIF
     C*- STATUS
     C     XWSTAT        CHAIN     ORDSTS                             99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *ALL'-'       XWSDSC
     C                   ENDIF
     C*-
     C     KEY001        KLIST
     C                   KFLD                    XWORDN
     C                   KFLD                    XWABCD
     C*-
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     SRPROM        BEGSR
     C**********************************************************************
     C*‚Subroutine: prompts for F04
     C**********************************************************************
     C                   SELECT                                                 B---------01
     C*- PRODUCT                                                                           |
     C     SFIELD        WHENEQ    'XWABCD'                                     W.........01
     C                   CALL      'STKMASEL'                                              |
     C                   PARM                    XWABCD                                    |
     C                   PARM                    XWHLTX                                    |
     C*- STORE                                                                             |
     C     SFIELD        WHENEQ    'XWAACS'                                     W.........01
     C                   CALL      'STOMASEL'                                              |
     C                   PARM                    XWAACS                                    |
     C                   PARM                    XWDESC                                    |
     C*- TRANSACTION TYPE                                                                  |
     C     SFIELD        WHENEQ    'XWRICD'                                     W.........01
     C                   CALL      'TRNTPSEL'                                              |
     C                   PARM                    XWRICD                                    |
     C                   PARM                    XWTDSC                                    |
     C                   ENDSL                                                  E---------01
     C                   ENDSR
     C**********************************************************************
     C     SAVEDATA      BEGSR
     C**********************************************************************
     C*‚Subroutine: Save current data
     C**********************************************************************
     C                   MOVE      XWORDN        ZWORDN                         B---------01
     C                   MOVE      XWABCD        ZWABCD                         B---------01
     C                   MOVE      XWAACS        ZWAACS                         B---------01
     C                   MOVE      XWT8TX        ZWT8TX                         B---------01
     C                   MOVE      XWRICD        ZWRICD                         B---------01
     C                   MOVE      XWA5QT        ZWA5QT                         B---------01
     C                   MOVE      XWA2CD        ZWA2CD                         B---------01
     C                   MOVE      XWPRIC        ZWPRIC                         B---------01

     C     *LIKE         DEFINE    XWORDN        ZWORDN                         B---------01
     C     *LIKE         DEFINE    XWABCD        ZWABCD                         B---------01
     C     *LIKE         DEFINE    XWAACS        ZWAACS                         B---------01
     C     *LIKE         DEFINE    XWT8TX        ZWT8TX                         B---------01
     C     *LIKE         DEFINE    XWRICD        ZWRICD                         B---------01
     C     *LIKE         DEFINE    XWA5QT        ZWA5QT                         B---------01
     C     *LIKE         DEFINE    XWA2CD        ZWA2CD                         B---------01
     C     *LIKE         DEFINE    XWPRIC        ZWPRIC                         B---------01

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     RESTOREDATA   BEGSR
     C**********************************************************************
     C*‚Subroutine: Restore current data
     C**********************************************************************
     C                   MOVE      ZWORDN        XWORDN                         B---------01
     C                   MOVE      ZWABCD        XWABCD                         B---------01
     C                   MOVE      ZWAACS        XWAACS                         B---------01
     C                   MOVE      ZWT8TX        XWT8TX                         B---------01
     C                   MOVE      ZWRICD        XWRICD                         B---------01
     C                   MOVE      ZWA5QT        XWA5QT                         B---------01
     C                   MOVE      ZWA2CD        XWA2CD                         B---------01
     C                   MOVE      ZWPRIC        XWPRIC                         B---------01

     C                   ENDSR
     C**********************************************************************
**
Each KGS
