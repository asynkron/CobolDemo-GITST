# ZAUDLISTS.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDLISTS` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDLISTS`.
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
     Flists     if   e           k disk
     Fcusflb    if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D cusfcount       s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D cusfk         e ds                  extname(cusflb:*key)

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each lists  record
       setll *loval rlists;
       read(e) rlists;
       dow not %eof(lists);

       cusfcount = *zeros;

       //Count CUSF   records
           setll %kds(cusfk:1) rcusf;
           reade(e) %kds(cusfk:1) rcusf;
           dow not %eof(cusflb) and not %eof;
               cusfcount = cusfcount + 1;
           //  trnstount = *zeros;
               reade(e) %kds(cusfk:1) rcusf;
           enddo;

       //Output totals for lists
          if *inof;
             except headings;
             *inof = *off;
          endif;
       // if *inoa;
       //    except footers;
       //    *inoa = *off;
       // endif;

          except totals;

       read(e) rlists;
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
     O                                           60 'Audit log for file: LISTS '
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDLISTS'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           75 'CUSF'
     O          e            headings       2
     O                                           75 'Records'
     O          e            totals         2
     O                       lslcde               3
     O                       lname               40
     O                       cusfcount     1     75
````
