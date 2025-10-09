# CUSMTH.RPG Member Guide

## Overview
RPG III program `CUSMTH` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CUSMTH`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSTS   UP  E           K        DISK
     C                     MOVELMNDATE    @C4     4
     C                     MOVE @C4       MMONTH
     C**                   WRITERCUSTS
     C                     UPDATRCUSTS
````
