# TRNTYP.PF Member Guide

## Overview
DDS physical file `TRNTYP` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `TRNTYP` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R TRNTYPR
     A
     A            XWRICD         3A         TEXT('Transaction type')
     A            XWTDSC        20A         TEXT('Description')
     A
     A          K XWRICD
````
