# PF4WNOKYL2.LF Member Guide

## Overview
DDS logical file `PF4WNOKYL2` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `PF4WNOKYL2` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     H*
     A*=====================================================================
     M* Maintenance   :
     A*=====================================================================
     A          R PF4WNOKYLR
     A                                      PFILE(PF4WNOKYS)
     A*---------------------------------------------------------------------
     A            AUC2CD
     A            AUC3CD
     A            AUBFTX
     A            AUC4CD
     A            AUC5CD
     A            AUAAPR
     A            AUABPR
     A*.....................................................................
     A* Key fields
     A          K AUC2CD
     A          K AUC3CD
     A*=====================================================================
     A          R PF5WNOKYLR
     A                                      PFILE(PF5WNOKYS)
     A*---------------------------------------------------------------------
     A            AVC2CD
     A            AVC3CD
     A            AVAINB
     A            AVBGTX
     A            AVA7ST
     A*.....................................................................
     A* Key fields
     A          K AVC2CD
     A          K AVC3CD
     A          K AVAINB
     A*=====================================================================
````
