# TRNCLPCMD.CLLE Member Guide

## Overview
ILE Control Language (CLLE) program `TRNCLPCMD` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `TRNCLPCMD`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
             PGM        PARM(&PRM1)
/*----------------------------------------------------------------- */
             DCL        VAR(&PRM1) TYPE(*CHAR) LEN(11)
/*           DCL        VAR(&ACC1) TYPE(*CHAR) LEN(11)               */

             IF         COND(&PRM1 = ' ') THEN(DO)
                CHGVAR  VAR(&PRM1) VALUE(ACC1)
             ENDDO

             TRNHSTCMD  PARM1(&PRM1)

/*           MONMSG     MSGID(CPF0000)                               */
/*----------------------------------------------------------------- */
             ENDPGM
/*----------------------------------------------------------------- */
````
