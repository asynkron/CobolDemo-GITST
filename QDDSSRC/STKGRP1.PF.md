# STKGRP1.PF Member Guide

## Overview
DDS physical file `STKGRP1` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `STKGRP1` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R STKGRP1R
     A            XWAGCD         2A         TEXT('Stk Group 1                 ')
     A                                      COLHDG('Grp' -
     A                                      ' 1')
     A            XWIWTX        10A         TEXT('Stk Group Desc              ')
     A                                      COLHDG('Desc')
     A            XWIGTX        40A         TEXT('Stk Group Description       ')
     A                                      COLHDG('Description')
     A          K XWAGCD
````
