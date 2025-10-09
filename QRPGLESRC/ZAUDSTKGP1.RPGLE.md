# ZAUDSTKGP1.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDSTKGP1` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDSTKGP1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2010
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2010') datedit(*dmy)
     H option(*srcstmt:*nodebugio:*showcpy)
     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     Fstkgrp1   if   e           k disk
     Fstkgrp2   if   e           k disk
     Fstkgrp3   if   e           k disk
     Ftrnhstl4  if   e           k disk
     Fprojecl2  if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D grp2count       s              7p 0
     D grp3count       s              7p 0
     D trnhstcount     s              7p 0
     D projeccount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D stkgrp2k      e ds                  extname(stkgrp2:*key) prefix(a)
     D stkgrp3k      e ds                  extname(stkgrp3:*key) prefix(b)
     D trnhstk       e ds                  extname(trnhstl4:*key) prefix(c)
     D projeck       e ds                  extname(projecl2:*key) prefix(d)

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each STKGRP1 record
       setll *loval stkgrp1r;
       read(e) stkgrp1r;
       dow not %eof(stkgrp1);

       trnhstcount = *zeros;
       projeccount = *zeros;
       grp2count = *zeros;
       grp3count = *zeros;
       //grp4count = *zeros;

       //Count TRNHST records
           cxwagcd = xwagcd;
           setll %kds(trnhstk:1) trnhstr;
           reade(e) %kds(trnhstk:1) trnhstr;
           dow not %eof(trnhstl4) and not %error;
               trnhstcount = trnhstcount + 1;
               reade(e) %kds(trnhstk:1) trnhstr;
           enddo;

       //Count PROJECT records
           dxwagcd = xwagcd;
       //  wagcd = xwagcd;
           setll %kds(projeck:1) projecr;
           reade(e) %kds(projeck:1) projecr;
           dow not %eof(projecl2) and not %error;
               projeccount = projeccount + 1;
               reade(e) %kds(projeck:1) projecr;
           enddo;

       //Count STKGRP2 records
           axwagcd = xwagcd;
           setll %kds(stkgrp2k:1) stkgrp2r;
           reade(e) %kds(stkgrp2k:1) stkgrp2r;
           dow not %eof(stkgrp2) and not %error;
               grp2count = grp2count + 1;
               reade(e) %kds(stkgrp2k:1) stkgrp2r;
           enddo;

       //Count STKGRP3 records
           bxwagcd = xwagcd;
           setll %kds(stkgrp3k:1) stkgrp2r;
           reade(e) %kds(stkgrp3k:1) stkgrp3r;
           dow not %eof(stkgrp3) and not %error;
               grp3count = grp3count + 1;
               reade(e) %kds(stkgrp3k:1) stkgrp3r;
           enddo;

       //Output totals for stock group 1  record
          if *inof;
             except headings;
             *inof = *off;
          endif;

          except totals;

       read(e) stkgrp1r;
       enddo;


       //Terminate program and exit
       *inlr = *on;
       return;
      /end-free
     C**********************************************************************
     C** I N Z S R
     C**********************************************************************
     C     *inzsr        begsr
     C                   time                    tyme
     C                   z-add     *date         today
     C                   endsr
     Oqsysprt   e            headings       1 01
     O                                           10 'X-Analysis'
     O                                           60 'Audit log for file:'
     O                                           68 'STKGRP1'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDSTKGP1'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           60 'TRNHST'
     O                                           75 'PROJECT'
     O                                           90 'STKGRP2'
     O                                          105 'STKGRP3'
     O          e            headings       2
     O                                           60 'Records'
     O                                           75 'Records'
     O                                           90 'Records'
     O                                          105 'Records'
     O          e            totals         2
     O                       xwagcd               4
     O                       xwiwtx              30
     O                       trnhstcount   1     60
     O                       projeccount   1     75
     O                       grp2count     1     90
     O                       grp3count     1    105
````
