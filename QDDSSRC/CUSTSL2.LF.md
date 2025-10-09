# CUSTSL2.LF Member Guide

## Overview
DDS logical file `CUSTSL2` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CUSTSL2` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R CUSTSR                    PFILE(CUSTS)
     A
     A          K PERSON
     A          K XWBCCD
````
