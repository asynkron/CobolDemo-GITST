# CONDETL3.LF Member Guide

## Overview
DDS logical file `CONDETL3` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CONDETL3` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R CONDETR                   PFILE(CONDET)
     A
     A          K XWABCD
     A          K XWORDN
````
