# CUSMTHB.RPG Member Guide

## Overview
RPG III program `CUSMTHB` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CUSMTHB`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSTS   UF  E           K        DISK
     C                     MOVELUDATE      @C4     4
     C                     MOVE @C4       UDATE
     C**                   WRITERCUSTS
     C                     UPDATRCUSTS
````
