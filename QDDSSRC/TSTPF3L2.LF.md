# TSTPF3L2.LF Member Guide

## Overview
DDS logical file `TSTPF3L2` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TSTPF3L2` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R TSTPF3R                   PFILE(TSTPF3)
     A          K FLD31
     A          K FLD33
````
