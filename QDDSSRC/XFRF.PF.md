# XFRF.PF Member Guide

## Overview
DDS physical file `XFRF` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `XFRF` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R XFRFR
     A            CONO           2P00       TEXT('COMPANY NUMBER')
     A                                      COLHDG('CO' 'NO')
     A            CSLC          10A         TEXT('CUSTOMER LOCATION')
     A            DVNO           3P00       TEXT('DIVISION NUMBER')
     A                                      COLHDG('DIV' 'NO.')
````
