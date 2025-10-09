# CUSUPD2.RPGLE Member Guide

## Overview
ILE RPG program `CUSUPD2` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CUSUPD2`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     Fcusts     uf   e           k disk
      *
     c                   move      *blank        xwbccd
     c                   movel     'ACC10'       xwbccd
EANP8C     xwbccd        chain     custs                              30
EANP8C     *in30         ifeq      *off
     c                   movel     'MT2'         person
     c                   update    custsr
     c                   end
     C                   seton                                        lr
     C                   return
````
