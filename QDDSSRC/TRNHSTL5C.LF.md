# TRNHSTL5C.LF Member Guide

## Overview
DDS logical file `TRNHSTL5C` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL5C` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A
     A          K PERSON
     A          K XWBCCD
     A          K XWABCD
````
