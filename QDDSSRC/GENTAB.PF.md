# GENTAB.PF Member Guide

## Overview
DDS physical file `GENTAB` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `GENTAB` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R GENTABR
     A            FLDNAM        10A         TEXT('Field Name')
     A            CODVAL        10A         TEXT('Code Value')
     A            CODTXT        34A         TEXT('Code Text')
     A            CODVL2        10A         TEXT('Code Extras')
     A          K FLDNAM
     A          K CODVAL
````
