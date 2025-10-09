# CUSFLB.LF Member Guide

## Overview
DDS logical file `CUSFLB` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CUSFLB` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RCUSF                     PFILE(CUSF)
     A          K LSLCDE
     A          K CNAME
````
