# SEC1.RPG Member Guide

## Overview
RPG III program `SEC1` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `SEC1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSTS   IP  E                    DISK
     FSECF    IF  E           K        DISK                      A
     IRSECF
     I              SCMT1                           ICMT
     C           CUSNO     CHAINSECF                 81
     C                     MOVELICMT      SCMT1  30
     C                     WRITERSECF                  20
````
