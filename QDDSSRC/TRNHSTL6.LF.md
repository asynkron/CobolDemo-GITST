# TRNHSTL6.LF Member Guide

## Overview
DDS logical file `TRNHSTL6` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL6` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A          K XWORDN
     A          K XWABCD
     A          K XWRICD
     A          K XWDLDT
````
