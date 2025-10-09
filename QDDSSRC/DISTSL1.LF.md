# DISTSL1.LF Member Guide

## Overview
DDS logical file `DISTSL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `DISTSL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RPRODS                    PFILE(DISTS)
     A          K DNAME
````
