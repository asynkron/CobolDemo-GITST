# DELIVA.PF Member Guide

## Overview
DDS physical file `DELIVA` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `DELIVA` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R DELIVAR
     A            XWBDCD         3A         TEXT('Debtor Delivery Area        ')
     A                                      COLHDG('Del' -
     A                                      'Area')
     A            XWGXTX        40A         TEXT('Debtor Del/Area Descriptn   ')
     A                                      COLHDG('Description')
     A            PERSON         3A         TEXT('Representative              ')
     A                                      COLHDG('Rep')
     A          K XWBDCD
````
