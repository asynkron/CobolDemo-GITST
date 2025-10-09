# STRBALDTL.LF Member Guide

## Overview
DDS logical file `STRBALDTL` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `STRBALDTL` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
                R PRDREC                    JFILE(STOMAS STKBAL STKMAS)
                J                           JOIN(STOMAS STKBAL)
                                            JFLD(XWAACS XWAACS)
                J                           JOIN(STKBAL STKMAS)
                                            JFLD(XWABCD XWABCD)
                  XWAACS                    JREF(STKBAL)
                  XWABCD                    JREF(STKBAL)
                  XWHLTX                    JREF(STKMAS)
                  XWBHQT                    JREF(STKBAL)
                  XWBKQT                    JREF(STKBAL)
````
