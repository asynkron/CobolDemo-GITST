# PRODFT.PF Member Guide

## Overview
DDS physical file `PRODFT` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `PRODFT` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R PRODFTR
     A            XWTRPT        11A         TEXT('Tracking Point')
     A            XWSEQN         3S 0       TEXT('Sequence')
     A            XWTRDS        30A         TEXT('Description')
     A            XWLDTM         3S 0       TEXT('Lead Time Days')
     A            XWMSPT         1A         TEXT('Master Point')
     A                                      VALUES('Y' 'N')
     A          K XWTRPT
````
