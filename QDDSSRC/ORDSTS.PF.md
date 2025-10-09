# ORDSTS.PF Member Guide

## Overview
DDS physical file `ORDSTS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `ORDSTS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R STATUSR
     A
     A            XWSTAT         2A         TEXT('Status code')
     A            XWSDSC        20A         TEXT('Description')
     A
     A          K XWSTAT
````
