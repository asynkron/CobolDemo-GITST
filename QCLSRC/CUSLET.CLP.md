# CUSLET.CLP Member Guide

## Overview
Control Language (CL) program `CUSLET` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `CUSLET`.
- **Outgoing:**
  - Calls programs: CUSLET1

## Source
````cl
             PGM        PARM(&CUSNN)
             DCL        VAR(&CUSNN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CUSNC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LETSQ) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&LETNR) TYPE(*CHAR) LEN(3)
             DCL        VAR(&prefix) TYPE(*CHAR) LEN(5)
             CHGVAR  &CUSNC &CUSNN
             CALL       CUSLET1   (&CUSNC)
         /*  MONMSG CPF0000 **/
             ENDPGM
````
