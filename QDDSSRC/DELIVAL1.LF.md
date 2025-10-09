# DELIVAL1.LF Member Guide

## Overview
DDS logical file `DELIVAL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `DELIVAL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R DELIVAR                   PFILE(DELIVA)
     A          K PERSON
     A          K XWBDCD
````
