# TRNHSTL3B.LF Member Guide

## Overview
DDS logical file `TRNHSTL3B` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL3B` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A          K XWBCCD
     A          K XWT8TX
     A          K XWABCD
````
