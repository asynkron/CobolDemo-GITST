# CONHDRL4.LF Member Guide

## Overview
DDS logical file `CONHDRL4` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CONHDRL4` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R CONHDRR                   PFILE(CONHDR)
     A          K XWBCCD
     A          K XWDLDT
     A          K PERSON
````
