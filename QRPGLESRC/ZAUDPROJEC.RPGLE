     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2010
     H*‚--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2010') datedit(*dmy)
     H option(*srcstmt:*nodebugio:*showcpy)
     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     Fproject   if   e           k disk
     Fprotrk    if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D protrkcount     s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D protrkk       e ds                  extname(protrk:*key)

     C**********************************************************************
     C*‚M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //‚For each orgs   record
       setll *loval projecr;
       read(e) projecr;
       dow not %eof(project);

       protrkcount = *zeros;

       //‚Count PROTRK records
           setll %kds(protrkk:1) protrkr;
           reade(e) %kds(protrkk:1) protrkr;
           dow not %eof(protrk) and not %error;
               protrkcount = protrkcount + 1;
           //  protrkcount = *zeros;
               reade(e) %kds(protrkk:1) protrkr;
           enddo;

       //‚Output totals for lists
          if *inof;
             except headings;
             *inof = *off;
           //  protrkcount = *zeros;
          endif;

          except totals;

       read(e) projecr;
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
     O                                           60 'Audit log for file:'
     O                                           68 'PROJECT'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDPROJEC'
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           75 'PROTRK'
     O          e            headings       2
     O                                           75 'Records'
     O          e            totals         2
     O                       xwjobn        z      8
     O                       xwabcd              30
     O                       protrkcount   1     75
