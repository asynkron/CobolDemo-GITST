     H DATEDIT(*YMD)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     FWTRNHSTD  CF   E             WORKSTN
     F                                     SFILE(ZZSF02:SFLRRN)
     FTRNHSTL3  IF   E           K DISK
     FTRNHST    UF A E           K DISK    RENAME(TRNHSTR:TRNHSTR2)
     FCUSTS     IF   E           K DISK
     FCUSFL3    IF   E           K DISK
     FSLMEN     IF   E           K DISK
     D**********************************************************************
     D*‚Set constants
     D RTNMTX          C                   CONST('RTNMSGTEXT')
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
     C**********************************************************************
     C*‚D e f i n i t i o n s
     C**********************************************************************
     C                   MOVE      '0'           SFLCHG            1
     C                   MOVE      *ZEROS        SFLRRN            5 0
     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
     C     SWBCCD        CHAIN     CUSTS                              99
     C     CUSNO         CHAIN     CUSFL3                             99
     C     PERCUS        CHAIN     SLMEN                              99
     C   99              MOVEL     *ALL'-'       PNAME
     C                   MOVEL     PNAME         SNAME
     C*‚Build subfile
     C                   EXSR      SFLWRT
     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C                   MOVE      *ZEROS        LOCATE                                    |
     C***                MOVEL     *ZEROS        LOCAT1                                    |
     C                   MOVE      *BLANKS       LOCAT2                                    |
     C*‚Display screens                                                                    |
     C                   WRITE     ZZTR01                                                  |
     C                   EXFMT     ZZCT02                                                  |
     C*‚Remove messages                                                                    |
     C                   CALL      'XBCCLMSG'                                              |
     C                   MOVE      *BLANKS       ZMSAGE                                    |
     C     *IN03         IFEQ      '1'                                          B--------02|
     C     *IN12         OREQ      '1'                                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C     LOCATE        IFNE      *ZEROS                                       B--------02|
     C     LOCAT2        ORNE      *BLANKS                                                ||
     C                   MOVE      LOCATE        XWE4NB                                   ||
     C                   MOVE      LOCAT2        XWRICD                                   ||
     C                   EXSR      SFLWRT                                                 ||
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
     C                   MOVE      *LOVAL        XWE4NB                                   ||
     C                   MOVE      *LOVAL        XWRICD                                   ||
     C                   EXSR      SFLWRT                                                 ||
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
     C     KEY01         KLIST
     C                   KFLD                    SWBCCD
     C                   KFLD                    XWE4NB
     C                   KFLD                    XWRICD
     C***                KFLD                    ZWRICD
     C*‚Delete subfile
     C                   SETON                                        74
     C                   SETOFF                                       717231
     C                   WRITE     ZZCT02                               99
     C     KEY01         SETLL     TRNHSTL3
     C     SWBCCD        READE(N)  TRNHSTL3                               31
     C                   SETOFF                                       74
     C*‚Write subfile
     C                   MOVE      *ZEROS        SFLRRN
     C     *IN31         DOWEQ     '0'                                          B---------01
     C                   ADD       1             SFLRRN                                    |
     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   WRITE     ZZSF02                               99                 |
     C     SWBCCD        READE(N)  TRNHSTL3                               31               |
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
     C                   SETON                                        71                   |
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
     C                   READC     ZZSF02                                 35
     C*‚For each selection
     C     *IN35         DOWEQ     '0'                                          B---------01
     C                   MOVE      '1'           SFLCHG                                    |
     C                   SELECT                                                 B--------02|
     C*‚Change                                                                            ||
     C     DSSEL         WHENEQ    '2'                                          W........02|
     C                   EXSR      CHGREC                                                 ||
     C                   MOVE      SFLRRN        SHWREC                                   ||
     C*‚Delete                                                                            ||
     C     DSSEL         WHENEQ    '4'                                                    ||
     C                   EXSR      DELREC                                                 ||
     C*‚Display                                                                           ||
     C     DSSEL         WHENEQ    '5'                                                    ||
     C                   EXSR      DSPREC                                                 ||
     C                   MOVE      SFLRRN        SHWREC                                   ||
     C                   ENDSL                                                  E--------02|
     C                   MOVE      *BLANKS       DSSEL                                     |
     C                   UPDATE    ZZSF02                               99                 |
     C                   READC     ZZSF02                                 35               |
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
     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '00'          *IN(40)                                 |||
     C*- Prompt                                                                          |||
     C     *IN04         IFEQ      '1'                                          B------04|||
     C     SFIELD        IFEQ      'PERSON'                                     B-----05||||
     C                   CALL      'SLMENSEL'                                          |||||
     C                   PARM                    PERSON                                |||||
     C                   PARM                    PNAME                                 |||||
     C                   ENDIF                                                  E-----05||||
     C                   ENDIF                                                  X.....05||||
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     DSPREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Display a record
     C**********************************************************************
     C                   MOVEL     ' DISPLAY'    ACTDSP                                    |
     C                   MOVE      '1'           *IN34
     C                   MOVE      '0'           *IN37
     C                   EXSR      GETREC                                                  |
     C     *IN03         DOWEQ     '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   WRITE     ZZMC01                                                |||
     C                   ENDIF                                                  X.....05||||
     C                   EXFMT     ZZFT01                                               ||||
     C                   CALL      'XBCCLMSG'                                            |||
     C                   MOVE      *BLANKS       ZMSAGE                                  |||
     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '00'          *IN(40)                                 |||
     C*- Prompt                                                                          |||
     C     *IN04         IFEQ      '1'                                          B------04|||
     C     SFIELD        IFEQ      'PERSON'                                     B-----05||||
     C                   CALL      'SLMENSEL'                                          |||||
     C                   PARM                    PERSON                                |||||
     C                   PARM                    PNAME                                 |||||
     C                   ENDIF                                                  E-----05||||
     C                   ENDIF                                                  X.....05||||
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     CHGREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Display a record
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
     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '00'          *IN(40)                                 |||
     C*- Prompt                                                                          |||
     C     *IN04         IFEQ      '1'                                          B------04|||
     C     SFIELD        IFEQ      'PERSON'                                     B-----05||||
     C                   CALL      'SLMENSEL'                                          |||||
     C                   PARM                    PERSON                                |||||
     C                   PARM                    PNAME                                 |||||
     C                   ENDIF                                                  E-----05||||
     C                   ENDIF                                                  X.....05||||
     C                   EXSR      VALIDT                                             ||||||
     C     *IN99         IFEQ      '1'                                          B-------03||
     C                   MOVEL     ERRMSG        ZMSAGE                              |||||||
     C                   ITER
     C                   ENDIF
     C*
     C     *IN03         IFEQ      '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C*                                                                              |||||||
     C                   EXFMT     ZZCNF1                                            |||||||
     C*                                                                              |||||||
     C     *IN03         IFEQ      '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C*                                                                              |||||||
     C                   EXSR      SAVEDATA                                            |||||
     C     KEY02         CHAIN     TRNHST                             9999
     C     *IN99         IFEQ      *OFF                                         W.....05||||
     C                   EXSR      RESTOREDATA                                         |||||
     C                   UPDATE    TRNHSTR2                             99            ||||||
     C                   ENDIF                                                  E-----05||||
     C     *IN99         IFEQ      '1'                                          B---07||||||
     C                   MOVE      'Y2U0007'     MSGID                               |||||||
     C                   CALL      RTNMTX                                            |||||||
     C                   PARM                    MSGID             7                 |||||||
     C                   PARM                    ERRMSG          132                 |||||||
     C* Display error message                                                        |||||||
     C                   MOVEL     ERRMSG        ZMSAGE                              |||||||
     C                   ELSE                                                   X...07||||||
     C                   LEAVE                                                       |||||||
     C                   ENDIF                                                  E---07||||||
     C*
     C                   LEAVE                                                       |||||||
     C                   ENDIF
     C*
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
     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '00'          *IN(40)                                 |||
     C*- Prompt                                                                          |||
     C     *IN04         IFEQ      '1'                                          B------04|||
     C     SFIELD        IFEQ      'PERSON'                                     B-----05||||
     C                   CALL      'SLMENSEL'                                          |||||
     C                   PARM                    PERSON                                |||||
     C                   PARM                    PNAME                                 |||||
     C                   ENDIF                                                  E-----05||||
     C                   ENDIF                                                  X.....05||||
     C     *IN23         IFEQ      '1'                                          B-------03||
     C     KEY02         CHAIN     TRNHST                             9999
     C     *IN99         IFEQ      *OFF                                         B---------01
     C                   DELETE    TRNHSTR2                             99             |||||
     C                   ENDIF                                                  X.....05||||
     C                   LEAVE                                                        ||||||
     C                   ENDIF
     C                   ENDDO
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
     C                   CLEAR                   XWE4NB
     C                   MOVEL     ZDATE         XWDLDT
     C                   CLEAR                   XWC8DT
     C                   CLEAR                   XWBNCD
     C                   CLEAR                   XWBDCD
     C                   CLEAR                   PERSON
     C                   CLEAR                   PNAME
     C                   CLEAR                   XWAACS
     C                   CLEAR                   XWABCD
     C                   CLEAR                   XWAGCD
     C                   CLEAR                   XWAHCD
     C                   CLEAR                   XWAICD
     C                   CLEAR                   XWT8TX
     C                   CLEAR                   XWORDN
     C                   CLEAR                   XWRICD
     C                   CLEAR                   XWA5QT
     C                   CLEAR                   XWVALU
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
     C                   MOVE      '0'           *IN99                                   |||
     C                   MOVEA     '00'          *IN(40)                                 |||
     C*- Prompt                                                                          |||
     C     *IN04         IFEQ      '1'                                          B------04|||
     C     SFIELD        IFEQ      'PERSON'                                     B-----05||||
     C                   CALL      'SLMENSEL'                                          |||||
     C                   PARM                    PERSON                                |||||
     C                   PARM                    PNAME                                 |||||
     C                   ENDIF                                                  E-----05||||
     C                   ENDIF                                                  X.....05||||
     C                   EXSR      VALIDT                                                |||
     C     *IN99         IFEQ      '1'                                          B-------03||
     C                   MOVEL     ERRMSG        ZMSAGE                              |||||||
     C                   ITER
     C                   ENDIF
     C*
     C     *IN03         IFEQ      '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C*
     C                   EXFMT     ZZCNF1                                            |||||||
     C     *IN03         IFEQ      '0'                                          B-------03||
     C     *IN12         ANDEQ     '0'                                                   |||
     C                   WRITE     TRNHSTR2                             99               |||
     C     *IN99         IFEQ      '1'                                          B------04|||
     C                   MOVE      'Y2U0004'     MSGID                                  ||||
     C                   CALL      RTNMTX                                               ||||
     C                   PARM                    MSGID             7                    ||||
     C                   PARM                    ERRMSG          132                    ||||
     C* Display error message                                                           ||||
     C                   MOVEL     ERRMSG        ZMSAGE                                 ||||
     C                   LEAVE                                                        ||||||
     C                   ENDIF
     C                   LEAVE                                                        ||||||
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDDO
     C*
     C                   MOVE      '0'           *IN12
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
     C     KEY02         KLIST
     C                   KFLD                    XWE4NB
     C                   KFLD                    XWDLDT
     C                   KFLD                    XWC8DT
     C*-
     C                   MOVE      '0'           *IN99
     C                   MOVEA     '00'          *IN(40)
     C                   MOVE      *BLANKS       ZMSAGE
     C                   DO                                                     B---------01
     C* When adding a transaction, period must not be zero:                                |
     C     XWE4NB        IFEQ      *ZEROS                                       B--------02|
     C                   MOVE      '1'           *IN99                                    ||
     C                   MOVE      '1'           *IN40                                    ||
     C                   MOVE      'OEM0010'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C* When adding transaction must not exist:                                            |
     C     *IN36         IFEQ      '1'                                          B--------02|
     C     KEY02         SETLL     TRNHST                                 99              ||
     C     *IN99         IFEQ      '1'                                          B-------03||
     C                   MOVE      '1'           *IN40                                   |||
     C                   MOVE      'Y2U0003'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID             7                     |||
     C                   PARM                    ERRMSG          132                     |||
     C                   LEAVE                                                           |||
     C                   ENDIF                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C*- Salesman Code must be valid:                                                      |
     C     PERSON        CHAIN     SLMEN                              99                   |
     C     *IN99         IFEQ      '1'                                          B--------02|
     C                   MOVE      '1'           *IN41                                    ||
     C                   MOVE      'OEM0023'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   MOVE      *ALL'-'       PNAME                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C                   ENDDO                                                  E---------01
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     GETREC        BEGSR
     C**********************************************************************
     C*‚Subroutine: Retrieve record
     C**********************************************************************
     C     KEY02         CHAIN(N)  TRNHST                             9999
     C     *IN99         IFEQ      '1'                                          B---------01
     C                   MOVE      'Y3U9999'     MSGID                                     |
     C                   CALL      RTNMTX                                                  |
     C                   PARM                    MSGID             7                       |
     C                   PARM                    ERRMSG          132                       |
     C                   MOVEL     ERRMSG        ZMSAGE                                    |
     C                   ENDIF                                                  X.........01
     C                   EXSR      VALIDT                                                 ||
     C                   ENDSR
     C**********************************************************************
     C*
     C**********************************************************************
     C     *INZSR        BEGSR
     C**********************************************************************
     C*‚Subroutine: Initialisation routines
     C**********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    SWBCCD           11
     C*‚Initialise message subfile
     C                   MOVE      '1'           *IN32
     C                   MOVEL     'WWTRNHST'    ZZPGM
     C*-‚Set date
     C                   MOVE      *DATE         ZZDATE
     C                   MOVE      *YEAR         ZYR
     C                   MOVE      '-'           FILLR1
     C                   MOVE      *MONTH        ZMTH
     C                   MOVE      '-'           FILLR2
     C                   MOVE      *DAY          ZDAY
     C                   ENDSR
     C*********************************************************************
     C     SAVEDATA      BEGSR
     C*********************************************************************
     C*‚Subroutine: Save current data
     C*********************************************************************
     C                   MOVE      XWE4NB        ZWE4NB                         B---------01
     C                   MOVE      XWDLDT        ZWDLDT                         B---------01
     C                   MOVE      XWC8DT        ZWC8DT                         B---------01
     C                   MOVE      XWBCCD        ZWBCCD                         B---------01
     C                   MOVE      XWBNCD        ZWBNCD                         B---------01
     C                   MOVE      XWBDCD        ZWBDCD                         B---------01
     C                   MOVE      PERSON        ZPERSON                        B---------01
     C                   MOVE      XWAACS        ZWAACS                         B---------01
     C                   MOVE      XWABCD        ZWABCD                         B---------01
     C                   MOVE      XWAGCD        ZWAGCD                         B---------01
     C                   MOVE      XWAHCD        ZWAHCD                         B---------01
     C                   MOVE      XWAICD        ZWAICD                         B---------01
     C                   MOVE      XWT8TX        ZWT8TX                         B---------01
     C                   MOVE      XWORDN        ZWORDN                         B---------01
     C                   MOVE      XWRICD        ZWRICD                         B---------01
     C                   MOVE      XWA5QT        ZWA5QT                         B---------01
     C                   MOVE      XWVALU        ZWVALU                         B---------01

     C     *LIKE         DEFINE    XWE4NB        ZWE4NB                         B---------01
     C     *LIKE         DEFINE    XWDLDT        ZWDLDT                         B---------01
     C     *LIKE         DEFINE    XWC8DT        ZWC8DT                         B---------01
     C     *LIKE         DEFINE    XWBCCD        ZWBCCD                         B---------01
     C     *LIKE         DEFINE    XWBNCD        ZWBNCD                         B---------01
     C     *LIKE         DEFINE    XWBDCD        ZWBDCD                         B---------01
     C     *LIKE         DEFINE    PERSON        ZPERSON                        B---------01
     C     *LIKE         DEFINE    XWAACS        ZWAACS                         B---------01
     C     *LIKE         DEFINE    XWABCD        ZWABCD                         B---------01
     C     *LIKE         DEFINE    XWAGCD        ZWAGCD                         B---------01
     C     *LIKE         DEFINE    XWAHCD        ZWAHCD                         B---------01
     C     *LIKE         DEFINE    XWAICD        ZWAICD                         B---------01
     C     *LIKE         DEFINE    XWT8TX        ZWT8TX                         B---------01
     C     *LIKE         DEFINE    XWORDN        ZWORDN                         B---------01
     C     *LIKE         DEFINE    XWRICD        ZWRICD                         B---------01
     C     *LIKE         DEFINE    XWA5QT        ZWA5QT                         B---------01
     C     *LIKE         DEFINE    XWVALU        ZWVALU                         B---------01

     C                   ENDSR
     C*********************************************************************

     C*********************************************************************
     C     RESTOREDATA   BEGSR
     C*********************************************************************
     C*‚Subroutine: Restore current data
     C*********************************************************************
     C                   MOVE      ZWE4NB        XWE4NB                         B---------01
     C                   MOVE      ZWDLDT        XWDLDT                         B---------01
     C                   MOVE      ZWC8DT        XWC8DT                         B---------01
     C                   MOVE      ZWBCCD        XWBCCD                         B---------01
     C                   MOVE      ZWBNCD        XWBNCD                         B---------01
     C                   MOVE      ZWBDCD        XWBDCD                         B---------01
     C                   MOVE      ZPERSON       PERSON                         B---------01
     C                   MOVE      ZWAACS        XWAACS                         B---------01
     C                   MOVE      ZWABCD        XWABCD                         B---------01
     C                   MOVE      ZWAGCD        XWAGCD                         B---------01
     C                   MOVE      ZWAHCD        XWAHCD                         B---------01
     C                   MOVE      ZWAICD        XWAICD                         B---------01
     C                   MOVE      ZWT8TX        XWT8TX                         B---------01
     C                   MOVE      ZWORDN        XWORDN                         B---------01
     C                   MOVE      ZWRICD        XWRICD                         B---------01
     C                   MOVE      ZWA5QT        XWA5QT                         B---------01
     C                   MOVE      ZWVALU        XWVALU                         B---------01

     C                   ENDSR
     C*********************************************************************
