# CONFIX1.RPG Member Guide

## Overview
RPG III program `CONFIX1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CONFIX1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H
     FTRNHST  IP  E           K        DISK
     FCONDETL2IF  E           K        DISK                      A
     C           SLSMAS    KLIST
     C                     KFLD           XWAACS
     C                     KFLD           XWABCD
     C                     KFLD           XWORDN
     C           SLSMAS    SETLLCONDETL2                 90
     C           XWVALU    DIV  XWA5QT    XWPRIC
     C  N90                WRITECONDETR
````
