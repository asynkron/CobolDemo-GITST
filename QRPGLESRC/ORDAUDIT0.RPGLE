     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2012
     H*‚--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2004') datedit(*dmy)

     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     FSTOMAS    uf   e           k disk
     FCONDETL2  uf   e           k disk
     FSTKBAL    uf   e           k disk


     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D UwPro           S              6  0
     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
     C*‚
     C*‚Update Write STOMAS
     C                   Eval      XWAACS='AND'
     C     XWAACS        SetLL(E)  STOMASR
     C     XWAACS        ReadE(E)  STOMASR
     C                   Dow       Not %EOF and Not %Error
     C                   Delete(E) STOMASR
     C     XWAACS        ReadE(E)  STOMASR
     C                   EndDo
     C*‚
     C*‚Update CONDET
     C                   Eval      XWAACS='AND'
     C                   Eval      XWABCD='000080'
     C                   Eval      UwPro = %Dec(XWABCD:6:0)
     C                   DoW       UwPro <= 82
     C     KYCOND        Chain(E)  CONDETR
     C                   If        %Found(CONDETL2)  and not %Error
     C                   Eval      XWAACS='UK'
     C                   Update    CONDETR
     C                   EndIf
     C                   Eval      XWAACS='AND'
     C                   Eval      UwPro = UwPro + 1
     C                   Eval      XWABCD=%EDITC(UwPro:'X')
     C                   EndDo
     C*‚
     C*‚Update STKBAL
     C                   Eval      XWAACS='AND'
     C                   Eval      XWABCD='000080'
     C                   Eval      UwPro = %Dec(XWABCD:6:0)
     C                   DoW       UwPro <= 82
     C     KYCOND        Chain(E)  STKBALR
     C                   If        %Found(STKBAL)  and not %Error
     C                   Eval      XWAACS='UK'
     C                   Update    STKBALR
     C                   EndIf
     C                   Eval      XWAACS='AND'
     C                   Eval      UwPro = UwPro + 1
     C                   Eval      XWABCD=%EDITC(UwPro:'X')
     C                   EndDo
     C*‚
     C*‚Update Qauntity STKBAL for Given XWAACS
     C*‚For XWAACS='UK'
     C                   Eval      XWAACS='UK'
     C                   Eval      XWABCD='000080'
     C                   Eval      UwPro = %Dec(XWABCD:6:0)
     C                   DoW       UwPro <= 82
     C     KYCOND        Chain(E)  STKBALR
     C                   If        %Found(STKBAL)  and not %Error
     C                   Eval      XWBHQT = 200
     C                   Eval      XWBKQT = 60
     C                   Update    STKBALR
     C                   EndIf
     C                   Eval      UwPro = UwPro + 1
     C                   Eval      XWABCD=%EDITC(UwPro:'X')
     C                   EndDo
     C*‚
     C*
     C*‚For XWAACS='RSA'
     C                   Eval      XWAACS='RSA'
     C                   Eval      XWABCD='000080'
     C                   Eval      UwPro = %Dec(XWABCD:6:0)
     C                   DoW       UwPro <= 82
     C     KYCOND        Chain(E)  STKBALR
     C                   If        %Found(STKBAL)  and not %Error
     C                   Eval      XWBHQT = 350
     C                   Eval      XWBKQT = 120
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
