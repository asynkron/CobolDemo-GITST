# TRNHSTL9.LF Member Guide

## Overview
DDS logical file `TRNHSTL9` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL9` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R TRNHSTR                   PFILE(TRNHST)
     A          K XWBCCD
     A          K XWDLDT
````
