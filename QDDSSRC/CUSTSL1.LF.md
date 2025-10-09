# CUSTSL1.LF Member Guide

## Overview
DDS logical file `CUSTSL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CUSTSL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R CUSTSR                    PFILE(CUSTS)
     A
     A          K XWBNCD
     A          K XWBCCD
````
