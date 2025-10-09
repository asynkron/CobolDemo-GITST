# TSTPF1.PF Member Guide

## Overview
DDS physical file `TSTPF1` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `TSTPF1` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R TSTPF1R
     A            FLD11          5P 0
     A            FLD12         10A
     A            FLD13         10A
     A            FLD14         10A
````
