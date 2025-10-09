# ZAUDDELIVA.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDDELIVA` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDDELIVA`.
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
     Fdeliva    if   e           k disk
     Ftrnhstl8  if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D trnhstcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D trnhstk       e ds                  extname(trnhstl8:*key)

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each DELIVA record
       setll *loval delivar;
       read(e) delivar;
       dow not %eof(deliva);

       trnhstcount = *zeros;

       //Count TRNHST records
           setll %kds(trnhstk:1) trnhstr;
           reade(e) %kds(trnhstk:1) trnhstr;
           dow not %eof(trnhstl8) and not %eof;
               trnhstcount = trnhstcount + 1;
           //  custstcount = custstcount + 1;
               reade(e) %kds(trnhstk:1) trnhstr;
           enddo;

       //Output totals for delivery area record
          if *inof;
             except headings;
             *inof = *off;
           //  custstcount = custstcount + 1;
          endif;

          except totals;

       read(e) delivar;
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
     O                                           67 'DELIVA'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDDELIVA'
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
     O                       xwbdcd               4
     O                       xwgxtx              45
     O                       trnhstcount   1     60
````
