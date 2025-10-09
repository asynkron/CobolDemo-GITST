# ORGS.PF Member Guide

## Overview
DDS physical file `ORGS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `ORGS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RORGS
     A            ONAME         34A         TEXT('Organisation Name')
     A            CRTNAM        10A         TEXT('Created By:')
     A            CRTDAT         6S 0       TEXT('Creation Date')
     A                                      EDTCDE(Y)
     A            UPDNAM        10A         TEXT('Updated By:')
     A            UPDDAT         6S 0       TEXT('Update Date')
     A                                      EDTCDE(Y)
     A            ORG            5P 0       TEXT('Organisation No.')
     A          K ORG
````
