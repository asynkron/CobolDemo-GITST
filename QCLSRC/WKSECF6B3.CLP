             PGM        (&DCODE )

             DCL        &DCODE  *CHAR 2  /* DIST CODE */
             DCL        &PTEXT  *CHAR 50   /* User profile text */
             DCL        &PLETSQ *CHAR 3    /* Letter no. */
             DCL        &PMBR   *CHAR 10   /* Member */
             DCL        &MSGID  *CHAR 7 /* Msg. ID */
             DCL        &NEWMBR *CHAR 10
             DCL        VAR(&GENNO) TYPE(*DEC) LEN(5 0) VALUE(1)
             DCL        &GENNBR *CHAR 5

/*PR*/       DCL        &LIB *CHAR 10 VALUE('CUSLIB2')

             MONMSG     MSGID(RPG0000 CPF0000) EXEC(GOTO CMDLBL(FAIL))
             RTVUSRPRF  TEXT(&PTEXT)

             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Closing Distributor fax') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             CHGVAR &PMBR (&DCODE *TCAT '_CODES')
             CHKOBJ     OBJ(&LIB/QSECTXT) OBJTYPE(*FILE) MBR(&PMBR)
             MONMSG CPF0000    EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) MSGDTA('No +
                          open batch for this distributor code') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
                          GOTO FAIL
                          ENDDO

             CPYF       FROMFILE(&LIB/QSECTXT) TOFILE(&LIB/QSECTXT) +
                          FROMMBR(TERMTEXT) TOMBR(&PMBR) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             STRSEU     SRCFILE(&LIB/QSECTXT) SRCMBR(&PMBR) +
                          TYPE(TXT) OPTION(2)
             OVRPRTF    FILE(QSYSPRT) PAGESIZE(66 80) LPI(6) CPI(10) +
                          OVRFLW(66) OUTQ(FAXSTARPRT) HOLD(*NO) +
                          SECURE(*YES)
             OVRDBF     FILE(QLETSRC) TOFILE(QSECTXT) MBR(&PMBR)
             CALL    PGM(WKCUS8P)

/*           MONMSG     MSGID(CPF0000)                      */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Distirbutor fax Queued for +
                          FAX*STAR') TOPGMQ(*EXT) MSGTYPE(*STATUS)
             DLTOVR  FILE(QSYSPRT)

RENAME:      CHGVAR  &GENNBR &GENNO
             CHGVAR &NEWMBR (&DCODE *TCAT &GENNBR)
             RNMM       FILE(&LIB/QSECTXT) MBR(&PMBR) NEWMBR(&NEWMBR)
             MONMSG CPF3178 EXEC(DO)
             CHGVAR &GENNO (&GENNO + 1)
             GOTO RENAME
             ENDDO

 FAIL:       X@RPTMSG
             MONMSG     MSGID(CPF0000)
             ENDPGM
