# FXS3C.CLP Member Guide

## Overview
Control Language (CL) program `FXS3C` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `FXS3C`.
- **Outgoing:**
  - Calls programs: FXS30R

## Source
````cl
PGM
             ADDLIBLE FAXTOOL
             MONMSG CPF0000
             CALL FXS30R
         /*  MONMSG CPF0000   */

             RMVLIBLE FAXTOOL
             MONMSG CPF0000

ENDPGM
````
