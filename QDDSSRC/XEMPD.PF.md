# XEMPD.PF Member Guide

## Overview
DDS physical file `XEMPD` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `XEMPD` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R XEMPDR
     A            EMPI          10A         TEXT('Employee Info')
     A                                      COLHDG('Employee' 'Info')
     A            EMPD          20A         TEXT('Employee Name')
     A                                      COLHDG('Employee' 'Name')
     A            EMPS           7S 2       TEXT('Employee Salary')
     A                                      COLHDG('Employee' 'Salary')
     A            EMPL          10S 0       TEXT('Credit Limit')
     A                                      COLHDG('Credit' 'Limit')
     A            DEPT          10A         TEXT('Department')
     A                                      COLHDG('Department')
````
