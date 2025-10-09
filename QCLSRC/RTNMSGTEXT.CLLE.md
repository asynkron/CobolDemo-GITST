# RTNMSGTEXT.CLLE Member Guide

## Overview
ILE Control Language (CLLE) program `RTNMSGTEXT` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `RTNMSGTEXT`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
/* ----------------------------------------------------------------- */
/*Parameters */
/* ----------------------------------------------------------------- */
             PGM        PARM(&MSGID &MSGTEXT)

/* ----------------------------------------------------------------- */
/*Declarations */
/* ----------------------------------------------------------------- */
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
/*           DCL        VAR(&TEXT) TYPE(*CHAR) LEN(132)              */
             DCL        VAR(&MSGTEXT) TYPE(*CHAR) LEN(132)

/* ----------------------------------------------------------------- */
/*Retrieve messgae text */
/* ----------------------------------------------------------------- */

             RTVMSG     MSGID(&MSGID) MSGF(XAN4CDEM/OEMSGF) +
                          MSG(&MSGTEXT)
             MONMSG     MSGID(CPF0000)

/* ----------------------------------------------------------------- */
             ENDPGM
/* ----------------------------------------------------------------- */
````
