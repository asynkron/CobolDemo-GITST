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
/*           DCL        &LIB *CHAR 10 VALUE('CUSLIB4')  */


             MONMSG     MSGID(RPG0000 CPF0000) EXEC(GOTO CMDLBL(FAIL))
             RTVUSRPRF  TEXT(&PTEXT)

             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Generating the Customer Letter') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             CALL WKSECF6 (&PCUSNO &PSRLNB &PCDTY &PCDEXD &PTEXT +
                                   &PLETSQ &PMBR)
/*           MONMSG CPF0000                         */
             STRSEU     SRCFILE(&LIB/QSECTXT) SRCMBR(&PMBR) +
                          TYPE(TXT) OPTION(2)
             RCVMSG     MSGID(&MSGID)
/*           MONMSG CPF0000                         */
             IF (&MSGID *EQ 'EDT0229') DO
             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          OVRFLW(66) OUTQ(FAXSTARPRT) HOLD(*NO) +
                          SECURE(*YES)
             OVRDBF     FILE(QLETSRC) TOFILE(QSECTXT) MBR(&PMBR)
             CALL    PGM(WKCUS8P)
/*           MONMSG CPF0000                         */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                        MSGDTA('Customer Letter Queued for FAX*STAR') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             CHGVAR  &CUSNC &PCUSNO
             CALL    CUSLETSQ (&CUSNC &PLETSQ)
/*           MONMSG CPF0000                         */
             DLTOVR  FILE(QSYSPRT)

             ENDDO
 FAIL:       X@RPTMSG
             MONMSG     MSGID(CPF0000)
             ENDPGM
