# ZAUDCUSGRP.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDCUSGRP` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDCUSGRP`.
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
     Fcusgrp    if   e           k disk
     Fcustsl1   if   e           k disk
     Ftrnhstl1  if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D custscount      s              7p 0
     D trnhstcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D custsk        e ds                  extname(custsl1:*key)  prefix(a)
     D trnhstk       e ds                  extname(trnhstl1:*key)  prefix(b)

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each CUSGRP record
       setll *loval cusgrpr;
       read(e) cusgrpr;
       dow not %eof(cusgrp);

       custscount = *zeros;
       trnhstcount = *zeros;

       //Count CUSTS records
           axwbncd = xwbncd;
           setll %kds(custsk:1) custsr;
           reade(e) %kds(custsk:1) custsr;
           dow not %eof(custsl1) and not %error;
               custscount = custscount + 1;
           //  trnhstcount = *zeros;
               reade(e) %kds(custsk:1) custsr;
           enddo;

       //Count TRNHST records
           bxwbncd = xwbncd;
           setll %kds(trnhstk:1) trnhstr;
           reade(e) %kds(trnhstk:1) trnhstr;
           dow not %eof(trnhstl1) and not %error;
               trnhstcount = trnhstcount + 1;
           //  custstcount = *zeros;
               reade(e) %kds(trnhstk:1) trnhstr;
           enddo;

       //Output totals for customer group record
          if *inof;
             except headings;
             *inof = *off;
          endif;

          except totals;

       read(e) cusgrpr;
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
     O                                           67 'CUSGRP'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDCUSGRP'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           60 'CUSTS'
     O                                           75 'TRNHST'
     O          e            headings       2
     O                                           60 'Records'
     O                                           75 'Records'
     O          e            totals         2
     O                       xwbncd               4
     O                       xwkhtx              45
     O                       custscount    1     60
     O                       trnhstcount   1     75
````
