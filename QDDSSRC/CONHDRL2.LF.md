# CONHDRL2.LF Member Guide

## Overview
DDS logical file `CONHDRL2` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CONHDRL2` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R CONHDRR                   PFILE(CONHDR)
     A
     A          K PERSON
     A          K XWORDN
````
