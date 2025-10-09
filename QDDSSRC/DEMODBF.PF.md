# DEMODBF.PF Member Guide

## Overview
DDS physical file `DEMODBF` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `DEMODBF` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
                R RDEM
                  FLD1          10A         COLHDG('FISRT NAME')
                  FLD2          10A         COLHDG('MIDDLE NAME')
                  FLD3          10A         COLHDG('LAST NAME')
````
