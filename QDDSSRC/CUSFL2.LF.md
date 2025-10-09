# CUSFL2.LF Member Guide

## Overview
DDS logical file `CUSFL2` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CUSFL2` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A* ***********************************
     A          R RCUSF                     PFILE(CUSF      )
     A*
     A          K STATUS
     A          K CNAME
````
