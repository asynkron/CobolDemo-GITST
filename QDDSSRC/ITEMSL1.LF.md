# ITEMSL1.LF Member Guide

## Overview
DDS logical file `ITEMSL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `ITEMSL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R RITEMS                    PFILE(ITEMS)
     A          K #PART
````
