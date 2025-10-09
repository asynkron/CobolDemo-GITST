# XRATE_EURO.RPG Member Guide

## Overview
RPG III program `XRATE_EURO` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `XRATE_EURO`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     C           *ENTRY    PLIST
     C                     PARM           @PARM   64
     C*
     C                     MOVE 1.5870    @PARM
     C                     RETRN
     C*
````
