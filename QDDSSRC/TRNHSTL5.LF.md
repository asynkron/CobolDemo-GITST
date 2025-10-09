# TRNHSTL5.LF Member Guide

## Overview
DDS logical file `TRNHSTL5` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TRNHSTL5` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R TRNHSTR                   PFILE(TRNHST)
     A
     A          K PERSON
     A          K XWBCCD
````
