             PGM        PARM(&CUSNO &PREFIX &LLETSQ)

             DCL        VAR(&CUSNO) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LLETSQ) TYPE(*DEC) LEN(3 0)

             DCL        VAR(&CUSNC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LETNR) TYPE(*CHAR) LEN(3)

             CALL LETN1 (&CUSNO &PREFIX &LLETSQ)
/*           MONMSG     MSGID(CPF0000)              */

             CHGVAR     VAR(&CUSNC) VALUE(&PREFIX)
             CHGVAR     VAR(&LLETSQ) VALUE(&LLETSQ + 1)
             CHGVAR     VAR(&LETNR) VALUE(&LLETSQ)

   ?         WKCUSL ?*CUSNO(&CUSNC) ?*PREFIX(&PREFIX) ??LETNR(&LETNR)
             MONMSG     (CPF6801)

             ENDPGM
