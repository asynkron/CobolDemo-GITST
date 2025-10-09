# DISTS.PF Member Guide

## Overview
DDS physical file `DISTS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `DISTS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RPRODS
     A            DSDCDE         2A         TEXT('Code')
     A            DNAME         34A         TEXT('Description')
     A          K DSDCDE
````
