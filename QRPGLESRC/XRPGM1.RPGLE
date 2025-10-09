     H DFTACTGRP(*NO)
     Fxpgfnm    if   e           k disk
     D ProcDoc         PR                  EXTPGM(pgx1)
     D Main            PR                  EXTPGM('XRPGM1')
     D  Document                     10A   Const
     D Main            PI
     D  Document                     10A   Const
     C
      /FREE
                         CHAIN(E) DOCUMENT xpgfnm;
                         If        %Found(xpgfnm);
                         CallP     ProcDoc();
                         endif;
                         eval      *Inlr=*On;
      /END-FREE
