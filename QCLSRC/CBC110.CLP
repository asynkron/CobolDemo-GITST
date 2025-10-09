             PGM        PARM(&OPT &USR &WSI)
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSI) TYPE(*CHAR) LEN(10)

             DCL        VAR(&P1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P2) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&P3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P4) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P5) TYPE(*DEC) LEN(10 4)
             DCL        VAR(&P6) TYPE(*DEC) LEN(10 4)
             DCL        VAR(&P7) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P8) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P9) TYPE(*DEC) LEN(8 3)
             DCL        VAR(&P10) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P11) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P12) TYPE(*CHAR) LEN(2)

/*IF (&OPT *EQ '1') THEN(DO)*/
/* OVRDBF CBACPF LVLCHK(*NO)*/
/* CALL  CB905R             */
/*ENDDO                     */

IF (&OPT *EQ '1') THEN(DO)
   OVRDBF CBACPF LVLCHK(*NO)
   CALL       PGM(CB906R) PARM(&P1 &P2 &P3 &P4 &P5 &P6 &P7 &P8 &P9 &P10 +
                &P11 &P12)
ENDDO

IF (&OPT *EQ '2') THEN(DO)
   CLRPFM CBTRPF
   CALL  CB907R
ENDDO

ENDPGM
