# XASYSOPR.CLP Member Guide

## Overview
Control Language (CL) program `XASYSOPR` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `XASYSOPR`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
PGM
             SNDMSG     MSG('XA Test Alert') TOUSR(*SYSOPR)
        /*   MONMSG     MSGID(CPF0000)      */
ENDPGM
````
