# ITEMS.PF Member Guide

## Overview
DDS physical file `ITEMS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `ITEMS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R RITEMS
     A            #ITEM         10A         TEXT('Item #')
     A            #DESC         30A         TEXT('Description')
     A            #PART         15A         TEXT('Part #')
     A            #WEIGHT        3P 0       TEXT('Weight')
     A            #UOM           3A         TEXT('Weight Unit of Measure')
     A          K #ITEM
````
