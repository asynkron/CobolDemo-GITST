# STKMASL1.LF Member Guide

## Overview
DDS logical file `STKMASL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `STKMASL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A
     A          R STKMASR                   PFILE(STKMAS)
     A
     A          K XWAGCD
     A          K XWAHCD
     A          K XWAICD
     A          K XWABCD
````
