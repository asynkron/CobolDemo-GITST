# CB906R@BK.RPG Member Guide

## Overview
RPG III program `CB906R@BK` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CB906R@BK`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCB906RD CF  E                    WORKSTN
     FSECF    UF  E           K        DISK                      A
     FCBORPF  UF  E           K        DISK                      A
     FCBACPF  IF  E           K        DISK
     FCBLNPF  IF  E           K        DISK
     FCBSTPF  IF  E           K        DISK
     E                    ARC        40  1
     C           *ENTRY    PLIST
     C                     PARM           WWACFN  3
     C                     PARM           WWACTP  10
     C                     PARM           WWACSS  1
     C                     PARM           WWDAPG  60
     C                     PARM           WWPTIT 104
     C                     PARM           WWPTTR 104
     C                     PARM           WWTATP  3
     C                     PARM           WWVLDA  60
     C                     PARM           WWTAAM  83
     C                     PARM           WWACFG  1
     C                     PARM           XXTODA  60
     C                     PARM           WWCHG   1        DELETE FLAG
     C* Initialise Parameters
 0636C           SDP001    DOUEQ'N'
 0640C           @@@RTN    DOUEQ'E'
 0642C           @@@CTL    ANDEQ' '
     C           SSRLNB    IFEQ *BLANKS
     C                     MOVEL*ON       ZZERR   1
     C                     MOVEL'OEM0003' MSGID   7
     C*                    MOVEL'OEM0016' MSGID   7
     C                     ENDIF
     C                     MOVE ACACFN    WWACFN
 0765C                     EXSR $PV001
     C                     READ CBACPF                   26
     C* INITIALISE SCREEN :
     C           WWACFN    IFEQ 'ACT'
     C           WWACSS    OREQ 'D'
     C                     Z-ADD0         XXITAM
     C                     Z-ADD0         XXTRAM    N
     C                     END
     C           WWACFG    IFEQ 'M'
     C           WWTATP    IFEQ 'CLS'
     C           WWCHG     IFEQ 'D'
     C                     MOVE 'A'       WWACSS
     C*  Calculate predicted interest
     C           WWACFN    IFEQ 'AL '
     C           *IN01     IFEQ '1'
 0642C                     MOVE ' '       @@@CTL  1
     C                     EXSR $RETRN
     C                     END
     C                     Z-ADDXXITAM    WWPTIT
     C                     Z-ADDXXTRAM    WWPTTR
     C                     END
     C                     ELSE
     C*                    MOVE 'N'       WWACSS
     C                     MOVE 'S'       WWACSS
     C                     MOVE 'Y'       SDP001  1
     C                     Z-ADD0         WWPTIT
     C                     Z-ADD0         WWPTTR
     C                     END
     C                     END
     C                     END
     C           WWTATP    IFEQ 'COF'
     C           WWCHG     IFEQ 'D'
     C                     MOVE 'D'       WWACSS
     C                     ELSE
     C*                    MOVE 'A'       WWACSS
     C                     MOVE 'B'       WWACSS
     C                     END
     C                     END
     C*
     C           WWACBL    SUB  ACITRT    WWACBL
     C           WWACBL    IFGE 0
     C           WWCRIR    SUB  WWTXRT    WWCRIR 153
     C           WWCRIR    MULT WWACBL    WWACBL 153
     C           WWACBL    DIV  100       WWACBL
     C                     ELSE
     C           WWDRIR    ADD  WWTXRT    WWDRIR 153
     C           WWDRIR    MULT WWACBL    WWACBL
     C           WWACBL    DIV  100       WWACBL
     C                     END
     C           ACITRT    MULT WWACBL    WWACBL
     C           WWACBL    DIV  100       WWACBL
     C* IF CAP - UPDATE ARREARS ON MIN EVENTS
     C           WWACFN    IFEQ 'CAP'
     C           WWTATP    IFEQ 'REP'
     C           KEY001    SETLLCBORPF
     C           *IN90     DOUEQ'1'
     C           KEY001    READECBORPF                 9090
     C           WWTATP    IFEQ 'Y'
     C           *IN90     ANDEQ'0'
     C           WWACFN    IFEQ 'AAA'
     C                     SETON                     90
     C                     ELSE
     C                     SUB  WWTAAM    XXITAM
     C           WWACFN    IFLT 'ZZZ'
     C                     Z-ADD0         XXITAM
     C                     END
     C                     UPDATCBORRF
     C                     END
     C                     END
     C                     END
     C                     END
     C                     END
     C                     END
     C                     END
     C                     SETON                     LR
     C                     RETRN
     C***************************************************************
     C           $PV001    BEGSR
     C***************************************************************
     C* $PV001  : VALIDATE NON SUBFILE SCREEN DATA
     C***************************************************************
     C                     EXFMTSCT100
     C           *IN01     DOUEQ'1'
     C           SSRLNB    IFEQ *BLANKS
     C                     MOVEL*ON       ZZERR   1
     C                     MOVEL'OEM0003' MSGID   7
     C*                    MOVEL'OEM0126' MSGID   7
     C                     ENDIF
     C                     MOVE SSRLNB    @C1     1
     C                     Z-ADDUDATE     SCDCRD
     C           @C1       IFEQ *BLANK
     C                     MOVELSSRLNB    @C7     7
     C                     MOVE *BLANK    SSRLNB
     C                     MOVE @C7       SSRLNB
     C                     ENDIF
     C                     CALL 'X@GSCD'                                  005304
     C                     PARM           SSRLNB                          005305
     C                     PARM           SCDEXD                          005306
     C                     PARM           SXAMD1                          005307
     C                     PARM           SXAMD2                          005307
     C                     PARM           SXAMD3                          005307
     C                     PARM           SXAMD4                          005307
     C                     PARM           SXAMD5                          005307
     C                     PARM           SXAMD6                          005307
     C                     PARM           SXAMD7                          005307
     C                     PARM           SXAMD8                          005307
     C                     PARM           SXAMD9                          005307
     C                     PARM           SXAMD0                          005307
     C                     PARM           SCDE
     C                     MOVE 'Y'       RTUBUF  1
     C                     ENDDO
     C                     ENDSR
     C***************************************************************
     C           $RETRN    BEGSR
     C***************************************************************
     C                     MOVE 'E'       @@@RTN  1
     C                     SETON                     LR
     C                     RETRN
     C                     ENDSR
     C*
     C           *LIKE     DEFN AAORDN    KEY001
     C           *LIKE     DEFN AAORDN    KLNPF
     C           *LIKE     DEFN AAORDN    KORPF
     C           *LIKE     DEFN WWPTTR    XXTRAM
     C           *LIKE     DEFN WWPTIT    XXITAM
     C           *LIKE     DEFN WWCRIR    WWTXRT
````
