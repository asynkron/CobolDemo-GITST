             PGM
             DCL        VAR(&CUSTOMER) TYPE(*DEC) LEN(5 0) VALUE(0)

             CALL       PGM(*LIBL/WWCCONS) PARM(&CUSTOMER)
          /* MONMSG     MSGID(CPF0000)   */

             ENDPGM
