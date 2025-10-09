# TRNHSTL4.LF Member Guide

## Overview
DDS logical file `TRNHSTL4` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL4` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A
     A          K XWAGCD
     A          K XWAHCD
     A          K XWAICD
     A          K XWABCD
````
