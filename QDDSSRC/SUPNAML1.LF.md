# SUPNAML1.LF Member Guide

## Overview
DDS logical file `SUPNAML1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `SUPNAML1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R SUPNAMR                   PFILE(SUPNAM)
     A
     A          K XCG4TX
````
