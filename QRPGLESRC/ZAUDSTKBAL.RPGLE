     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2010
     H*‚--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2010') datedit(*dmy)
     H option(*srcstmt:*nodebugio:*showcpy)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     Fstkbal    if   e           k disk
     Fcondetl2  if   e           k disk
     Ftrnhstl2a if   e           k disk
     Fprojecl1b if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D condetcount     s              7p 0
     D projeccount     s              7p 0
     D trnhstcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0


     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //‚For each stock balance record
       setll *loval stkbalr;
       read(e) stkbalr;
       dow not %eof(stkbal);

       condetcount = *zeros;
       projeccount = *zeros;
       trnhstcount = *zeros;

       //‚Count CONDET records
           setll CONDETK condetr;
           reade(e) CONDETK condetr;
           dow not %eof(condetl2) and not %eof;
               condetcount = condetcount + 1;
               reade(e) CONDETK condetr;
           enddo;

       //‚Count PROJECT records
           setll PROJECTK projecr;
           reade(e) PROJECTK projecr;
           dow not %eof(projecl1b) and not %eof;
               projeccount = projeccount + 1;
               reade(e) PROJECTK projecr;
           enddo;

       //‚Count TRNHST records
           setll TRNHSTK trnhstr;
           reade(e) TRNHSTK trnhstr;
           dow not %eof(trnhstl2a) and not %eof;
               trnhstcount = trnhstcount + 1;
           //  trnhstcnt = trnhstcnt + 1;
               reade(e) TRNHSTK trnhstr;
           enddo;

       //‚Output totals for salesman
          if *inof;
             except headings;
             *inof = *off;
          endif;

          except totals;

       read(e) stkbalr;
       enddo;

       //‚Terminate program and exit
       *inlr = *on;
       return;
      /end-free
     C**********************************************************************
     C*‚* I N Z S R
     C**********************************************************************
     C     *inzsr        begsr
     C                   time                    tyme
     C                   z-add     *date         today
     C     CONDETK       klist
     C                   kfld                    xwabcd
     C                   kfld                    xwaacs
     C     PROJECTK      klist
     C                   kfld                    xwabcd
     C                   kfld                    xwaacs
     C     TRNHSTK       klist
     C                   kfld                    xwabcd
     C                   kfld                    xwaacs
     C**   TRNCUSK       klist
     C**                 kfld                    xwabcd
     C**                 kfld                    xwaacs
     C                   endsr
     Oqsysprt   e            headings       1 01
     O                                           10 'X-Analysis'
     O                                           60 'Audit log for file: STKBAL'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDSTKBAL'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           60 'CONDET'
     O                                           75 'PROJECT'
     O                                           90 'TRNHST'
     O          e            headings       2
     O                                           60 'Records'
     O                                           75 'Records'
     O                                           90 'Records'
     O          e            totals         2
     O                       xwabcd              25
     O                       xwaacs              40
     O                       condetcount   1     60
     O                       projeccount   1     75
     O                       trnhstcount   1     90
