# PROJECL1B.LF Member Guide

## Overview
DDS logical file `PROJECL1B` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `PROJECL1B` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R PROJECR                   PFILE(PROJECT)
     A
     A          K XWABCD
     A          K XWAACS
     A          K XWJOBN
     A
     A          S XWJSTS                    COMP(NE 'C')
````
