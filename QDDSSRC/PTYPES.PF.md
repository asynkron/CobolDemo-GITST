# PTYPES.PF Member Guide

## Overview
DDS physical file `PTYPES` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `PTYPES` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RPRODS
     A            PRPCDE         2A         TEXT('Code')
     A            PDESF         34A         TEXT('Description')
     A            PQTY           7P 2       TEXT('Quantity')
     A            PUNT          20A         TEXT('Unit')
     A            PPRC           7P 2       TEXT('Price')
     A          K PRPCDE
     A          K PDESF
     A          K PQTY
     A          K PUNT
     A          K PPRC
````
