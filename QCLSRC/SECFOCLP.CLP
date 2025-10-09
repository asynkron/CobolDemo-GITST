             PGM
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(125)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(125)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(125)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(125)
/*           DCL        VAR(&MLIB) TYPE(*CHAR) LEN(125) */

             OVRDBF     FILE(CUSFL3O) TOFILE(CUSLIBLIZN/CUSFL3)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             RCVMSG     MSGTYPE(*LAST) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             RMVMSG     CLEAR(*ALL)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
     /*      MONMSG     MSGID(CPF0000)      */
             ENDDO

             CALL       PGM(SECFO)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             RCVMSG     MSGTYPE(*LAST) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             RMVMSG     CLEAR(*ALL)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
     /*      MONMSG     MSGID(CPF0000)      */
             ENDDO

 END:        ENDPGM
