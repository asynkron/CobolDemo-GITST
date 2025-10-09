# LISTS.PF Member Guide

## Overview
DDS physical file `LISTS` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `LISTS` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R RLISTS
     A            LSLCDE         2A         TEXT('Code')
     A            LNAME         34A         TEXT('Description')
     A          K LSLCDE
````
