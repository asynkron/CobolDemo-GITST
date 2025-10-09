# TSTPF1L4.LF Member Guide

## Overview
DDS logical file `TSTPF1L4` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `TSTPF1L4` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R TSTPF1R                   PFILE(TSTPF1)
     A          K *NONE
````
