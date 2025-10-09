# PROJECT.PF Member Guide

## Overview
DDS physical file `PROJECT` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `PROJECT` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R PROJECR
     A            XWJOBN         6S 0       TEXT('Project No')
     A            XWABCD        20A         TEXT('Product')
     A            XWJSTS         2A         TEXT('Status')
     A                                      VALUES('P' 'I' 'C')
     A            XWPLQT        13P 4       TEXT('Planned Qty')
     A                                      EDTCDE(M)
     A            XWACQT        13P 4       TEXT('Actual Qty')
     A                                      EDTCDE(M)
     A            XWSTDT          L         TEXT('Issue Date')
     A            XWFNDT          L         TEXT('Delivery Date')
     A            XWBCCD        11A         TEXT('Debtor')
     A            XWORDN         6S 0       TEXT('Contract No')
     A            XWAACS        11A         TEXT('Store')
     A            XWAGCD         2A         TEXT('Stk Group 1')
     A
     A          K XWJOBN
````
