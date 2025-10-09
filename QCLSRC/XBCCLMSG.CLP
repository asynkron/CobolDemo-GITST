/*  ˆ * COPYRIGHT DATABOROUGH LTD 1997                               */
/*  ˆ *                                                              */
/*  ˆ * PROGRAM:  X-Browse: Clear a Message Queue                    */
/*  ˆ * AUTHOR:   Robin. F. W. Freeman                               */
/*  ˆ * VERSION:  No:   1.00    Date: 22/10/1999                     */


/* ----------------------------------------------------------------- */
             PGM

/* REMOVE THE MESSAGE FROM MSGQ                                      */
             RMVMSG     PGMQ(*PRV) CLEAR(*ALL)
             MONMSG     MSGID(CPF0000)

/* ----------------------------------------------------------------- */
             ENDPGM
/* ----------------------------------------------------------------- */
