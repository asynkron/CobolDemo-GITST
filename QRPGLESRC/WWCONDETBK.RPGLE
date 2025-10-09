     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2007 - ROYMAN E. MOTA RUIZ
     H*ˆPROGRAM:  Work with Order Details
     H*‚--------------------------------------------------------------------
     H DATEDIT(*YMD)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     FWCONDETD  CF   E             WORKSTN
     F                                     SFILE(ZZSF01:SFLRRN)
     FCONDET    UF A E           K DISK
     FCUSTS     IF   E           K DISK
     FSTKMAS    IF   E           K DISK
     FSTOMAS    IF   E           K DISK
     FSTKBAL    IF   E           K DISK
     F*-
     FCONHDR    IF   E           K DISK
     FSLMEN     IF   E           K DISK
     FORDSTS    IF   E           K DISK
     FTRNTYP    IF   E           K DISK
     D**********************************************************************
     D UM              S             11    DIM(1) CTDATA PERRCD(1)
     D RTNMTX          C                   CONST('RTNMSGTEXT')
     I**********************************************************************
     ICUSTSR
     I              PERSON                      PERCUS
     ISTKBALR
     I              XWA2CD                      WA2CD
     C*****************************************************
     C*‚D e f i n i t i o n s
     C*****************************************************
     C                   MOVE      '0'           SFLCHG            1
     C                   MOVE      *ZEROS        SFLRRN            5 0
     C*****************************************************
     C*‚M a i n l i n e   C o d e
     C*****************************************************
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
     C*****************************************************
     C*‚L o g i c a l   E n d   o f   P r o g r a m
     C*****************************************************
     C*****************************************************
     C     SFLWRT        BEGSR
     C*****************************************************
     C*‚Subroutine: Write data to subfile
     C*****************************************************
     C*‚Delete subfile
     C                   SETON                                        74
     C                   SETOFF                                       717231
     C                   WRITE     ZZCT01
     C                   SETOFF                                       74
     C*‚Write subfile
     C                   MOVE      *ZEROS        SFLRRN
     C     XWORDN        SETLL     CONDET
     C     XWORDN        READE     CONDET                                 31
     C     *IN31         DOWEQ     '0'                                          B---------01
     C                   ADD       1             SFLRRN                                    |
     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   MOVEL     XWABCD        SWABCD                                    |
     C                   MOVEL     XWT8TX        SWT8TX                                    |
     C     XWABCD        CHAIN     STKMAS                             99                   |
     C   99              MOVEL     *ALL'-'       XWHLTX                                    |
     C                   WRITE     ZZSF01                                                  |
     C     XWORDN        READE     CONDET                                 31               |
     C                   ENDDO                                                  E---------01
     C*-
     C     SFLRRN        IFGT      *ZEROS                                       B---------01
     C     SFLCHG        IFEQ      '0'                                          B--------02|
     C                   Z-ADD     1             DSPREC                                   ||
     C                   ENDIF                                                  E--------02|
     C     DSPREC        IFGT      SFLRRN                                       B--------02|
     C     DSPREC        ORLT      1                                                      ||
     C                   Z-ADD     1             DSPREC                                   ||
     C                   ENDIF                                                  E--------02|
     C                   SETON                                        71                   |
     C                   ENDIF                                                  E---------01
     C                   SETON                                        72
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     ZSELEC        BEGSR
     C*****************************************************
     C*‚Subroutine: Action selection
     C*****************************************************
     C                   MOVE      '0'           SFLCHG
     C                   READC     ZZSF01                                 35
     C*‚For each selection
     C     *IN35         DOWEQ     '0'                                          B---------01
     C                   MOVE      '1'           SFLCHG                                    |
     C                   SELECT                                                 B--------02|
     C*‚Change                                                                            ||
     C     DSSEL         WHENEQ    '2'                                          W........02|
     C*‚Delete                                                                            ||
     C     DSSEL         OREQ      '4'                                                    ||
     C*‚Display                                                                           ||
     C     DSSEL         OREQ      '5'                                                    ||
     C                   EXSR      SCR001                                                 ||
     C                   MOVE      SFLRRN        DSPREC                                   ||
     C                   ENDSL                                                  E--------02|
     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   UPDATE    ZZSF01                                                  |
     C                   READC     ZZSF01                                 35               |
     C*‚End: For each selection                                                            |
     C                   ENDDO                                                  E---------01
     C*‚If changes made then update display
     C     SFLCHG        IFEQ      '1'                                          B---------01
     C                   EXSR      SFLWRT                                                  |
     C                   ENDIF                                                  E---------01
     C                   MOVE      '0'           *IN12
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     SCR001        BEGSR
     C*****************************************************
     C*‚Subroutine: Process screen
     C*****************************************************
     C     KEY001        KLIST
     C                   KFLD                    XWORDN
     C                   KFLD                    XWABCD
     C*-
     C                   MOVE      '1'           *IN34
     C                   MOVE      '0'           *IN37
     C                   SELECT                                                 B---------01
     C*‚Change                                                                             |
     C     DSSEL         WHENEQ    '2'                                          W.........01
     C                   MOVEL     '  UPDATE'    ACTDSP                                    |
     C                   MOVE      '0'           *IN34                                     |
     C*‚Delete                                                                             |
     C     DSSEL         WHENEQ    '4'                                          W.........01
     C                   MOVEL     '  DELETE'    ACTDSP                                    |
     C                   MOVE      '1'           *IN37                                     |
     C*‚Display                                                                            |
     C     DSSEL         WHENEQ    '5'                                          W.........01
     C                   MOVEL     ' DISPLAY'    ACTDSP                                    |
     C                   ENDSL                                                  E---------01
     c*-
     C                   MOVE      '0'           FIRST             1
     C*-
     C     KEY001        CHAIN     CONDET                             3699
     C     *IN99         IFEQ      '1'                                          B---------01
     C                   MOVE      'Y3U9999'     MSGID                                     |
     C                   CALL      RTNMTX                                                  |
     C                   PARM                    MSGID             7                       |
     C                   PARM                    ERRMSG          132                       |
     C                   MOVEL     ERRMSG        ZMSAGE                                    |
     C                   ELSE                                                   X.........01
     C     *IN36         IFEQ      '0'                                          B--------02|
     C                   EXSR      VALIDT                                                 ||
     C     *IN03         DOWEQ     '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C   99              WRITE     ZZMC01                                                |||
     C     FIRST         IFEQ      '0'                                          B------04|||
     C                   EXFMT     ZZFT01                                               ||||
     C                   END                                                    E------04|||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      *BLANKS       ZMSAGE                                  |||
     C     *IN03         IFEQ      '1'                                          B------04|||
     C     *IN12         OREQ      '1'                                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||
     C*- Prompt                                                                          |||
     C     *IN04         IFEQ      '1'                                          B------04|||
     C                   EXSR      SRPROM                                               ||||
     C                   ELSE                                                   X......04|||
     C*‚Subroutine: Order Header                                                        ||||
     C     *IN08         IFEQ      '1'                                          B-----05||||
     C                   EXSR      ORDHED                                              |||||
     C                   MOVE      '0'           *IN12                                 |||||
     C                   ELSE                                                   X.....05||||
     C* Delete                                                                         |||||
     C                   SELECT                                                 B----06|||||
     C     *IN23         WHENEQ    '1'                                          W....06|||||
     C     DSSEL         ANDEQ     '4'                                                ||||||
     C                   DELETE    CONDETR                              99            ||||||
     C                   LEAVE                                                        ||||||
     C* Validate                                                                      ||||||
     C     DSSEL         WHENEQ    '2'                                          W....06|||||
     C                   EXSR      VALIDT                                             ||||||
     C                   SELECT                                                 B---07||||||
     C     *IN99         WHENEQ    '0'                                          W...07||||||
     C     FIRST         ANDEQ     '1'                                               |||||||
     C                   UPDATE    CONDETR                              99           |||||||
     C     *IN99         IFEQ      '1'                                          B--08|||||||
     C                   MOVE      'Y2U0007'     MSGID                              ||||||||
     C                   CALL      RTNMTX                                           ||||||||
     C                   PARM                    MSGID             7                ||||||||
     C                   PARM                    ERRMSG          132                ||||||||
     C* Display error message                                                       ||||||||
     C                   MOVEL     ERRMSG        ZMSAGE                             ||||||||
     C                   ELSE                                                   X..08|||||||
     C                   LEAVE                                                      ||||||||
     C                   ENDIF                                                  E--08|||||||
     C     *IN99         WHENEQ    '0'                                          W...07||||||
     C     FIRST         ANDEQ     '0'                                               |||||||
     C                   MOVE      '1'           FIRST                               |||||||
     C                   EXFMT     ZZCNF1                                            |||||||
     C     *IN03         IFEQ      '1'                                          B--08|||||||
     C     *IN12         OREQ      '1'                                              ||||||||
     C                   MOVE      '0'           FIRST                              ||||||||
     C                   MOVE      '0'           *IN12                              ||||||||
     C                   ITER                                                       ||||||||
     C                   ENDIF                                                  E--08|||||||
     C* Display error message                                                        |||||||
     C     *IN99         WHENEQ    '1'                                          W...07||||||
     C                   MOVEL     ERRMSG        ZMSAGE                              |||||||
     C                   ENDSL                                                  E---07||||||
     C                   ENDSL                                                  E----06|||||
     C                   ENDIF                                                  E-----05||||
     C                   ENDIF                                                  E------04|||
     C                   ENDDO                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C                   ENDIF                                                  E---------01
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     ZADD          BEGSR
     C*****************************************************
     C*‚Subroutine: Add record
     C*****************************************************
     C                   MOVE      '0'           *IN34
     C                   MOVE      '1'           *IN36
     C                   MOVE      '0'           *IN37
     C                   MOVEL     'ADDITION'    ACTDSP
     C                   CLEAR                   XWABCD
     C                   CLEAR                   XWAACS
     C                   CLEAR                   XWT8TX
     C                   MOVE      'INV'         XWRICD
     C     XWRICD        CHAIN     TRNTYP                             99
     C   99              MOVEL     *ALL'-'       XWTDSC
     C                   CLEAR                   XWA5QT
     C                   MOVE      'EAC'         XWA2CD
     C                   MOVEL     UM(1)         UMDES
     C                   CLEAR                   XWPRIC
     C                   CLEAR                   XWHLTX
     C                   CLEAR                   XWDESC
     C                   MOVE      '0'           FIRST             1
     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C   99              WRITE     ZZMC01                                                  |
     C     FIRST         IFEQ      '0'                                          B--------02|
     C                   EXFMT     ZZFT01                                                 ||
     C                   END                                                    E--------02|
     C                   CALL      'XBCCLMSG'                                              |
     C     *IN03         IFEQ      '1'                                          B--------02|
     C     *IN12         OREQ      '1'                                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- Prompt                                                                            |
     C     *IN04         IFEQ      '1'                                          B--------02|
     C                   EXSR      SRPROM                                                 ||
     C                   ELSE                                                   X........02|
     C*‚Subroutine: Order Header                                                          ||
     C     *IN08         IFEQ      '1'                                          B-------03||
     C                   EXSR      ORDHED                                                |||
     C                   MOVE      '0'           *IN12                                   |||
     C                   ELSE                                                   X.......03||
     C                   EXSR      VALIDT                                                |||
     C  N99              Z-ADD     XWANPR        XWPRIC                                  |||
     C                   SELECT                                                 B------04|||
     C     *IN99         WHENEQ    '0'                                          W......04|||
     C     FIRST         ANDEQ     '1'                                                  ||||
     C                   WRITE     CONDETR                              99              ||||
     C     *IN99         IFEQ      '1'                                          B-----05||||
     C                   MOVE      'Y2U0004'     MSGID                                 |||||
     C                   CALL      RTNMTX                                              |||||
     C                   PARM                    MSGID             7                   |||||
     C                   PARM                    ERRMSG          132                   |||||
     C* Display error message                                                          |||||
     C                   MOVEL     ERRMSG        ZMSAGE                                |||||
     C                   ELSE                                                   X.....05||||
     C                   LEAVE                                                         |||||
     C                   ENDIF                                                  E-----05||||
     C     *IN99         WHENEQ    '0'                                          W......04|||
     C     FIRST         ANDEQ     '0'                                                  ||||
     C                   MOVE      '1'           FIRST                                  ||||
     C                   EXFMT     ZZCNF1                                               ||||
     C     *IN03         IFEQ      '1'                                          B-----05||||
     C     *IN12         OREQ      '1'                                                 |||||
     C                   MOVE      '0'           FIRST                                 |||||
     C                   MOVE      '0'           *IN12                                 |||||
     C                   ITER                                                          |||||
     C                   ENDIF                                                  E-----05||||
     C* Display error message                                                           ||||
     C     *IN99         WHENEQ    '1'                                          W......04|||
     C                   MOVEL     ERRMSG        ZMSAGE                                 ||||
     C                   ENDSL                                                  E------04|||
     C                   ENDIF                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C                   ENDDO                                                  E---------01
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     CMDKEY        BEGSR
     C*****************************************************
     C*‚Subroutine: Action command keys
     C*****************************************************
     C                   SELECT                                                 B---------01
     C     *IN06         WHENEQ    '1'                                          W.........01
     C                   EXSR      ZADD                                                    |
     C     *IN08         WHENEQ    '1'                                          W.........01
     C                   EXSR      ORDHED                                                  |
     C                   ENDSL                                                  E---------01
     C                   MOVE      '0'           *IN12
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     VALIDT        BEGSR
     C*****************************************************
     C*‚Subroutine: Validation
     C*****************************************************
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
     C                   MOVEL     *ALL'-'       XWHLTX                                   ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- IF ADDITION, PULL THE PRICE FROM FILE                                             |
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
     C                   MOVEL     *ALL'-'       XWDESC                                   ||
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
     C*- TRANSACTION TYPE                                                                  |
     C     XWRICD        CHAIN     TRNTYP                             99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVEL     *ALL'-'       XWTDSC                                   ||
     C                   MOVE      'OES0371'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*- UNIT OF MEASURE                                                                   |
     C                   CLEAR                   UMDES                                     |
     C                   SELECT                                                 B--------02|
     C     XWA2CD        WHENEQ    'EAC'                                        W........02|
     C                   MOVEL     UM(1)         UMDES                                    ||
     C                   OTHER                                                  W........02|
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVEL     *ALL'-'       UMDES                                    ||
     C                   MOVE      'OES0372'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDSL                                                  E--------02|
     C                   ENDDO                                                  E---------01
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     ORDHED        BEGSR
     C*****************************************************
     C*‚Subroutine: Order Header
     C*****************************************************
     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C                   EXFMT     ZZFT02                                                  |
     C                   ENDDO                                                  E---------01
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     *INZSR        BEGSR
     C*****************************************************
     C*‚Subroutine: Initialisation routines
     C*****************************************************
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
     C   99              MOVEL     *ALL'-'       XWG4TX
     C*- REPRESENTATIVE
     C     PERSON        CHAIN     SLMEN                              99
     C   99              MOVEL     *ALL'-'       PNAME
     C*- STATUS
     C     XWSTAT        CHAIN     ORDSTS                             99
     C   99              MOVEL     *ALL'-'       XWSDSC
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     SRPROM        BEGSR
     C*****************************************************
     C*‚Subroutine: prompts for F04
     C*****************************************************
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
**
Each KGS
