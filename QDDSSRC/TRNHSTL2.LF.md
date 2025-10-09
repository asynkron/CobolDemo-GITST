# TRNHSTL2.LF Member Guide

## Overview
DDS logical file `TRNHSTL2` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL2` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A          K XWABCD
     A          K XWE4NB
     A          K XWRICD
````
