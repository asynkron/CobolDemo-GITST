# CUSTSR01.PRTF Member Guide

## Overview
DDS printer file `CUSTSR01` describes printer output formats used by reporting routines.

## Dependency Map
- **Incoming:** Programs that open the `CUSTSR01` PRTF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      REF(*LIBL/TRNHST)
     A
     A          R HDG1
     A                                      SKIPB(001)
     A                                     1
     A                                      '-------------------------'
     A                                    26
     A                                      '-------------------------'
     A                                    51
     A                                      '-------------------------'
     A                                    76
     A                                      '----'
     A                                    +0
     A                                      '------------------------'
     A            @PGMNAME1     10A        1
     A                                      SPACEB(001)
     A                                    27
     A                                      'CUSTOMER ORDER HISTORY'
     A
     A                                    71
     A                                      'RUN DATE:'
     A                                    80
     A                                      DATE
     A                                      EDTCDE(Y)
     A                                    91
     A                                      'PAGE NO :'
     A            @PGNBR1        4S 0    100
     A                                      EDTCDE(Z)
     A            @UNAME1       10A        1
     A                                      SPACEB(001)
     A                                    71
     A                                      'RUN TIME:'
     A                                    80
     A                                      TIME
     A          R CUSTHDR1
     A                                      SPACEB(001)
     A                                     1
     A                                      '-----------------------------------
     A                                      ------------------------------------
     A                                      ----------------------------------'
     A                                      SPACEB(001)
     A                                      SPACEA(001)
     A                                     1
     A                                      'CUSTOMER:'
     A            C_XWBCCD  R        O    +6
     A                                      REFFLD(CUSTSR/XWBCCD *LIBL/CUSTS)
     A                                     1
     A                                      'CUSTOMER NAME:'
     A                                      SPACEB(001)
     A            C_XWG4TX  R        O    +1
     A                                      REFFLD(CUSTSR/XWG4TX *LIBL/CUSTS)
     A                                     1
     A                                      '-----------------------------------
     A                                      ------------------------------------
     A                                      ----------'
     A                                      SPACEB(002)
     A                                    +0
     A                                      '------------------------'
     A                                     1
     A                                      'Period'
     A                                      SPACEB(001)
     A                                    +2
     A                                      'TrnDate'
     A                                    21
     A                                      'TrnsHSeq'
     A                                    +5
     A                                      'Grp'
     A                                    +1
     A                                      'Product'
     A                                   +15
     A                                      'Doc Reference'
     A                                    +4
     A                                      'Quantity'
     A                                    +5
     A                                      'Value'
     A                                     1
     A                                      '------'
     A                                      SPACEB(001)
     A                                    +2
     A                                      '----------'
     A                                    +2
     A                                      '-----------'
     A                                    +2
     A                                      '--'
     A                                    +2
     A                                      '--------------------'
     A                                    +2
     A                                      '---------------'
     A                                    +2
     A                                      '----------'
     A                                    +3
     A                                      '--------------'
     A          R DTL1
     A                                      SPACEA(001)
     A            XWE4NB    R        O     1
     A                                      SPACEB(001)
     A                                      REFFLD(TRNHSTR/XWE4NB *LIBL/TRNHST)
     A            XWDLDT    R        O    +2
     A                                      REFFLD(TRNHSTR/XWDLDT *LIBL/TRNHST)
     A            XWC8DT    R        O    +2
     A                                      REFFLD(TRNHSTR/XWC8DT *LIBL/TRNHST)
     A            XWBNCD    R        O    +2
     A                                      REFFLD(TRNHSTR/XWBNCD *LIBL/TRNHST)
     A            XWABCD    R        O    +2
     A                                      REFFLD(TRNHSTR/XWABCD *LIBL/TRNHST)
     A            XWT8TX    R        O    +2
     A                                      REFFLD(TRNHSTR/XWT8TX *LIBL/TRNHST)
     A            XWA5QT    R        O    +2
     A                                      REFFLD(TRNHSTR/XWA5QT *LIBL/TRNHST)
     A            XWVALU    R        O    +2
     A                                      REFFLD(TRNHSTR/XWVALU *LIBL/TRNHST)
     A          R TOTLINE1
     A                                      SPACEB(001)
     A                                    76
     A                                      '-----------'
     A                                    +2
     A                                      '---------------'
     A*
     A          R TOTL1
     A                                      SPACEB(001)
     A                                    60
     A                                      'Total'
     A            TXWA5QT       10S 2O   +11
     A                                      EDTCDE(M)
     A            TXWVALU       14S 2O    +1
     A                                      EDTCDE(M)
     A
     A          R NOREC1
     A                                      SPACEB(001)
     A
     A          R EOFP1
     A                                      SPACEB(001)
     A                                     1
     A                                      '------------------------'
     A                                    25
     A                                      '      END OF REPORT     '
     A                                    50
     A                                      '------------------------'
     A                                    +0
     A                                      '------------------------------'
     A**************************************************************************
````
