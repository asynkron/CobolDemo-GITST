# CUSGRP.PF Member Guide

## Overview
DDS physical file `CUSGRP` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `CUSGRP` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R CUSGRPR
     A            XWBNCD         2A         TEXT('CusGrp')
     A            XWKHTX        40A         TEXT('Description')
     A          K XWBNCD
````
