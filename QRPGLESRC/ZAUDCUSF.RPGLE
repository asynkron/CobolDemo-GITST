     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2010
     H*‚--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2010') datedit(*dmy)
     H option(*srcstmt:*nodebugio:*showcpy)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     Fcusf      if   e             disk
     Fcustsl3   if   e           k disk
     Fcntacs    if   e           k disk
     Fsecf      if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D custscount      s              7p 0
     D cntaccount      s              7p 0
     D secfcount       s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D custsk        e ds                  extname(custsl3:*key)  prefix(a)
     D cntacsk       e ds                  extname(cntacs:*key)  prefix(b)
     D secfk         e ds                  extname(secf:*key)  prefix(c)

     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //‚For each CUSF record
       setll 1 rcusf;
       read(e) rcusf;
       dow not %eof(cusf);

       custscount = *zeros;
       cntaccount = *zeros;
       secfcount  = *zeros;

       //‚Count CUSTS records
           acusno  = cusno;
           setll %kds(custsk:1) custsr;
           reade(e) %kds(custsk:1) custsr;
           dow not %eof(custsl3) and not %eof;
               custscount = custscount + 1;
               reade(e) %kds(custsk:1) custsr;
           enddo;

       //‚Count CNTACS records
           bcusno  = cusno;
           setll %kds(cntacsk:1) rcntac;
           reade(e) %kds(cntacsk:1) rcntac;
           dow not %eof(cntacs) and not %eof;
               cntaccount = cntaccount + 1;
           //  secfcount  = *zeros;
               reade(e) %kds(cntacsk:1) rcntac;
           enddo;

       //‚Count SECF records
           ccusno  = cusno;
           setll %kds(secfk:1) rsecf;
           reade(e) %kds(secfk:1) rsecf;
           dow not %eof(secf) and not %eof;
               secfcount = secfcount  + 1;
               reade(e) %kds(secfk:1) rsecf;
           enddo;

       //‚Output totals for site
          if *inof;
             except headings;
             *inof = *off;
           //  secfcount  = *zeros;
          endif;

          except totals;

       read(e) rcusf;
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
     O                                           60 'Audit log for file: CUSF'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDCUSF'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           60 'CUSTS'
     O                                           75 'CNTACS'
     O                                           90 'SECF'
     O          e            headings       2
     O                                           60 'Records'
     O                                           75 'Records'
     O                                           90 'Records'
     O          e            totals         2
     O                       cusno         z      6
     O                       cname               45
     O                       custscount    1     60
     O                       cntaccount    1     75
     O                       secfcount     1     90
