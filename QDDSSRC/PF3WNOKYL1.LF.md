# PF3WNOKYL1.LF Member Guide

## Overview
DDS logical file `PF3WNOKYL1` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `PF3WNOKYL1` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     H*
     A*=====================================================================
     M* Maintenance   :
     A*=====================================================================
     A                                      JDFTVAL
     A                                      FIFO
     A*=====================================================================
     A          R PF3WNOKYLR
     A                                      JFILE(PF3WNOKYS +
     A                                            PF2WNOKYS +
     A                                            PF1WNOKYS +
     A                                           )
     A*---------------------------------------------------------------------
     A*
     A          J                           JOIN(1 2)
     A                                      JFLD(AFAECD AEAECD)
     A*---------------------------------------------------------------------
     A*
     A          J                           JOIN(1 3)
     A                                      JFLD(AFAACD AAAACD)
     A*---------------------------------------------------------------------
     A            AFAECD
     A                                      JREF(1)
     A            AFAOTX
     A                                      JREF(2)
     A                                      RENAME(AEAOTX)
     A            AFAACD
     A                                      JREF(1)
     A            AFAATX
     A                                      JREF(3)
     A                                      RENAME(AAAATX)
     A            AFABTX
     A                                      JREF(3)
     A                                      RENAME(AAABTX)
     A            AFAICD
     A                                      JREF(1)
     A            AFAJCD
     A                                      JREF(1)
     A            AFAKCD
     A                                      JREF(1)
     A            AFALCD
     A                                      JREF(1)
     A            AFAMCD
     A                                      JREF(1)
     A            AFANCD
     A                                      JREF(1)
     A            AFAOCD
     A                                      JREF(1)
     A            AFAPCD
     A                                      JREF(1)
     A            AFAQCD
     A                                      JREF(1)
     A            AFARCD
     A                                      JREF(1)
     A            AFASCD
     A                                      JREF(1)
     A            AFATCD
     A                                      JREF(1)
     A            AFAUCD
     A                                      JREF(1)
     A            AFAVCD
     A                                      JREF(1)
     A            AFAWCD
     A                                      JREF(1)
     A            AFAXCD
     A                                      JREF(1)
     A            AFAYCD
     A                                      JREF(1)
     A            AFAZCD
     A                                      JREF(1)
     A            AFA0CD
     A                                      JREF(1)
     A            AFA1CD
     A                                      JREF(1)
     A            AFAAVN
     A                                      JREF(1)
     A            AFAADT
     A                                      JREF(1)
     A            AFAATM
     A                                      JREF(1)
     A            AFABVN
     A                                      JREF(1)
     A            AFABDT
     A                                      JREF(1)
     A            AFABTM
     A                                      JREF(1)
     A*.....................................................................
     A* Key fields
     A          K AFAACD
     A          K AFAECD
     A*=====================================================================
````
