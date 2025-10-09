# PROFIX1.RPG Member Guide

## Overview
RPG III program `PROFIX1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `PROFIX1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H
     FTRNHST  IP  E           K        DISK
     FPROFIX  IF  E           K        DISK                      A
     C           SLSMAS    KLIST
     C                     KFLD           XWAACS
     C                     KFLD           XWABCD
     C                     KFLD           XWDLDT
     C           SLSMAS    SETLLPROFIX                   90
     C                     ADD  1         XXJOBN  60
     C**                   Z-ADD1         XXJOBN  60
     C                     MOVE XXJOBN    XWJOBN
     C**                   MOVELXXJOBN    XWJOBN
     C                     MOVE XWDLDT    XWSTDT
     C                     MOVE XWDLDT    XWFNDT
     C                     Z-ADDXWA5QT    XWPLQT
     C                     Z-ADDXWA5QT    XWACQT
     C  N90                WRITEPROJECR
````
