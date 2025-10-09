# CNTLF2.LF Member Guide

## Overview
DDS logical file `CNTLF2` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CNTLF2` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
      * SIMON       24/02/06  A0000001    Default Audit, delete if not required
     A          R RCNTAC                    PFILE(CNTACS)
     A          K USERNM
````
