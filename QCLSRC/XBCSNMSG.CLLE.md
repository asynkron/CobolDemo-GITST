# XBCSNMSG.CLLE Member Guide

## Overview
ILE Control Language (CLLE) program `XBCSNMSG` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `XBCSNMSG`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
/* ----------------------------------------------------------------- */
             PGM        PARM(&PGMQ &PGREL &MSGID &MSGFILE &MSGDTA +
                          &MSGTYPE)

/* ----------------------------------------------------------------- */
             DCL        VAR(&PGMQ)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGREL)      TYPE(*CHAR) LEN(5)
             DCL        VAR(&MSGID)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGFILE)    TYPE(*CHAR) LEN(10)
/*           DCL        VAR(&MSGtext)    TYPE(*CHAR) LEN(10)         */
             DCL        VAR(&MSGLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('XRAPPS')
             DCL        VAR(&MSGDTA)     TYPE(*CHAR) LEN(132)
             DCL        VAR(&MSGTYPE)    TYPE(*CHAR) LEN(7)
/*           DCL        VAR(&MSGTEXT)    TYPE(*CHAR) LEN(7)          */

/* ----------------------------------------------------------------- */
/* Send status message */

             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGLIB/&MSGFILE) +
                          MSGDTA(&MSGDTA) TOPGMQ(*PRV)
             MONMSG CPF0000

/* ----------------------------------------------------------------- */
             ENDPGM
/* ----------------------------------------------------------------- */
````
