# CNTACS.PF Member Guide

## Overview
DDS physical file `CNTACS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `CNTACS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
      * SIMON       24/02/06  A0000001    Default Audit, delete if not required
      * Active Contacts File:
     A          R RCNTAC
     A            CUSNO          5P 0       TEXT('Cus. No.')
     A                                      COLHDG('Cus.' 'No.')
     A            USERNM        34A         TEXT('Contact')
     A            PRPCDE         2A         TEXT('Product Code')
     A                                      COLHDG('Prod' 'Code')
     A            TELNO         17A         TEXT('Phone')
     A            FAXNO         15A         TEXT('Fax.No.')
     A            EMAIL         40A         TEXT('Email')
     A            LCTDAT         6S 0       TEXT('Last Date')
     A                                      COLHDG('Last Cnt' 'Date')
     A                                      EDTCDE(Y)
     A            APDATE         6S 0       TEXT('Next Date')
     A                                      COLHDG('Next Cnt' 'Date')
     A                                      EDTCDE(Y)
     A            SINIT          3A         TEXT('Salesperson')
     A                                      COLHDG('Sales' 'Person')
     A            STATUS         1A         TEXT('Status')
     A                                      COLHDG('Sts')
     A          K CUSNO
     A          K PRPCDE
````
