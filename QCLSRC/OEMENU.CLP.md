# OEMENU.CLP Member Guide

## Overview
Control Language (CL) program `OEMENU` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `OEMENU`.
- **Outgoing:**
  - File/display interactions: OEMENUDF
  - Calls programs: OE001, OE002, OE003, OE004, OE006

## Source
````cl
             PGM

             /* Definitions */

             DCLF       FILE(OEMENUDF)
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(1)
/*           DCL        VAR(&RTNTP) TYPE(*CHAR) LEN(1)  */

             CHGVAR     VAR(&@@PGM) VALUE(OEMENU)
             CHGVAR     VAR(&$CMDF) VALUE('F3=Exit        F6=Messages')


             /* Display Order Entry Menu */
DISPLAY:
             CHGVAR     VAR(&OPTION) VALUE(' ')
             SNDRCVF    DEV(*FILE) RCDFMT(MENUFMT)
             /*MONMSG CPF0000 */

             /* Action F3 Request */

             IF         COND(&IN03) THEN(DO)
             RETURN
             ENDDO

             /* Action F6 Request */

             IF         COND(&IN06) THEN(DO)
             DSPMSG
             GOTO       DISPLAY
             ENDDO

             /* Action Selection */

             /* 1    Order Entry */

             IF         COND(&OPTION = '1') THEN(DO)
             CALL       PGM(OE001) PARM(&RTNCD)
             MONMSG     MSGID(CPF0000)
             GOTO       DISPLAY
             ENDDO

             /* 2    Order Enquiry */

             IF         COND(&OPTION = '2') THEN(DO)
             CALL       PGM(OE002) PARM(&RTNCD)
             MONMSG     MSGID(CPF0000)
             GOTO       DISPLAY
             ENDDO

             /* 3    Product Enquiry */

             IF         COND(&OPTION = '3') THEN(DO)
             CALL       PGM(OE003) PARM(&RTNCD)
             MONMSG     MSGID(CPF0000)
             GOTO       DISPLAY
    /*       GOTO       END     */
             ENDDO

             /* 4    Customer Enquiry */

             IF         COND(&OPTION = '4') THEN(DO)
             CALL       PGM(OE004) PARM(&RTNCD)
             MONMSG     MSGID(CPF0000)
             GOTO       DISPLAY
             ENDDO


             /* 6    Print Invoices */

             IF         COND(&OPTION = '6') THEN(DO)
             CALL       PGM(OE006) PARM(&RTNCD)
             MONMSG     MSGID(CPF0000)
             GOTO       DISPLAY
             ENDDO

             /* Catch All */

             GOTO       DISPLAY

             /* End Of Program */

             ENDPGM
````
