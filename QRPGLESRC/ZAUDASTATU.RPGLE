     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2010
     H*‚--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2010') datedit(*dmy)
     H option(*srcstmt:*nodebugio:*showcpy)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     Fastatus   if   e           k disk
     Fcusfl2    if   e           k disk
     Fcntlf3    if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D cusfcount       s              7p 0
     D cntaccount      s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D cusfk         e ds                  extname(cusfl2:*key)  prefix(b)
     D cntlfk        e ds                  extname(cntlf3:*key)  prefix(c)

     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //‚For each status record
       setll *loval statusr;
       read(e) statusr;
       dow not %eof(astatus);

       cusfcount = *zeros;
       cntaccount = *zeros;

       //‚Count CUSF   records
           bstatus = status;
           setll %kds(cusfk:1) rcusf;
           reade(e) %kds(cusfk:1) rcusf;
           dow not %eof(cusfl2) and not %eof;
               cusfcount = cusfcount + 1;
           //  cusfcount = *zeros;
               reade(e) %kds(cusfk:1) rcusf;
           enddo;

       //‚Count CNTACS records
           cstatus = status;
           setll %kds(cntlfk:1) rcntac;
           reade(e) %kds(cntlfk:1) rcntac;
           dow not %eof(cntlf3) and not %eof;
               cntaccount = cntaccount + 1;
           //  cusfcount = *zeros;
               reade(e) %kds(cntlfk:1) rcntac;
           enddo;

       //‚Output totals for salesman
          if *inof;
             except headings;
             *inof = *off;
           //  cusfcount = *zeros;
          endif;

          except totals;

       read(e) statusr;
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
     O                                           60 'Audit log for file: ASTATU'
     O                                           61 'S'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDASTATU'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           75 'CUSF'
     O                                           90 'CNTACS'
     O          e            headings       2
     O                                           75 'Records'
     O                                           90 'Records'
     O          e            totals         2
     O                       status               3
     O                       ststxt              40
     O                       cusfcount     1     75
     O                       cntaccount    1     90
