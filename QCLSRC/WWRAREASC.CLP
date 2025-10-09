             PGM
             DCL        VAR(&REP) TYPE(*CHAR) LEN(3) VALUE('   ')

             CALL       PGM(*LIBL/WWRAREAS) PARM(&REP)
/*           MONMSG     MSGID(CPF0000)                    */

             ENDPGM
