# STKBALL1.LF Member Guide

## Overview
DDS logical file `STKBALL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `STKBALL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R STKBALR                   PFILE(STKBAL)
     A
     A          K XWAGCD
     A          K XWAHCD
     A          K XWAICD
     A          K XWABCD
````
