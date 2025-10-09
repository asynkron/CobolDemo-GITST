# SLMEN.PF Member Guide

## Overview
DDS physical file `SLMEN` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `SLMEN` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RSLMEN
     A            PERSON         3A         TEXT('Person')
     A            PNAME         34A         TEXT('Full Name')
     A          K PERSON
````
