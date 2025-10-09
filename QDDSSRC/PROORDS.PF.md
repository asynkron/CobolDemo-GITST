# PROORDS.PF Member Guide

## Overview
DDS physical file `PROORDS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `PROORDS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R PROORDR
     A            XPORDN         6S 0       TEXT('Contract')
     A            XPBCCD        11A         TEXT('Customer')
     A            XPG4TX        40A         TEXT('Name')
     A            XPDLDT          L         TEXT('Contract Date')
     A            XPSTAT         2A         TEXT('Status')
     A            XPREP          3A         TEXT('Rep')
     A            XPTAMT        13S 2       TEXT('Contract Value')
     A                                      EDTCDE(M)
````
