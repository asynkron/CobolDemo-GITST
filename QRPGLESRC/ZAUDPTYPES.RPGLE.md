# ZAUDPTYPES.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDPTYPES` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDPTYPES`.
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
     Fptypes    if   e           k disk
     Fcusfla    if   e           k disk
     Fcntlf4    if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D cusfcount       s              7p 0
     D cntaccount      s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D cusfk         e ds                  extname(cusfla:*key) prefix(a)
     D cntlfk        e ds                  extname(cntlf4:*key) prefix(b)

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each PTYPES record
       setll *loval rprods;
       read(e) rprods;
       dow not %eof(ptypes);

       cusfcount = *zeros;
       cntaccount = *zeros;

       //Count CUSF   records
           aprpcde = prpcde;
           setll %kds(cusfk:1) rcusf;
           reade(e) %kds(cusfk:1) rcusf;
           dow not %eof(cusfla) and not %eof;
               cusfcount = cusfcount + 1;
           //  cntaccount = *zeros;
               reade(e) %kds(cusfk:1) rcusf;
           enddo;

       //Count CNTACS records
           bprpcde = prpcde;
           setll %kds(cntlfk:1) rcntac;
           reade(e) %kds(cntlfk:1) rcntac;
           dow not %eof(cntlf4) and not %eof;
               cntaccount = cntaccount + 1;
               reade(e) %kds(cntlfk:1) rcntac;
           enddo;

       //Output totals for product type
          if *inof;
             except headings;
             *inof = *off;
           //  cntaccount = *zeros;
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
     O                                           60 'Audit log for file: PTYPES'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDPTYPES'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           75 'CUSF'
     O                                           90 'CNTAC'
     O          e            headings       2
     O                                           75 'Records'
     O                                           90 'Records'
     O          e            totals         2
     O                       prpcde               4
     O                       pdesf               40
     O                       cusfcount     1     75
     O                       cntaccount    1     90
````
