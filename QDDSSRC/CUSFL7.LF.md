# CUSFL7.LF Member Guide

## Overview
DDS logical file `CUSFL7` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CUSFL7` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RCUSF                     PFILE(CUSF)
     A          K LCTDAT
     A          K STATUS
     A          K CNAME
     A          O DSDCDE                    CMP(NE ' ')
     A          O FAXNO                     CMP(EQ '      ')
     A          O STATUS                    CMP(LT '0')
     A            STATUS                    CMP(NE ' ')
     A            STATUS                    CMP(NE 'Z')
     A          O STATUS                    CMP(EQ '7')
     A          O STATUS                    CMP(EQ '9')
````
