# WKCUSL.CLP Member Guide

## Overview
Control Language (CL) program `WKCUSL` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `WKCUSL`.
- **Outgoing:**
  - File/display interactions: QLETSRC, QSYSPRT
  - Calls programs: CUSLETSQ, CUSLETSR, WKCUS8E, WKCUS8EF, WKCUS8P

## Source
````cl
             PGM       PARM(&CUSNC &PREFIX &LETTER &LETNR &FAX +
                                                       &EDT &SKLEDT)
             DCL        VAR(&CUSNC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LETNR) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CUSNR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LETTER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REPRINT) TYPE(*CHAR) LEN(1) VALUE('Y')
             DCL        &FAX *LGL
             DCL        VAR(&VER) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SWITCH) TYPE(*LGL) LEN(1)
/*           DCL        VAR(&SWITC1) TYPE(*LGL) LEN(1)    */
             DCL        VAR(&USRTXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&FAXNO) TYPE(*CHAR) LEN(17)
             DCL        VAR(&MBRTXT) TYPE(*CHAR) LEN(50) VALUE('Free +
                          Format Letter')
             DCL        &EDT *CHAR 1
             DCL        &SKLEDT *CHAR 6
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        &MSGID *CHAR 7 /* Msg. ID */
             DCL        &SKLN  *DEC (3 0) /* Skeleton letter suffix */
             DCL        &SKLSFX  *CHAR 3  /* Skeleton letter suffix */
             DCL        &SKL *LGL VALUE('0') /* Skeleton letter flag */
             DCL        &SKC *LGL VALUE('0') /* Skeleton letter flag */

/*PR*/       DCL        &LIB *CHAR 10 VALUE('CUSLIB2') /* Library    */

             RTVJOBA    USER(&USER)

             IF (%SST(&LETTER 2 1) *NE ' ') DO
             OVRDBF QSKLSRC &lib/QSKLSRC &LETTER
/*           MONMSG     MSGID(CPF0000)                               */
             CHGVAR &SKL  '1'
             CHGVAR &TYPE 'F'
             ENDDO
             ELSE CHGVAR &TYPE &LETTER

             IF (&TYPE *EQ 'C') DO  /* Create Skeleton Letter */
             CHGVAR &SKC  '1'
             CHGVAR &TYPE 'F'
             ENDDO
             IF (&TYPE *EQ 'E') DO  /* Edit Skeleton Letter */
             CHGVAR &SKC  '1'
             CHGVAR &SKL  '1'
             CHGVAR &TYPE 'F'
             IF (&SKLEDT *EQ '*LAST ') RTVDTAARA   &LIB/SKLNO &SKLEDT
             OVRDBF QSKLSRC   &LIB/QSKLSRC &SKLEDT
             ENDDO

             CHGVAR     VAR(&CUSNR) VALUE('C' *CAT &PREFIX +
                        *cat &type *CAT &LETNR)
             CALL       CUSLETSQ (&cusnc &LETNR)
/*           CALL       CUSLETSR (&cusnc &LETNR)           */
             CHKOBJ     OBJ(&lib/QLETSRC) OBJTYPE(*FILE) MBR(&CUSNR)
             MONMSG     (CPF9815) EXEC(DO)
             IF         (&REPRINT *EQ 'Y') (CHGVAR &REPRINT 'N')
             IF         COND(&TYPE *EQ 'B') THEN(CHGVAR VAR(&MBRTXT) +
                          VALUE('Brochure Request'))
             IF         COND(&TYPE *EQ 'I') THEN(CHGVAR VAR(&MBRTXT) +
                          VALUE('Invoice'))
             IF         COND(&TYPE *EQ 'R') THEN(CHGVAR VAR(&MBRTXT) +
                          VALUE('Software Release'))
             ADDPFM     FILE(&lib/QLETSRC) MBR(&CUSNR) +
                          TEXT(&MBRTXT) SRCTYPE(TXT)
             ENDDO

             ALCOBJ     OBJ((&lib/QLETSRC *FILE *EXCL &CUSNR)) +
                          WAIT(10)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             SNDPGMMSG  MSG('Unable to Allocate Member in file +
                          QLETSRC') TOPGMQ(*PRV WKCUS8)
             GOTO       ENDPGM
             ENDDO

             OVRDBF     FILE(QLETSRC) TOFILE(&lib/QLETSRC) +
                          MBR(&CUSNR)
             IF         (&REPRINT *EQ 'N') DO
             CLRPFM     FILE(&lib/QLETSRC) MBR(&CUSNR)
/*  Generate Customer Letter                                                  */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Generating the Customer Letter') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)
             RTVDTAARA  DTAARA(X@OBJ/X@VER) RTNVAR(&VER)
             RTVUSRPRF  TEXT(&USRTXT)
             IF &FAX CALL WKCUS8EF (&CUSNC &FAXNO)
             ELSE CHGVAR &FAXNO ' '
             IF (&FAXNO *NE ' ') OVRDBF QSIGSRC &lib/QSIGSRC &USER
             CALL WKCUS8E (&CUSNC &TYPE &VER &USRTXT &FAXNO &SKL ' ' +
             ' ')
             ENDDO
/*  Display the Customer Letter                                               */
             CHGJOB SWS(XXXXXXX0)
      IF (&EDT *EQ 'W')  (DO)
      STRWP OPTION(1)
      ENDDO
      ELSE (DO)
             RMVMSG     CLEAR(*ALL)
             STRSEU     SRCFILE(&LIB/QLETSRC) SRCMBR(&CUSNR) +
                          TYPE(TXT)
             RCVMSG     MSGID(&MSGID)
             IF ((*NOT (&FAX *OR &SKC *OR &SKL)) *OR +
                (&MSGID *EQ 'EDT0229')) CHGJOB SWS(XXXXXXX1)
             ELSE GOTO ENDPGM
             IF &SKC DO
             IF (*NOT &SKL) DO
             RTVDTAARA  DTAARA(&LIB/SKLNO (4 3)) RTNVAR(&SKLSFX)
             CHGVAR &SKLN &SKLSFX
             CHGVAR &SKLN (&SKLN + 1)
             CHGVAR &SKLSFX &SKLN
             CHGVAR &SKLEDT ('TXT' *CAT &SKLSFX)
             CHGDTAARA &LIB/SKLNO &SKLEDT
             ENDDO
             CPYF  FROMFILE(&LIB/QLETSRC) +
                TOFILE(&LIB/QSKLSRC) FROMMBR(&CUSNR) +
                  TOMBR(&SKLEDT) MBROPT(*REPLACE) +
                     INCREL((*IF SRCSEQ *GT 32)) +
                         SRCOPT(*SEQNBR)
             IF &SKL (SNDPGMMSG MSG('Updated Skeleton Letter' +
                          *BCAT &SKLEDT) TOPGMQ(*PRV WKCUS8))
             ELSE  (SNDPGMMSG MSG('Created Skeleton Letter' +
                          *BCAT &SKLEDT) TOPGMQ(*PRV WKCUS8))
             ENDDO
      ENDDO
             CHGVAR     VAR(&SWITCH) VALUE(%SWITCH(XXXXXXX1))
             IF         COND(&SWITCH *EQ '1') THEN(DO)
/*  Print the Customer Letter                                                 */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Printing the Customer +
                          Letter') TOPGMQ(*EXT) MSGTYPE(*STATUS)
             IF         COND(&FAX) THEN(OVRPRTF FILE(QSYSPRT) +
                          PAGESIZE(66 80) LPI(6) CPI(10) OVRFLW(66) +
                          OUTQ(FAXSTARPRT) HOLD(*NO) SECURE(*YES))
             ELSE DO
             IF         COND(&USER *EQ L_PERKINS) THEN(OVRPRTF +
                          FILE(QSYSPRT) PAGESIZE(66 80) LPI(6) +
                          CPI(10) OVRFLW(60) OUTQ(PRT02) HOLD(*NO))
              ELSE OVRPRTF FILE(QSYSPRT) OUTQ(PRT02) HOLD(*YES) +
                   PAGESIZE(66 80) LPI(6) CPI(10) OVRFLW(60)
             ENDDO
             CALL       PGM(WKCUS8P)
             IF         COND(&FAX) THEN(SNDPGMMSG MSGID(CPF9898) +
                          MSGF(QSYS/QCPFMSG) MSGDTA('Customer +
                          Letter Queued for FAX*STAR') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS))
             ELSE       CMD(SNDPGMMSG MSGID(CPF9898) +
                          MSGF(QSYS/QCPFMSG) MSGDTA('Customer +
                          Letter printed') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS))
             DLTOVR     FILE(QSYSPRT)
             ENDDO

ENDPGM:      DLCOBJ     OBJ((&lib/QLETSRC *FILE *EXCL &CUSNR))
             ENDPGM
````
