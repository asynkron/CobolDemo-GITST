# PROJECL5A.LF Member Guide

## Overview
DDS logical file `PROJECL5A` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `PROJECL5A` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R PROJECR                   PFILE(PROJECT)
     A
     A          K XWORDN
     A          K XWABCD
     A          K XWJOBN
     A
````
