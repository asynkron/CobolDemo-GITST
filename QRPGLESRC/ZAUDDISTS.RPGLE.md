# ZAUDDISTS.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDDISTS` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDDISTS`.
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
     Fdists     if   e           k disk
     Fcusfl6    if   e           k disk
     Fcustsl4   if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D cusfcount       s              7p 0
     D custscount      s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D cusfk         e ds                  extname(cusfl6:*key)  prefix(a)
     D custsk        e ds                  extname(custsl4:*key)  prefix(b)

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each distributor record
       setll *loval rprods;
       read(e) rprods;
       dow not %eof(dists);

       cusfcount = *zeros;
       custscount = *zeros;

       //Count CUSF   records
           adsdcde = dsdcde;
           setll %kds(cusfk:1) rcusf;
           reade(e) %kds(cusfk:1) rcusf;
           dow not %eof(cusfl6) and not %eof;
               cusfcount = cusfcount + 1;
           //  custscount = *zeros;
               reade(e) %kds(cusfk:1) rcusf;
           enddo;

       //Count PROJECT records
           bdsdcde = dsdcde;
           setll %kds(custsk:1) custsr;
           reade(e) %kds(custsk:1) custsr;
           dow not %eof(custsl4) and not %eof;
               custscount = custscount + 1;
           //  trnstcount = *zeros;
               reade(e) %kds(custsk:1) custsr;
           enddo;

       //Output totals for salesman
          if *inof;
             except headings;
             *inof = *off;
          endif;

          except totals;

       read(e) rprods;
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
     O                                           60 'Audit log for file: DISTS'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDDISTS '
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           75 'CUSF'
     O                                           90 'CUSTS'
     O          e            headings       2
     O                                           75 'Records'
     O                                           90 'Records'
     O          e            totals         2
     O                       dsdcde               3
     O                       dname               40
     O                       cusfcount     1     75
     O                       custscount    1     90
````
