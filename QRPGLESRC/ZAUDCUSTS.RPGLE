     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2010
     H*‚--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2010') datedit(*dmy)
     H option(*srcstmt:*nodebugio:*showcpy)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     Fcusts     if   e           k disk
     Fconhdrl4  if   e           k disk
     Ftrnhstl9  if   e           k disk
     Fprojecl3  if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D conhdrcount     s              7p 0
     D projeccount     s              7p 0
     D trnhstcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D conhdrk       e ds                  extname(conhdrl4:*key)  prefix(a)
     D projeck       e ds                  extname(projecl3:*key)  prefix(b)
     D trnhstk       e ds                  extname(trnhstl9:*key)  prefix(c)

     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //‚For each customer record
       setll *loval custsr;
       read(e) custsr;
       dow not %eof(custs);

       conhdrcount = *zeros;
       projeccount = *zeros;
       trnhstcount = *zeros;

       //‚Count CONHDR records
           axwbccd = xwbccd;
           setll %kds(conhdrk:1) conhdrr;
           reade(e) %kds(conhdrk:1) conhdrr;
           dow not %eof(conhdrl4) and not %eof;
               conhdrcount = conhdrcount + 1;
               //trnhstcount = *zeros;
               reade(e) %kds(conhdrk:1) conhdrr;
           enddo;

       //‚Count PROJECT records
           bxwbccd = xwbccd;
           setll %kds(projeck:1) projecr;
           reade(e) %kds(projeck:1) projecr;
           dow not %eof(projecl3) and not %eof;
               projeccount = projeccount + 1;
               //trnhstcount = *zeros;
               reade(e) %kds(projeck:1) projecr;
           enddo;

       //‚Count TRNHST records
           cxwbccd = xwbccd;
           setll %kds(trnhstk:1) trnhstr;
           reade(e) %kds(trnhstk:1) trnhstr;
           dow not %eof(trnhstl9) and not %eof;
               trnhstcount = trnhstcount + 1;
           //  projeccount = projeccount + 1;
               reade(e) %kds(trnhstk:1) trnhstr;
           enddo;

       //‚Output totals for salesman
          if *inof;
             except headings;
             *inof = *off;
           //  projeccount = projeccount + 1;
          endif;

          except totals;

       read(e) custsr;
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
     O                                           60 'Audit log for file: CUSTS'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDCUSTS '
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           75 'CONHDR'
     O                                           90 'PROJECT'
     O                                          105 'TRNHST'
     O          e            headings       2
     O                                           75 'Records'
     O                                           90 'Records'
     O                                          105 'Records'
     O          e            totals         2
     O                       xwbccd              15
     O                       xwg4tx              60
     O                       conhdrcount   1     75
     O                       projeccount   1     90
     O                       trnhstcount   1    105
