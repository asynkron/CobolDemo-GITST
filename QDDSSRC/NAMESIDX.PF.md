# NAMESIDX.PF Member Guide

## Overview
DDS physical file `NAMESIDX` defines the physical table structure referenced by application programs.

## Dependency Map
- **Incoming:** Programs that open the `NAMESIDX` PF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A          R NAMESIDXF
     A            IXNAME        34A         TEXT('Name')
     A            IXTELNO       17A         TEXT('Telephone No.')
     A            IXEMAIL       50A         TEXT('E-Mail Address')
     A            IXWEBSITE     50A         TEXT('Web Site')
     A          K IXNAME
````
