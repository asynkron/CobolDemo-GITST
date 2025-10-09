# STKMAS.PF Member Guide

## Overview
DDS physical file `STKMAS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `STKMAS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R STKMASR
     A            XWABCD        20A         TEXT('Stk Product                 ')
     A                                      COLHDG('Product')
     A            XWHLTX        10A         TEXT('Stk Product Desc            ')
     A                                      COLHDG('Desc')
     A            XWG7TX        40A         TEXT('Stk Product Description     ')
     A                                      COLHDG('Description')
     A            XWAGCD         2A         TEXT('Stk Group 1                 ')
     A                                      COLHDG('Grp' -
     A                                      ' 1')
     A            XWAHCD         2A         TEXT('Stk Group 2                 ')
     A                                      COLHDG('Grp' -
     A                                      '2')
     A            XWAICD         2A         TEXT('Stk Group 3                 ')
     A                                      COLHDG('Grp' -
     A                                      ' 3')
     A            XWANPR        11P 2       TEXT('Retail Price')
     A                                      EDTCDE(M)
     A          K XWABCD
````
