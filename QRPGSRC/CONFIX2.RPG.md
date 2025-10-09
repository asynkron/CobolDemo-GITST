# CONFIX2.RPG Member Guide

## Overview
RPG III program `CONFIX2` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CONFIX2`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H
     FTRNHST  IP  E           K        DISK
     FCONHDRL1IF  E           K        DISK                      A
     C           SLSMAS    KLIST
     C                     KFLD           XWBCCD
     C                     KFLD           XWORDN
     C           SLSMAS    SETLLCONHDRL1                 90
     C                     MOVELXWT8TX    XWCREF
     C                     MOVELXWDLDT    XWDLDT
     C*
     C  N90                WRITECONHDRR
````
