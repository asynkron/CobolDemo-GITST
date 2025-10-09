# TSTPF3.PF Member Guide

## Overview
DDS physical file `TSTPF3` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `TSTPF3` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R TSTPF3R
     A            FLD31          5P 0
     A            FLD32         10A
     A            FLD33         10A
     A            FLD34         10A
     A          K FLD31
````
