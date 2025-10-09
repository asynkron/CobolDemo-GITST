# XPGFNM.PF Member Guide

## Overview
DDS physical file `XPGFNM` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `XPGFNM` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
A               R RPGFNM
 *
A                 PGID          10A
A                 PGX1          10A
A                 PGX2          10A
A               K PGID
````
