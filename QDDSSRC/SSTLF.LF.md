# SSTLF.LF Member Guide

## Overview
DDS logical file `SSTLF` exposes keyed views over the underlying physical file to support indexed access.

## Dependency Map
- **Incoming:** Programs that open the `SSTLF` LF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A                                      UNIQUE
     A          R SSTLFRCD                  PFILE(SSTPF)

     A            YY                 I      SST(ORDDAT 1 4)
     A                                      TEXT('Order year')
     A                                      COLHDG('Order' 'Year')

     A            MM                 I      SST(ORDDAT 5 2)
     A                                      TEXT('Order month')
     A                                      COLHDG('Order' 'Month')

     A            DD                 I      SST(ORDDAT 7 2)
     A                                      TEXT('Order day')
     A                                      COLHDG('Order' 'Day')

     A          K YY
     A          K MM
     A          K DD
````
