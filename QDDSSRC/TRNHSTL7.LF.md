# TRNHSTL7.LF Member Guide

## Overview
DDS logical file `TRNHSTL7` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL7` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A          K XWAACS
     A          K XWE4NB
     A          K XWRICD
````
