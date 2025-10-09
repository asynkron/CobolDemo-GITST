# CONHDRL5.LF Member Guide

## Overview
DDS logical file `CONHDRL5` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CONHDRL5` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R CONHDRR                   PFILE(CONHDR)
     A          K XWDLDT
````
