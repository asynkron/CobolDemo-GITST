# SECF.PF Member Guide

## Overview
DDS physical file `SECF` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `SECF` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R RSECF
     A            SCDEXD         6P 0       TEXT('Xa Code Expiry Date')
     A                                      COLHDG('Expires')
     A                                      EDTCDE(Y)
     A            SSRLNB         8          TEXT('Srl.no.')
     A            SCDE          20          TEXT('XA Code')
     A                                      COLHDG('Code')
     A            SXAMD1         1          TEXT('Xa Module 1')
     A                                      COLHDG('1')
     A            SXAMD2         1          TEXT('Xa Module 2')
     A                                      COLHDG('2')
     A            SXAMD3         1          TEXT('Xa Module 3')
     A                                      COLHDG('3')
     A            SXAMD4         1          TEXT('Xa Module 4')
     A                                      COLHDG('4')
     A            SXAMD5         1          TEXT('Xa Module 5')
     A                                      COLHDG('5')
     A            SXAMD6         1          TEXT('Xa Module 6')
     A                                      COLHDG('6')
     A            SXAMD7         1          TEXT('Xa Module 7')
     A                                      COLHDG('7')
     A            SXAMD8         1          TEXT('Xa Module 8')
     A                                      COLHDG('8')
     A            SXAMD9         1          TEXT('Xa Module 9')
     A                                      COLHDG('9')
     A            SXAMD0         1          TEXT('Xa Module 10')
     A                                      COLHDG('10')
     A            SCDCRD         6P 0       TEXT('Xa Code Issued Date')
     A                                      EDTCDE(Y)
     A                                      COLHDG('Issued')
     A            DCODE          2          TEXT('Agent Code')
     A            SMOD           3          TEXT('Model')
     A            SCMT1         50          TEXT('Comment Line 1')
     A            CUSNO          5P 0       TEXT('Cmp.No.')
     A            PCODE          2A         TEXT('Product Code')
     A          K CUSNO
     A          K PCODE
     A          K SCDEXD
     A          K SSRLNB
````
