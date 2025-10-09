# ASTATUS.PF Member Guide

## Overview
DDS physical file `ASTATUS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `ASTATUS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
      * TEST COMMENT 1
      * TEST COMMENT 2
      * TEST COMMENT 3
      * TEST COMMENT 4
     A          R STATUSR
     A            STATUS         1A
     A                                      TEXT('Status')
     A                                      COLHDG('STATUS')
      *           STSTXT        30A         ALWNULL
     A            STSTXT        30A
     A                                      TEXT('Status text')
     A                                      COLHDG('STSTXT')
     A          K STATUS
````
