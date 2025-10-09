# ZAUDCON.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDCON` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDCON`.
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
     Fconhdr    if   e           k disk
     Fcondet    if   e           k disk
     Fprojecl5a if   e           k disk
     Ftrnhstl6  if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D projeccount     s              7p 0
     D trnhstcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0


     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each conhdr record
       setll *loval conhdrr;
       read(e) conhdrr;
       dow not %eof(conhdr);
       projeccount = *zeros;
       trnhstcount = *zeros;

       //Count PROJECT records for XWORDN only
           setll conhdrk projecr;
           reade(e) conhdrk projecr;
           dow not %eof(projecl5a) and not %eof;
               projeccount = projeccount + 1;
           //  trnhstcount = *zeros;
               reade(e) conhdrk projecr;
           enddo;

       //Count TRNHST records
           setll conhdrk trnhstr;
           reade(e) conhdrk trnhstr;
           dow not %eof(trnhstl6) and not %eof;
               trnhstcount = trnhstcount + 1;
           //  trnhstcount = *zeros;
               reade(e) conhdrk trnhstr;
           enddo;

       //Output totals for Contract
          if *inof;
             except headings;
             *inof = *off;
           //  trnhstcount = *zeros;
          endif;

          except contract;


       //Read associated condet records
       setll conhdrk condetr;
       reade(e) conhdrk condetr;
       dow not %eof(condet);
       projeccount = *zeros;
       trnhstcount = *zeros;

       //Count PROJECT records
           setll condetk projecr;
           reade(e) condetk projecr;
           dow not %eof(projecl5a) and not %eof;
               projeccount = projeccount + 1;
           //  trnhstcount = *zeros;
               reade(e) condetk projecr;
           enddo;

       //Count TRNHST records
           setll condetk trnhstr;
           reade(e) condetk trnhstr;
           dow not %eof(trnhstl6) and not %eof;
               trnhstcount = trnhstcount + 1;
           //  trnhstcount = *zeros;
               reade(e) condetk trnhstr;
           enddo;

       //Output totals for Contract / Product
          if *inof;
             except headings;
             *inof = *off;
          endif;

          except totals;

       reade(e) conhdrk condetr;
       enddo;

       read(e) conhdrr;
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
     C     conhdrk       klist
     C                   kfld                    xwordn
     C     condetk       klist
     C                   kfld                    xwordn
     C                   kfld                    xwabcd
     C                   endsr
     Oqsysprt   e            headings       1 01
     O                                           10 'X-Analysis'
     O                                           60 'Audit log for file: CONHDR'
     O                                           69 '/ CONDET'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDCON   '
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           75 'PROJECT'
     O                                           90 'TRNHST'
     O          e            headings       2
     O                                           75 'Records'
     O                                           90 'Records'
     O          e            contract       2
     O                       xwordn        z      7
     O                       projeccount   1     75
     O                       trnhstcount   1     90
     O          e            totals         2
     O                       xwordn        z      7
     O                       xwabcd              30
     O                       projeccount   1     75
     O                       trnhstcount   1     90
````
