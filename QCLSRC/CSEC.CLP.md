# CSEC.CLP Member Guide

## Overview
Control Language (CL) program `CSEC` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `CSEC`.
- **Outgoing:**
  - Calls programs: WKSECF6B

## Source
````cl
             PGM        PARM(&PK)
             DCL        VAR(&PK) TYPE(*CHAR) LEN(500)
             DCL        VAR(&CUSNC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CUSNO) TYPE(*DEC) LEN(5 0)
/*           DCL        VAR(&TRNST) TYPE(*DEC) LEN(5 0)   */
             DCL        VAR(&SERLC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&EXDTC) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EXDNO) TYPE(*DEC) LEN(6 0)

             DCL        VAR(&CUSG) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LETSQ) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&CUSNC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&prefix) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LETNR) TYPE(*CHAR) LEN(3)

/* RETRIEVE KEYS */
             CHGVAR  &CUSNC &PK
             CHGVAR  &CUSNO &CUSNC
             CHGVAR  &EXDTC %SST(&PK 51 6)
             CHGVAR  &EXDNO &EXDTC
             CHGVAR  &SERLC %SST(&PK 101 8)

             CALL WKSECF6B (&CUSNO &SERLC ' ' &EXDNO)
/*           MONMSG     MSGID(CPF0000)              */

             ENDPGM
````
