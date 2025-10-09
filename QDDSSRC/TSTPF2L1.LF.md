# TSTPF2L1.LF Member Guide

## Overview
DDS logical file `TSTPF2L1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TSTPF2L1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R TSTPF2R                   PFILE(TSTPF2)
     A          K FLD21
     A          K FLD22
````
