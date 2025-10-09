# SECFL3.LF Member Guide

## Overview
DDS logical file `SECFL3` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `SECFL3` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RSECF                     PFILE(SECF)
     A          K DCODE
     A          K SCDEXD
````
