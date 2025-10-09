# PROJECL4A.LF Member Guide

## Overview
DDS logical file `PROJECL4A` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `PROJECL4A` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R PROJECR                   PFILE(PROJECT)
     A
     A          K XWAACS
     A          K XWABCD
     A          K XWFNDT
     A
     A          S XWJSTS                    COMP(NE 'C')
````
