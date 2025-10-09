# ZAUDSTKGP3.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDSTKGP3` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDSTKGP3`.
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
     Fstkgrp3   if   e           k disk
     Ftrnhstl4  if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D trnhstcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;

       //For each STKGRP3 record
       setll *loval stkgrp3r;
       read(e) stkgrp3r;
       dow not %eof(stkgrp3);

       trnhstcount = *zeros;
       //trnhstcnt = *zeros;

       //Count TRNHST records
           setll TRNHSTK trnhstr;
           reade(e) TRNHSTK trnhstr;
           dow not %eof(trnhstl4) and not %error;
               trnhstcount = trnhstcount + 1;
               reade(e) TRNHSTK  trnhstr;
           enddo;

       //Output totals for stock group 3  record
          if *inof;
             except headings;
             *inof = *off;
          // *inoa = *off;
          endif;

          except totals;

       read(e) stkgrp3r;
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
     C     TRNHSTK       klist
     C                   kfld                    xwagcd
     C                   kfld                    xwahcd
     C                   kfld                    xwaicd
     C                   endsr
     Oqsysprt   e            headings       1 01
     O                                           10 'X-Analysis'
     O                                           60 'Audit log for file:'
     O                                           68 'STKGRP3'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDSTKGP3'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           60 'TRNHST'
     O          e            headings       2
     O                                           60 'Records'
     O          e            totals         2
     O                       xwagcd               4
     O                       xwahcd               8
     O                       xwaicd              12
     O                       xwiwtx              30
     O                       trnhstcount   1     60
````
