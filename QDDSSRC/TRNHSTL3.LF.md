# TRNHSTL3.LF Member Guide

## Overview
DDS logical file `TRNHSTL3` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL3` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A
     A          K XWBCCD
     A          K XWE4NB
     A          K XWRICD
````
