# CUSFL5.LF Member Guide

## Overview
DDS logical file `CUSFL5` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CUSFL5` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RCUSF                     PFILE(CUSF)
     A          K DSDCDE
     A          K STATUS
     A          K CNAME
````
