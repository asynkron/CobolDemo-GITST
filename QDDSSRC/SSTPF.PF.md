# SSTPF.PF Member Guide

## Overview
DDS physical file `SSTPF` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `SSTPF` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
                R SSTPFRCD
                  ORDDAT         8A         TEXT('Order date')
                                            COLHDG('Order' 'Date')
````
