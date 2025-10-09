# CUSLET1.CLP Member Guide

## Overview
Control Language (CL) program `CUSLET1` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `CUSLET1`.
- **Outgoing:**
  - Calls programs: LETN1, WKCUSL

## Source
````cl
             PGM        PARM(&CUSNC)
             DCL        VAR(&PK) TYPE(*CHAR) LEN(500)
             DCL        VAR(&LETSQ) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&CUSNO) TYPE(*DEC) LEN(5 0)
/*           DCL        VAR(&TRNNO) TYPE(*DEC) LEN(5 0) */
             DCL        VAR(&CUSNC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&prefix) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LETNR) TYPE(*CHAR) LEN(3)

             CHGVAR  &CUSNC &PK
             CHGVAR  &CUSNO &CUSNC
             CALL LETN1 (&CUSNO &PREFIX &LETSQ)
          /* MONMSG     MSGID(CPF0000)  */
             CHGVAR &CUSNC &PREFIX
             CHGVAR     VAR(&LETSQ) VALUE(&LETSQ + 1)
             CHGVAR     VAR(&LETNR) VALUE(&LETSQ)
             CALL       WKCUSL    (&CUSNC PREFIX &LETNR)
             MONMSG     (CPF6801)
             ENDPGM
````
