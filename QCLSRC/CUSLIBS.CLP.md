# CUSLIBS.CLP Member Guide

## Overview
Control Language (CL) program `CUSLIBS` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `CUSLIBS`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
PGM
MONMSG CPF0000
ADDLIBLE XAPP
/*MONMSG CPF0000 */
ADDLIBLE XACUS1
/*MONMSG CPF0000 */
ADDLIBLE CUSLIB2
/*MONMSG CPF0000 */
ENDPGM
````
