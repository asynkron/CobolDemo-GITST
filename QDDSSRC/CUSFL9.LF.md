# CUSFL9.LF Member Guide

## Overview
DDS logical file `CUSFL9` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `CUSFL9` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RCUSF                     PFILE(CUSF)
     A          K FAXNO
     A          O DSDCDE                    CMP(NE ' ')
     A          O STATUS                    CMP(LT '0')
     A            STATUS                    CMP(NE ' ')
     A            STATUS                    CMP(NE 'Z')
     A          O STATUS                    CMP(EQ '9')
     A          O TELNO                     CMP(LT '01')
     A          O LCTDAT                    CMP(GT 971001)
````
