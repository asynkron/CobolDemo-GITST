# ORDBALDTL.LF Member Guide

## Overview
DDS logical file `ORDBALDTL` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `ORDBALDTL` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
                R PRDREC                    JFILE(CONHDR CONDET STKMAS)
                J                           JOIN(CONHDR CONDET)
                                            JFLD(XWORDN XWORDN)
                J                           JOIN(CONDET STKMAS)
                                            JFLD(XWABCD XWABCD)
                  XWBCCD                    JREF(CONHDR)
                  XWCREF                    JREF(CONHDR)
                  XWABCD                    JREF(CONDET)
                  XWHLTX                    JREF(STKMAS)
                  XWAACS                    JREF(CONDET)
                  XWA5QT                    JREF(CONDET)
                  XWPRIC                    JREF(CONDET)
                  XWORDN                    JREF(CONHDR)
````
