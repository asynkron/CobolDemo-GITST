# TRIGGER1.RPGLE Member Guide

## Overview
ILE RPG program `TRIGGER1` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `TRIGGER1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
      /free
       *inlr = *on;
       return;
      /end-free
````
