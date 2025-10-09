# SECFL1.LF Member Guide

## Overview
DDS logical file `SECFL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `SECFL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RSECF                     PFILE(SECF)
     A          K CUSNO
     A          K PCODE
     A          K SCDEXD
````
