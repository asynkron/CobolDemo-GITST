# STOMAS.PF Member Guide

## Overview
DDS physical file `STOMAS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `STOMAS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R STOMASR
     A
     A            XWAACS        11A         TEXT('Store')
     A            XWDESC        20A         TEXT('Description')
     A
     A          K XWAACS
````
