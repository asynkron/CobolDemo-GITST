# CUSINIT.CLP Member Guide

## Overview
Control Language (CL) program `CUSINIT` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `CUSINIT`.
- **Outgoing:**
  - Calls programs: CUSMNU

## Source
````cl
PGM
MONMSG CPF0000
ADDLIBLE QGPL
/*MONMSG CPF0000*/
ADDLIBLE X@UT
ADDLIBLE XAPP
/*MONMSG CPF0000*/
ADDLIBLE XACUS1
ADDLIBLE CUSLIB2
CALL CUSMNU
/*MONMSG CPF0000*/
ENDPGM
````
