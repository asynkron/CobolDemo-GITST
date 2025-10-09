/*  ˆ * COPYRIGHT DATABOROUGH LTD 1996                               */
/*  ˆ *                                                              */
/*  ˆ * PROGRAM:  X-2000: Send Program Message                       */
/*  ˆ * AUTHOR:   Robin. F. W. Freeman                               */
/*  ˆ * VERSION:  No:   1.00    Date: 19/07/96                       */


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
