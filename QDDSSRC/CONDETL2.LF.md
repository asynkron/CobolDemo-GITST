# CONDETL2.LF Member Guide

## Overview
DDS logical file `CONDETL2` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CONDETL2` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R CONDETR                   PFILE(CONDET)
     A
     A          K XWABCD
     A          K XWAACS
     A          K XWORDN
````
