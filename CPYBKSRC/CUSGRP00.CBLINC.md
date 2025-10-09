# CUSGRP00.CBLINC Member Guide

## Overview
COBOL copybook `CUSGRP00` defines shared record layouts consumed by COBOL programs in `QCBLSRC`.

## Dependency Map
- **Incoming:** Any COBOL program with `COPY CUSGRP00` statements.
- **Outgoing:**
  - Provides record layouts for programs that copy this member.

## Source
````cobol
       01  CUSGRP-RECORD.
           05  GRP-CUSGRP-KEY-FIELD.
               10  GRP-CUSTOMER-GROUP         PIC X(02).
           05  GRP-CUSTOMER-DESC              PIC X(40).
           05  FILLER  REDEFINES  GRP-CUSTOMER-DESC.
               10 GRP-CUSTOMER-CNTRY-ORIGIN       PIC X(10).
               10 GRP-CUSTOMER-RELATIONS          PIC X(05).
               10 GRP-CUSTOMER-SRV-DETAILS        PIC X(25).
````
