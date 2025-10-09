     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2004
     H*‚--------------------------------------------------------------------
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     FCUSFMAINTDCF   E             WORKSTN
     FCUSFL3    UF   E           K DISK
     FDISTS     IF   E           K DISK

     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D STTSES          S              1    DIM(37) CTDATA PERRCD(37)
     D MTH             S              3    DIM(12) CTDATA PERRCD(12)
     D VALNUM          S              1    DIM(11) CTDATA PERRCD(11)
     D**********************************************************************
     D                 DS
     D  Y8MMDD                 1      8  0
     D  YY8                    1      4  0
     D  MM8                    5      6  0
     D  DD8                    7      8  0
     D                 DS
     D  ZTELNO                 1     17
     D  XTELNO                 1     17
     D                                     DIM(17)
     D                 DS
     D  ZFAXNO                 1     15
     D  XFAXNO                 1     15
     D                                     DIM(15)
     D                 DS                  INZ
     D  ZDATE                  1     11
     D  ZDAY                   1      2
     D  FLLER1                 3      3
     D  ZMTH                   4      6
     D  FLLER2                 7      7
     D  ZYR                    8     11
     D*********************************************************************
     D RTNMTX          C                   CONST('RTNMSGTEXT')
     D PROFES          C                   CONST('Professor')
     D ZZPGM           C                   CONST('CUSFMAINT ')
     C*****************************************************
     C*‚M a i n l i n e   C o d e
     C*****************************************************
     C*‚Retrieve record
     C     CUSNO         CHAIN     RCUSF                              01
     C     *IN01         IFEQ      '1'                                          B---------01
     C                   MOVE      '1'           *INLR                                     |
     C                   RETURN                                                            |
     C                   ENDIF                                                  E---------01
     C*‚Set screen values
     C                   EXSR      WRTSCN
     C                   clear                   ZMSAGE
     C*-
     C*‚Until Exit/Cancel
     C     *IN03         DOWEQ     '0'                                          B---------01
     C     *IN12         ANDEQ     '0'                                                     |
     C*-                                                              |
     C*‚Display screen                                                |
     C     CURPAG        IFEQ      1                                            B--------02|
     C                   EXFMT     ZZFT01                               99                ||
     C                   ELSE                                                   X........02|
     C                   EXFMT     ZZFT02                               99                ||
     C                   END                                                    E--------02|
     C*‚If Exit/Cancel                                                |
     C     *IN03         IFEQ      '1'                                          B--------02|
     C     *IN12         OREQ      '1'                                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*‚Other Command Keys                                            |
     C                   SELECT                                                 B--------02|
     C     *IN18         WHENEQ    '1'                                          W........02|
     C                   MOVE      2             CURPAG                                   ||
     C                   MOVE      '0'           *IN18                                    ||
     C                   ITER                                                             ||
     C     *IN17         WHENEQ    '1'                                          W........02|
     C                   MOVE      1             CURPAG                                   ||
     C                   MOVE      '0'           *IN17                                    ||
     C                   ITER                                                             ||
     C     *IN08         WHENEQ    '1'                                          W........02|
     C                   CALL      'WWCCONS'                            99                ||
     C                   PARM                    ZCUSNO                                   ||
     C                   ITER                                                             ||
     C     *IN09         WHENEQ    '1'                                          W........02|
     C                   CALL      'DSPDISTS'                           99                ||
     C                   PARM                    ZDSCDE                                   ||
     C                   ITER                                                             ||
     C     *IN10         WHENEQ    '1'                                          W........02|
     C                   CALL      'WWRAREAS'                           99                ||
     C                   PARM                    ZSINIT                                   ||
     C                   ITER                                                             ||
     C                   ENDSL                                                  E--------02|
     C*‚Else validate                                                 |
     C                   EXSR      VALIDT                                                  |
     C*‚If valid                                                      |
     C     VALID         IFEQ      '1'                                          B--------02|
     C*‚Update file and leave                                        ||
     C                   EXSR      UPDFIL                                                 ||
     C                   LEAVE                                                            ||
     C*‚Else: If not valid                                           ||
     C                   ELSE                                                   X........02|
     C*‚Display error message                                        ||
     C                   MOVEL     ERRMSG        ZMSAGE                                   ||
     C*‚End: If valid                                                ||
     C                   ENDIF                                                  E--------02|
     C*‚End: Until Exit/Cancel                                        |
     C                   ENDDO                                                  E---------01
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*****************************************************
     C*‚L o g i c al   E n d   o f   P r o g r a m
     C*****************************************************
     C*
     C*****************************************************
     C     WRTSCN        BEGSR
     C*****************************************************
     C*‚Subroutine: Write screen
     C*****************************************************
     C                   MOVE      CUSNO         ZCUSNO
     C                   MOVE      CNAME         ZCNAME
     C                   MOVE      ADD1          ZADD1
     C                   MOVE      ADD2          ZADD2
     C                   MOVE      ADD3          ZADD3
     C                   MOVE      ADD4          ZADD4
     C                   MOVE      CNTRY         ZCNTRY
     C                   MOVE      PSCD          ZPSCD
     C                   MOVE      TELNO         ZTELNO
     C                   MOVE      FAXNO         ZFAXNO
     C                   MOVE      EMAIL         ZEMAIL
     C                   MOVE      WEBSIT        ZWEBST
     C                   MOVE      DSDCDE        ZDSCDE
     C                   MOVE      SINIT         ZSINIT
     C                   MOVE      STATUS        ZSTTUS
     C                   MOVE      USERNM        ZUSRNM
     C                   MOVE      SALUT         ZSALUT
     C                   MOVE      JTITLE        ZJTTLE
     C* VER *YMD
     C                   Z-ADD     LCTDAT        Y8MMDD
     C                   EXSR      SDT6T8
     C                   Z-ADD     Y8MMDD        ZLCTDT
     C* VER *YMD
     C                   Z-ADD     APDATE        Y8MMDD
     C                   EXSR      SDT6T8
     C                   Z-ADD     Y8MMDD        ZAPDAT
     C*
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     SDT6T8        BEGSR
     C*****************************************************
     C*‚Subroutine: Converts dates
     C*****************************************************
     C     YY8           IFLT      50
     C                   ADD       2000          YY8
     C                   ELSE
     C                   ADD       1900          YY8
     C                   ENDIF
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     UPDFIL        BEGSR
     C*****************************************************
     C*‚Subroutine: Update file
     C*****************************************************
     C                   MOVE      ZCUSNO        CUSNO
     C                   MOVE      ZCNAME        CNAME
     C                   MOVE      ZADD1         ADD1
     C                   MOVE      ZADD2         ADD2
     C                   MOVE      ZADD3         ADD3
     C                   MOVE      ZADD4         ADD4
     C                   MOVE      ZCNTRY        CNTRY
     C                   MOVE      ZPSCD         PSCD
     C                   MOVE      ZTELNO        TELNO
     C                   MOVE      ZFAXNO        FAXNO
     C                   MOVE      ZEMAIL        EMAIL
     C                   MOVE      ZWEBST        WEBSIT
     C                   MOVE      ZDSCDE        DSDCDE
     C                   MOVE      ZSINIT        SINIT
     C                   MOVE      ZSTTUS        STATUS
     C                   MOVE      ZUSRNM        USERNM
     C                   MOVE      ZSALUT        SALUT
     C                   MOVE      ZJTTLE        JTITLE
     C* VER *YMD
     C                   MOVE      ZLCTDT        LCTDAT
     C* VER *YMD
     C                   MOVE      ZAPDAT        APDATE
     C                   UPDATE    RCUSF                                99
     C     *IN99         IFEQ      '0'                                          B---------01
     C                   MOVE      'Y'           UPDTED                                    |
     C                   ENDIF                                                  E---------01
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C*‚Subroutine: Validate screen
     C*****************************************************
     C     VALIDT        BEGSR
     C*****************************************************
     C                   MOVE      CURPAG        PRVPAG            1 0
     C                   DO                                                     B---------01
     C                   MOVE      *OFF          *IN32                                     |
     C                   MOVE      *OFF          *IN33                                     |
     C                   MOVE      *OFF          *IN34                                     |
     C                   MOVE      *OFF          *IN35                                     |
     C                   MOVE      *OFF          *IN36                                     |
     C                   MOVE      *OFF          *IN37                                     |
     C                   MOVE      *OFF          *IN38                                     |
     C                   MOVE      *OFF          *IN39                                     |
     C                   MOVE      *OFF          *IN40                                     |
     C                   MOVE      *OFF          *IN41                                     |
     C                   MOVE      *OFF          *IN42                                     |
     C                   MOVE      *OFF          *IN43                                     |
     C                   MOVE      *OFF          *IN44                                     |
     C                   MOVE      '1'           VALID             1                       |
     C*‚Customer name                                                 |
     C     ZCNAME        IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      *ON           *IN32                                    ||
     C                   MOVE      'OEM0012'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID             7                      ||
     C                   PARM                    ERRMSG          132                      ||
     C                   MOVE      '0'           VALID                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*‚Telephone number                                              |
     C     ZTELNO        IFNE      *BLANKS                                      B--------02|
     C                   Z-ADD     1             Z1                                       ||
     C     Z1            DOWLE     17                                           B-------03||
     C     XTELNO(Z1)    LOOKUP    VALNUM                                 99             |||
     C     *IN99         IFEQ      '0'                                          B------04|||
     C                   MOVE      *ON           *IN34                                  ||||
     C                   MOVE      'OEM0014'     MSGID                                  ||||
     C                   CALL      RTNMTX                                               ||||
     C                   PARM                    MSGID                                  ||||
     C                   PARM                    ERRMSG                                 ||||
     C                   MOVE      '0'           VALID                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||
     C                   ADD       1             Z1                                      |||
     C                   ENDDO                                                  E-------03||
     C   34              LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*‚Fax number                                                    |
     C     ZFAXNO        IFNE      *BLANKS                                      B--------02|
     C                   Z-ADD     1             Z1                                       ||
     C     Z1            DOWLE     15                                           B-------03||
     C     XFAXNO(Z1)    LOOKUP    VALNUM                                 99             |||
     C     *IN99         IFEQ      '0'                                          B------04|||
     C                   MOVE      *ON           *IN35                                  ||||
     C                   MOVE      'OEM0015'     MSGID                                  ||||
     C                   CALL      RTNMTX                                               ||||
     C                   PARM                    MSGID                                  ||||
     C                   PARM                    ERRMSG                                 ||||
     C                   MOVE      '0'           VALID                                  ||||
     C                   LEAVE                                                          ||||
     C                   ENDIF                                                  E------04|||
     C                   ADD       1             Z1                                      |||
     C                   ENDDO                                                  E-------03||
     C   35              LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*-                                                              |
     C                   MOVE      2             CURPAG                                    |
     C*‚Distributor                                                   |
     C     ZDSCDE        IFNE      *BLANKS                                      B--------02|
     C     ZDSCDE        SETLL     RPRODS                                 99              ||
     C     *IN99         IFEQ      '0'                                          B-------03||
     C                   MOVE      *ON           *IN38                                   |||
     C                   MOVE      'OEM0018'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID                                   |||
     C                   PARM                    ERRMSG                                  |||
     C                   MOVE      '0'           VALID                                   |||
     C                   LEAVE                                                           |||
     C                   ENDIF                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C*‚Status                                                        |
     C     ZSTTUS        IFNE      *BLANKS                                      B--------02|
     C                   MOVE      1             Z1                5 0                    ||
     C     ZSTTUS        LOOKUP    STTSES                                 77              ||
     C     *IN77         IFEQ      '0'                                          B-------03||
     C                   MOVE      *ON           *IN39                                   |||
     C                   MOVE      'OEM0019'     MSGID                                   |||
     C                   CALL      RTNMTX                                                |||
     C                   PARM                    MSGID                                   |||
     C                   PARM                    ERRMSG                                  |||
     C                   MOVE      '0'           VALID                                   |||
     C                   LEAVE                                                           |||
     C                   ENDIF                                                  E-------03||
     C                   ENDIF                                                  E--------02|
     C*‚Contact                                                       |
     C     ZUSRNM        IFEQ      *BLANKS                                      B--------02|
     C                   MOVE      *ON           *IN40                                    ||
     C                   MOVE      'OEM0020'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID                                    ||
     C                   PARM                    ERRMSG                                   ||
     C                   MOVE      '0'           VALID                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C*‚Title                                                         |
     C     ZSALUT        IFNE      *BLANKS                                      B--------02|
     C     ZSALUT        ANDNE     'Mr'                                                   ||
     C     ZSALUT        ANDNE     'Mrs'                                                  ||
     C     ZSALUT        ANDNE     'Ms'                                                   ||
     C     ZSALUT        ANDNE     'Dr'                                                   ||
     C     ZSALUT        ANDNE     'Doctor'                                               ||
     C     ZSALUT        ANDNE     PROFES                                                 ||
     C     ZSALUT        ANDNE     'Sir'                                                  ||
     C     ZSALUT        ANDNE     'Lord'                                                 ||
     C     ZSALUT        ANDNE     'Lady'                                                 ||
     C                   MOVE      *ON           *IN41                                    ||
     C                   MOVE      'OEM0021'     MSGID                                    ||
     C                   CALL      RTNMTX                                                 ||
     C                   PARM                    MSGID                                    ||
     C                   PARM                    ERRMSG                                   ||
     C                   MOVE      '0'           VALID                                    ||
     C                   LEAVE                                                            ||
     C                   ENDIF                                                  E--------02|
     C                   MOVE      PRVPAG        CURPAG                                    |
     C                   ENDDO                                                  E---------01
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C     *INZSR        BEGSR
     C*****************************************************
     C*‚Subroutine: Perform Initialisation Routines
     C*****************************************************
     C*‚Set screen values
     C                   MOVE      *DAY          ZDAY
     C                   MOVE      *YEAR         ZYR
     C                   MOVE      *MONTH        XMTH              2 0
     C                   MOVE      MTH(XMTH)     ZMTH
     C                   MOVE      ZDATE         ZZDATE
     C*‚- Protect customr number
     C                   MOVE      *ON           *IN31
     C*‚If customer number not provided then prompt
     C     CSTMER        IFEQ      *ZEROS                                       B---------01
     C                   CALL      'CUSFSEL'                            99                 |
     C                   PARM                    CSTMER                                    |
     C                   ENDIF                                                  E---------01
     C*‚Set customer number
     C                   MOVE      CSTMER        CUSNO
     C*‚Initialise updated flag
     C                   MOVE      'N'           UPDTED
     C                   MOVE      1             CURPAG            1 0
     C                   ENDSR
     C*****************************************************
     C*****************************************************
     C*‚N o n - E x e c u t a b l e   C o d e
     C*****************************************************
     C     *ENTRY        PLIST
     C                   PARM                    CSTMER            5 0
     C                   PARM                    UPDTED            1
     C*****************************************************
**
 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
**
JanFebMarAprMayJunJulAugSepOctNovDec
**
 0123456789
