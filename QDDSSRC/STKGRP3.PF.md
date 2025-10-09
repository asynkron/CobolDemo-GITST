# STKGRP3.PF Member Guide

## Overview
DDS physical file `STKGRP3` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `STKGRP3` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R STKGRP3R
     A            XWAGCD         2A         TEXT('Stk Group 1                 ')
     A                                      COLHDG('Grp' -
     A                                      ' 1')
     A            XWAHCD         2A         TEXT('Stk Group 2                 ')
     A                                      COLHDG('Grp' -
     A                                      '2')
     A            XWAICD         2A         TEXT('Stk Group 3                 ')
     A                                      COLHDG('Grp' -
     A                                      ' 3')
     A            XWIWTX        10A         TEXT('Stk Group Desc              ')
     A                                      COLHDG('Desc')
     A            XWIGTX        40A         TEXT('Stk Group Description       ')
     A                                      COLHDG('Description')
     A          K XWAGCD
     A          K XWAHCD
     A          K XWAICD
````
