# ZAUDSLMEN.RPGLE Member Guide

## Overview
ILE RPG program `ZAUDSLMEN` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ZAUDSLMEN`.
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
     Fslmen     if   e           k disk
     Fconhdrl2  if   e           k disk
     Fcustsl2   if   e           k disk
     Fdelival1  if   e           k disk
     Ftrnhstl5c if   e           k disk
     Fcntlf1    if   e           k disk
     Fqsysprt   o    f  132        printer oflind(*INOF)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D conhdrcount     s              7p 0
     D custscount      s              7p 0
     D delivacount     s              7p 0
     D trnhstcount     s              7p 0
     D cntlfcount      s              7p 0
     D tyme            s              6s 0
     D today           s              8s 0

     D conhdrk       e ds                  extname(conhdrl2:*key)  prefix(a)
     D custsk        e ds                  extname(custsl2:*key)   prefix(b)
     D delivk        e ds                  extname(delival1:*key)  prefix(c)
     D trnhstk       e ds                  extname(trnhstl5c:*key) prefix(d)
     D cntlfk        e ds                  extname(cntlf1:*key) prefix(e)

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
      /free
        *inof = *on;
       //For each salesman record
       setll *loval rslmen;
       read(e) rslmen;
       dow not %eof(slmen);

       conhdrcount = *zeros;
       //conhdrcnt = *zeros;
       custscount = *zeros;
       delivacount = *zeros;
       trnhstcount = *zeros;
       cntlfcount  = *zeros;

       //Count CONHDR records
           aperson = person;
           setll %kds(conhdrk:1) conhdrr;
           reade(e) %kds(conhdrk:1) conhdrr;
           dow not %eof(conhdrl2) and not %eof;
               conhdrcount = conhdrcount + 1;
               //trnhstcount = *zeros;
               reade(e) %kds(conhdrk:1) conhdrr;
           enddo;


       //Count CUSTS records
           bperson = person;
           setll %kds(custsk:1) custsr;
           reade(e) %kds(conhdrk:1) custsr;
           dow not %eof(custsl2) and not %eof;
               custscount = custscount + 1;
               //trnhstcount = *zeros;
               reade(e) %kds(custsk:1) custsr;
           enddo;

       //Count DELIVA records
           cperson = person;
           setll %kds(delivk:1) delivar;
           reade(e) %kds(delivk:1) delivar;
           dow not %eof(delival1) and not %eof;
               delivacount = delivacount + 1;
               //trnhstcount = *zeros;
               reade(e) %kds(delivk:1) delivar;
           enddo;

       //Count TRNHST records
           dperson = person;
           setll %kds(trnhstk:1) trnhstr;
           reade(e) %kds(trnhstk:1) trnhstr;
           dow not %eof(trnhstl5c) and not %eof;
               trnhstcount = trnhstcount + 1;
               reade(e) %kds(trnhstk:1) trnhstr;
           enddo;

       //Count CNTACS records
           esinit = person;
           setll %kds(cntlfk:1) rcntac;
           reade(e) %kds(cntlfk:1) rcntac;
           dow not %eof(cntlf1) and not %eof;
               cntlfcount = cntlfcount + 1;
               reade(e) %kds(cntlfk:1) rcntac;
           enddo;

       //Output totals for salesman
          if *inof;
             except headings;
             *inof = *off;
          endif;

          except totals;

       read(e) rslmen;
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
     O                                           60 'Audit log for file: SLMEN'
     O                                          132 'Databorough LTD.'
     O          e            headings       1
     O                                           10 'ZAUDSLMEN '
     O                       tyme               120 '  :  :  '
     O                       today              132 '  /  /    '
     O          e            headings       2
     O                                          127 'Page:'
     O                       page          z    132
     O          e            headings       1
     O                                           60 'CONHDR'
     O                                           75 'CUSTS'
     O                                           90 'DELIVA'
     O                                          105 'TRNHST'
     O                                          130 'CNTACS'
     O          e            headings       2
     O                                           60 'Records'
     O                                           75 'Records'
     O                                           90 'Records'
     O                                          105 'Records'
     O                                          130 'Records'
     O          e            totals         2
     O                       person               4
     O                       pname               40
     O                       conhdrcount   1     60
     O                       custscount    1     75
     O                       delivacount   1     90
     O                       trnhstcount   1    105
     O                       cntlfcount    1    130
````
