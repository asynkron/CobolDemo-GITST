# TRNHSTL2A.LF Member Guide

## Overview
DDS logical file `TRNHSTL2A` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL2A` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A          K XWABCD
     A          K XWAACS
     A          K XWE4NB
     A          K XWDLDT
````
