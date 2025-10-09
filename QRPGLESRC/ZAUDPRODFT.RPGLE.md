# ZAUDPRODFT.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDPRODFT` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDPRODFT`.
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
     Fprodft    if   e           k disk
     Fprotrkl1  if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D protrkcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D protrkk       e ds                  extname(protrkl1:*key)

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each orgs   record
       setll *loval prodftr;
       read(e) prodftr;
       dow not %eof(prodft);

       protrkcount = *zeros;

       //Count PROTRK records
           setll %kds(protrkk:1) protrkr;
           reade(e) %kds(protrkk:1) protrkr;
           dow not %eof(protrkl1) and not %error;
               protrkcount = protrkcount + 1;
           //  protrkcount = *zeros;
               reade(e) %kds(protrkk:1) protrkr;
           enddo;

       //Output totals for lists
          if *inof;
             except headings;
             *inof = *off;
          endif;

          except totals;

       read(e) prodftr;
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
     C**                 add       *date         today
     C                   endsr
     Oqsysprt   e            headings       1 01
     O                                           10 'X-Analysis'
     O                                           60 'Audit log for file: PRODFT'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDPRODFT'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           75 'PROTRK'
     O          e            headings       2
     O                                           75 'Records'
     O          e            totals         2
     O                       xwtrpt              12
     O                       xwtrds              45
     O                       protrkcount   1     75
````
