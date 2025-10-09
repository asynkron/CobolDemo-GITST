# PROTRKL1.LF Member Guide

## Overview
DDS logical file `PROTRKL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `PROTRKL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R PROTRKR                   PFILE(PROTRK)
     A
     A          K XWTRPT
     A          K XWPLDT
     A          K XWJOBN
     A          K XWSEQN
````
