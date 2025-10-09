# DREPORT.RPG Member Guide

## Overview
RPG III program `DREPORT` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `DREPORT`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSFL6  IP  E           K        DISK
     FDISTS   O   E                    DISK
     IRCUSF
     I                                              DSDCDEL1
     I*                                             DCODE L2
     CL1                   WRITERPRODS
````
