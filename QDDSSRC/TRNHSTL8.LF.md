# TRNHSTL8.LF Member Guide

## Overview
DDS logical file `TRNHSTL8` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL8` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A          K XWBDCD
     A          K XWABCD
     A          K XWE4NB
     A          K XWRICD
````
