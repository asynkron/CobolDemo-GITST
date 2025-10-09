     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     FPROORDS   O    E             DISK
     F*
     FCONHDR    if   e           k disk
     FCONDTL    if   e           k disk
     F*‚
     Fxreport   o    e             printer oflind(*in01)

     D**********************************************************************
     C**********************************************************************
     C                   MOVEL     P#PROD        X#PROD           20
     C     *loval        SETLL     CONHDRR                            2020

     C                   read      CONHDRR                              2020

     C* For each Contract record
     C                   dow       *in20 = *off

     C     XWSTAT        ifne      'XX'
     C     dtlkey        setll     CONDTLR                            2121

     C     dtlkey        reade     CONDTLR                              2121
     C                   dow       *in21 = *off
     C                   exsr      zprint                                                      00590
     C                   exsr      $update                                                     00590
     C     dtlkey        reade     CONDTLR                              2121
     C                   enddo
     c                   endif

     C     NXTXRF        TAG

     C                   read      CONHDRR                              2020

     C* End: For each Contract record
     C                   ENDDO

     C* Perform Termination Routines
     C                   if        isttim = *on                                                01010
     C                   eval      eor = *on                                                   01010
     C                   exsr      zprint                                                      00590
     C                   endif                                                                 00590

     C                   eval      *inlr = *on
     C                   return
     C**********************************************************************
     C* L o g i c a l   E n d   O f   P r o g r a m
     C**********************************************************************

     C     $UPDAT        BEGSR
     C**********************************************************************
     C* Subroutine: Write Profiled Orders File
     C**********************************************************************
     C                   MOVEL     LT(NR)        WHFNAM

     C                   WRITE     PROORDR

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C     zprint        begsr
     C**********************************************************************
     C*‚Subroutine: Print a Report Line
     C**********************************************************************
     C*‚If 1st time through then write out initial headings
     C                   if        isttim <> *on
     C                   write     rpthdr                               70
     C                   eval      isttim = *on
     C                   eval      lines = 4
     C                   eval      d#text = shd128
     C                   write     rptdtl                               70
     C                   eval      d#text = *blanks
     C                   write     rptdtl                               70
     C                   endif

     C*‚Write detail line if not end of report
     C                   if        eor <> *on
     C                   eval      %subst(d#text:1:10) = s#mbr
     C                   eval      %subst(d#text:12:10) = s#file
     C                   eval      %subst(d#text:23:10) = s#lib
     C                   write     rptdtl                               70
     C                   eval      lines = lines + 1
     C                   endif

     C*‚Write out headings on overflow
     C                   if        *in01
     C                   write     rpthdr                               70
     C                   eval      *in01 = *off
     C                   eval      lines = 4
     C                   eval      d#text = shd128
     C                   write     rptdtl                               70
     C                   eval      d#text = *blanks
     C                   write     rptdtl                               70
     C                   endif

     C*‚If end of report then write out eor message
     C                   if        eor = *on
     C                   eval      lines = lines + 1
     C                   write     rptend                               70
     C                   endif

     C                   endsr
     C**********************************************************************

     C**********************************************************************
     C     *INZSR        BEGSR
     C**********************************************************************
     C* Subroutine: Initialisation Routines
     C**********************************************************************

     C                   ENDSR
     C**********************************************************************

     C**********************************************************************
     C*‚N o n - E x e c u t a b l e   C o d e
     C**********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P#PROD           20

     C* Condtl
     C     dtlkey        klist
     C                   kfld                    xwordn
     C                   kfld                    x#prod
     C**********************************************************************
