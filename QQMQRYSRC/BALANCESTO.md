# BALANCESTO Member Guide

## Overview
Query/400 definition `BALANCESTO` reproduces a saved Query/400 report definition.

## Dependency Map
- **Incoming:** Operations staff running the saved query `BALANCESTO`.
- **Outgoing:**
  - Query pulls data from: STKBAL, STKMAS, STOMAS

## Source
````sql
H QM4 05 Q 01 E V W E R 01 03 16/07/11 10:40
V 1001 050 Balance by Store
SELECT
-- Columns
      B.XWAACS, B.XWABCD, C.XWHLTX, B.XWBHQT, B.XWBKQT
-- Tables
      FROM "STOMAS" A,
           "STKBAL" B,
           "STKMAS" C
-- Join Conditions
      WHERE (A.XWAACS = B.XWAACS)
           AND (B.XWABCD = C.XWABCD)
-- Sort Columns
      ORDER BY B.XWAACS, B.XWABCD
````
