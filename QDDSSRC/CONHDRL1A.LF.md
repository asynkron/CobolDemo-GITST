# CONHDRL1A.LF Member Guide

## Overview
DDS logical file `CONHDRL1A` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CONHDRL1A` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R CONHDRR                   PFILE(CONHDR)
     A
     A          K XWBCCD
     A          K XWCREF
````
