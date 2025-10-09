# ZAUDSTKMAS.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDSTKMAS` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDSTKMAS`.
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
     Fstkmas    if   e           k disk
     Fstkbal    if   e           k disk
     Fcondetl3  if   e           k disk
     Ftrnhstl2a if   e           k disk
     Fprojecl1b if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D stkbalcount     s              7p 0
     D condetcount     s              7p 0
     D projeccount     s              7p 0
     D trnhstcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0


     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each stock master record
       setll *loval stkmasr;
       read(e) stkmasr;
       dow not %eof(stkmas);

       stkbalcount = *zeros;
       condetcount = *zeros;
       projeccount = *zeros;
       trnhstcount = *zeros;

       //Count CONDET records
           setll CONDETK condetr;
       //  setll %kds(k@condet:1) condetr;
           reade(e) CONDETK condetr;
           dow not %eof(condetl3) and not %error;
               condetcount = condetcount + 1;
               reade(e) CONDETK condetr;
           enddo;

       //Count PROJECT records
           setll PROJECK projecr;
           reade(e) PROJECK projecr;
           dow not %eof(projecl1b) and not %error;
               projeccount = projeccount + 1;
               reade(e) PROJECK projecr;
           enddo;

       //Count TRNHST records
           setll TRNHSTK trnhstr;
           reade(e) TRNHSTK trnhstr;
           dow not %eof(trnhstl2a) and not %error;
               trnhstcount = trnhstcount + 1;
           //  trnhstcount += 1;
               reade(e) TRNHSTK trnhstr;
           enddo;

       //Count STKBAL records
           setll STKBALK stkbalr;
           reade(e) STKBALK stkbalr;
           dow not %eof(stkbal) and not %error;
               stkbalcount = stkbalcount + 1;
               reade(e) STKBALK stkbalr;
           enddo;

       //Output totals for stock master
          if *inof;
             except headings;
             *inof = *off;
          endif;

          except totals;

       read(e) stkmasr;
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
     C     PROJECK       klist
     C                   kfld                    XWABCD
     C                   kfld                    XWAACS
     C     CONDETK       klist
     C                   kfld                    XWABCD
     C     TRNHSTK       klist
     C                   kfld                    XWABCD
     C                   kfld                    XWAACS
     C     STKBALK       klist
     C                   kfld                    XWABCD
     C                   endsr
     Oqsysprt   e            headings       1 01
     O                                           10 'X-Analysis'
     O                                           60 'Audit log for file: STKBAL'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDSTKMAS'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           60 'CONDET'
     O                                           75 'PROJECT'
     O                                           90 'TRNHST'
     O                                          105 'STKBAL'
     O          e            headings       2
     O                                           60 'Records'
     O                                           75 'Records'
     O                                           90 'Records'
     O                                          105 'Records'
     O          e            totals         2
     O                       xwabcd              25
     O                       xwhltx              40
     O                       condetcount   1     60
     O                       projeccount   1     75
     O                       trnhstcount   1     90
     O                       stkbalcount   1    105
````
