# PROTRK.PF Member Guide

## Overview
DDS physical file `PROTRK` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `PROTRK` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R PROTRKR
     A            XWJOBN         6S 0       TEXT('Project')
     A            XWTRPT        11A         TEXT('Tracking Point')
     A            XWPLDT          L         TEXT('Planned Date')
     A            XWPLQT        13P 4       TEXT('Planned Qty')
     A                                      EDTCDE(M)
     A            XWACDT          L         TEXT('Actual Date')
     A            XWACTM          T         TEXT('Actual Time')
     A            XWACQT        13P 4       TEXT('Actual Qty')
     A                                      EDTCDE(M)
     A            XWSEQN         3S 0       TEXT('Sequence')
     A
     A          K XWJOBN
     A          K XWSEQN
````
