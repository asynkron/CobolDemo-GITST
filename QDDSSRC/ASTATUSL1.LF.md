# ASTATUSL1.LF Member Guide

## Overview
DDS logical file `ASTATUSL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `ASTATUSL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R STATUSR                   PFILE(ASTATUS)
     A            STATUS         1A
     A                                      TEXT('Status')
     A                                      COLHDG('STATUS')
     A            STSTXT        30A
     A                                      TEXT('Status text')
     A                                      COLHDG('STSTXT')
````
