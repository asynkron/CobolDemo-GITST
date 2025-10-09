# TSTPF2.PF Member Guide

## Overview
DDS physical file `TSTPF2` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `TSTPF2` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
                                            UNIQUE
     A          R TSTPF2R
     A            FLD21          5P 0
     A            FLD22         10A
     A            FLD23         10A
     A          K FLD21
````
