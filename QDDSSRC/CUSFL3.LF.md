# CUSFL3.LF Member Guide

## Overview
DDS logical file `CUSFL3` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CUSFL3` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R RCUSF                     PFILE(CUSF)
     A          K CUSNO
````
