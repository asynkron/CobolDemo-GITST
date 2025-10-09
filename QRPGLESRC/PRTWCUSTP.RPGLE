     Fprtwcustpdcf   e             Workstn
     Fcusts     if   e           k disk
     D
     D
     D
     D
     C                   dow       *in03 <> *on
     C
     C                   exfmt     Prtcust
     C     udcuid        chain     custs
     C                   if        %found(custs)
     C                   call      'WCUSTP'
     C                   parm                    udcuid
     C                   eval      *in45 = *off
     C                   eval      *in46 = *on
     C                   else
     C                   if        udcuid = 'PRT1'
     C                   call      'CUSTRPT01'
     C                   elseif    udcuid = 'PRT2'
     C                   call      'CUSTRPT02'
     C                   endif
     C
     C                   eval      *in45 = *on
     C                   eval      *in46 = *off
     C                   endif
     C
     C                   enddo

     c                   Eval      *inlr = *on
