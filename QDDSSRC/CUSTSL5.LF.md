# CUSTSL5.LF Member Guide

## Overview
DDS logical file `CUSTSL5` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CUSTSL5` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R CUSTSR                    PFILE(CUSTS)
     A
     A          K XWB2CD
     A          K XWBCCD
````
