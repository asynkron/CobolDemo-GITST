     H DFTACTGRP(*NO)
     Fxpgfnm    if   e           k disk
     D DCPGM1          S             10A

     D Main            PR                  EXTPGM('XRPGM2')
     D  Document                     10A
     D Main            PI
     D  Document                     10A
     C
      /FREE
                         document ='110';
                         CHAIN(E) DOCUMENT xpgfnm;
                         If        %Found(xpgfnm);
                         DCPGM1= pgx2;
      /END-FREE
     C                   Call      DCPGM1
      /FREE
                         ENDIF;

                                   *Inlr=*On;
      /END-FREE
