# XBCCLMSG.CLP Member Guide

## Overview
Control Language (CL) program `XBCCLMSG` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `XBCCLMSG`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
/*   * COPYRIGHT DATABOROUGH LTD 1997                               */
/*   *                                                              */
/*   * PROGRAM:  X-Browse: Clear a Message Queue                    */
/*   * AUTHOR:   Robin. F. W. Freeman                               */
/*   * VERSION:  No:   1.00    Date: 22/10/1999                     */


/* ----------------------------------------------------------------- */
             PGM

/* REMOVE THE MESSAGE FROM MSGQ                                      */
             RMVMSG     PGMQ(*PRV) CLEAR(*ALL)
             MONMSG     MSGID(CPF0000)

/* ----------------------------------------------------------------- */
             ENDPGM
/* ----------------------------------------------------------------- */
````
