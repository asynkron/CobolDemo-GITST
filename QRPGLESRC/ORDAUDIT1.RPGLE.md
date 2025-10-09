# ORDAUDIT1.RPGLE Member Guide

## Overview
ILE RPG program `ORDAUDIT1` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ORDAUDIT1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2012
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2004') datedit(*dmy)

     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     FSTOMAS    uf a e           k disk
     FCONDETL2  uf   e           k disk
     FSTKBAL    uf   e           k disk


     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D UwPro           S              6  0
     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
     C*
     C*Update Write STOMAS
     C                   Eval      XWAACS='AND'
     C                   Eval      XWDESC='Andorra'
     C                   Write(E)  STOMASR
     C*
     C*Update CONDET
     C                   Eval      XWAACS='UK'
     C                   Eval      XWABCD='000080'
     C                   Eval      UwPro = %Dec(XWABCD:6:0)
     C                   DoW       UwPro <= 82
     C     KYCOND        Chain(E)  CONDETR
     C                   If        %Found(CONDETL2)  and not %Error
     C                   Eval      XWAACS='AND'
     C                   Update    CONDETR
     C                   EndIf
     C                   Eval      XWAACS='UK'
     C                   Eval      UwPro = UwPro + 1
     C                   Eval      XWABCD=%EDITC(UwPro:'X')
     C                   EndDo
     C*
     C*Update STKBAL
     C                   Eval      XWAACS='UK'
     C                   Eval      XWABCD='000080'
     C                   Eval      UwPro = %Dec(XWABCD:6:0)
     C                   DoW       UwPro <= 82
     C     KYCOND        Chain(E)  STKBALR
     C                   If        %Found(STKBAL)  and not %Error
     C                   Eval      XWAACS='AND'
     C                   Update    STKBALR
     C                   EndIf
     C                   Eval      XWAACS='UK'
     C                   Eval      UwPro = UwPro + 1
     C                   Eval      XWABCD=%EDITC(UwPro:'X')
     C                   EndDo
     C*
     C*Update Qauntity STKBAL for Given XWAACS
     C*For XWAACS='UK'
     C                   Eval      XWAACS='AND'
     C                   Eval      XWABCD='000080'
     C                   Eval      UwPro = %Dec(XWABCD:6:0)
     C                   DoW       UwPro <= 82
     C     KYCOND        Chain(E)  STKBALR
     C                   If        %Found(STKBAL)  and not %Error
     C                   Eval      XWBHQT = XWBHQT + 1
     C                   Eval      XWBKQT = XWBKQT + 1
     C                   Update    STKBALR
     C                   EndIf
     C                   Eval      UwPro = UwPro + 1
     C                   Eval      XWABCD=%EDITC(UwPro:'X')
     C                   EndDo
     C*
     C*
     C*For XWAACS='RSA'
     C                   Eval      XWAACS='RSA'
     C                   Eval      XWABCD='000080'
     C                   Eval      UwPro = %Dec(XWABCD:6:0)
     C                   DoW       UwPro <= 82
     C     KYCOND        Chain(E)  STKBALR
     C                   If        %Found(STKBAL)  and not %Error
     C                   Eval      XWBHQT = XWBHQT + 1
     C                   Eval      XWBKQT = XWBKQT + 1
     C                   Update    STKBALR
     C                   EndIf
     C                   Eval      UwPro = UwPro + 1
     C                   Eval      XWABCD=%EDITC(UwPro:'X')
     C                   EndDo
     C
     C                   Eval      *InLR = *On
     C                   Return
     C*
     C*
     C     *InzSr        BegSr
     C
     C     KYCOND        KLIST
     C                   KFLD                    XWABCD
     C                   KFLD                    XWAACS
     C
     C                   EndSr
````
