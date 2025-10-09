# WKSECF6B2.CLP Member Guide

## Overview
Control Language (CL) program `WKSECF6B2` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `WKSECF6B2`.
- **Outgoing:**
  - Calls programs: WKSECF6

## Source
````cl
             PGM        (&PCUSNO &PSRLNB &PCDTY &PCDEXD)

             DCL        &PCUSNO *DEC (5 0) /* Customer no. */
             DCL        &PSRLNB *CHAR 8    /* Serial no. */
             DCL        &PCDTY  *CHAR 1    /* Type */
             DCL        &PCDEXD *DEC (6 0) /* Expiry date */
             DCL        &PTEXT  *CHAR 50   /* User profile text */
             DCL        &PLETSQ *CHAR 3    /* Letter no. */
             DCL        &PMBR   *CHAR 10   /* Member */
             DCL        &MSGID  *CHAR 7 /* Msg. ID */
             DCL        &CUSNC  *CHAR 5    /* Customer no. */

/*PR*/       DCL        &LIB *CHAR 10 VALUE('CUSLIB2')

             MONMSG     MSGID(RPG0000 CPF0000) EXEC(GOTO CMDLBL(FAIL))
             RTVUSRPRF  TEXT(&PTEXT)
/*           MONMSG CPF0000          */

             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Updating Distributor Letter') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)

                          CHGVAR &PMBR '*AGENT'
             CALL WKSECF6 (&PCUSNO &PSRLNB &PCDTY &PCDEXD &PTEXT +
                                   &PLETSQ &PMBR)
/*           MONMSG CPF0000          */
             STRSEU     SRCFILE(&LIB/QSECTXT) SRCMBR(&PMBR) +
                          TYPE(TXT) OPTION(2)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Security codes stored for batch +
                          transmission') TOPGMQ(*EXT) MSGTYPE(*STATUS)
/*           MONMSG     MSGID(CPF0000)                      */
 FAIL:       X@RPTMSG
             MONMSG     MSGID(CPF0000)
             ENDPGM
````
