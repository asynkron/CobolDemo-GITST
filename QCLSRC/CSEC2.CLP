             PGM        PARM(&PK)
             DCL        VAR(&PK) TYPE(*CHAR) LEN(500)
             DCL        VAR(&CUSNC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&CUSNO) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&SERLC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&EXDTC) TYPE(*CHAR) LEN(6)
             DCL        VAR(&EXDNO) TYPE(*DEC) LEN(6 0)

             DCL        VAR(&CUSG) TYPE(*CHAR) LEN(7)
             DCL        VAR(&LETSQ) TYPE(*DEC) LEN(3 0)
/*           DCL        VAR(&TRNSQ) TYPE(*DEC) LEN(3 0)  */
             DCL        VAR(&CUSNC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&prefix) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LETNR) TYPE(*CHAR) LEN(3)

/* RETRIEVE KEYS */
             CHGVAR  &CUSNC &PK
/*           CHGVAR     VAR(&CUSNC) VALUE(&PK1)     */
             CHGVAR  &CUSNO &CUSNC
             CHGVAR  &EXDTC %SST(&PK 51 6)
             CHGVAR  &EXDNO &EXDTC
/*           CHGVAR     VAR(&EXD11) VALUE(&EXDT1)   */
             CHGVAR  &SERLC %SST(&PK 101 8)

             CALL WKSECF6B2 (&CUSNO &SERLC ' ' &EXDNO)
/*           MONMSG     MSGID(CPF0000)               */

             ENDPGM
