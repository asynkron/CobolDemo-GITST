# DISTS00.CBLINC Member Guide

## Overview
COBOL copybook `DISTS00` defines shared record layouts consumed by COBOL programs in `QCBLSRC`.

## Dependency Map
- **Incoming:** Any COBOL program with `COPY DISTS00` statements.
- **Outgoing:**
  - Provides record layouts for programs that copy this member.

## Source
````cobol
       01  DISTS-RECORD.
           05  DIS-DISTS-KEY-FIELD.
               10  DIS-CODE                   PIC X(02).
           05  DIS-DESCRIPTION                PIC X(34).
````
