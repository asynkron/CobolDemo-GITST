     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2010
     H*‚--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2010') datedit(*dmy)
     H option(*srcstmt:*nodebugio:*showcpy)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     Fstomas    if   e           k disk
     Fcondetl1  if   e           k disk
     Ftrnhstl7  if   e           k disk
     Fprojecl4a if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D condetcount     s              7p 0
     D projeccount     s              7p 0
     D trnhstcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D condetk       e ds                  extname(condetl1:*key)  prefix(a)
     D projeck       e ds                  extname(projecl4a:*key)  prefix(b)
     D trnhstk       e ds                  extname(trnhstl7:*key)  prefix(c)

     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //‚For each store master record
       setll *loval stomasr;
       read(e) stomasr;
       dow not %eof(stomas);

       condetcount = *zeros;
       projeccount = *zeros;
       trnhstcount = *zeros;
       //trnhstcnt = *zeros;

       //‚Count CONDET records
           axwaacs = xwaacs;
           setll %kds(condetk:1) condetr;
           reade(e) %kds(condetk:1) condetr;
           dow not %eof(condetl1) and not %eof;
               condetcount = condetcount + 1;
               reade(e) %kds(condetk:1) condetr;
           enddo;

       //‚Count PROJECT records
           bxwaacs = xwaacs;
           setll %kds(projeck:1) projecr;
           reade(e) %kds(projeck:1) projecr;
           dow not %eof(projecl4a) and not %eof;
               projeccount = projeccount + 1;
               reade(e) %kds(projeck:1) projecr;
           enddo;

       //‚Count TRNHST records
           cxwaacs = xwaacs;
           setll %kds(trnhstk:1) trnhstr;
           reade(e) %kds(trnhstk:1) trnhstr;
           dow not %eof(trnhstl7) and not %eof;
               trnhstcount = trnhstcount + 1;
               reade(e) %kds(trnhstk:1) trnhstr;
           enddo;

       //‚Output totals for store master
          if *inof;
             except headings;
             *inof = *off;
          endif;

          except totals;
          //leave;

       read(e) stomasr;
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
     C                   endsr
     Oqsysprt   e            headings       1 01
     O                                           10 'X-Analysis'
     O                                           60 'Audit log for file: STOMAS'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDSTOMAS'
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
     O                       xwaacs              15
     O                       xwdesc              40
     O                       condetcount   1     60
     O                       projeccount   1     75
     O                       trnhstcount   1     90
