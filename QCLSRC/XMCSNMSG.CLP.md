# XMCSNMSG.CLP Member Guide

## Overview
Control Language (CL) program `XMCSNMSG` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `XMCSNMSG`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
/*   * COPYRIGHT DATABOROUGH LTD 1996                               */
/*   *                                                              */
/*   * PROGRAM:  X-2000: Send Program Message                       */
/*   * AUTHOR:   Robin. F. W. Freeman                               */
/*   * VERSION:  No:   1.00    Date: 19/07/96                       */


/* ----------------------------------------------------------------- */
             PGM        PARM(&MSGID &MSGFILE &MSGLIB &MSGDTA &PGMQ +
                          &MSGTYPE)

/* ----------------------------------------------------------------- */
             DCL        VAR(&MSGID)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGFILE)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGLIB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&PGMQ)       TYPE(*CHAR) LEN(10)
/*           DCL        VAR(&MSGQ)       TYPE(*CHAR) LEN(10)         */
             DCL        VAR(&MSGTYPE)    TYPE(*CHAR) LEN(7)

/* ----------------------------------------------------------------- */
/* Send status message */

             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGLIB/&MSGFILE) +
                          MSGDTA(&MSGDTA) TOPGMQ(&PGMQ) +
                          MSGTYPE(&MSGTYPE)
             MONMSG CPF0000

/* ----------------------------------------------------------------- */
             ENDPGM
/* ----------------------------------------------------------------- */
````
