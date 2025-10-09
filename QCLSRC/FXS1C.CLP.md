# FXS1C.CLP Member Guide

## Overview
Control Language (CL) program `FXS1C` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `FXS1C`.
- **Outgoing:**
  - File/display interactions: QSYSPRT
  - Calls programs: FAXSHT1, FXS1R

## Source
````cl
PGM          (&STAT &FRMDATI &NRDS &SKL &UPDATE &TYP &RDATI &RTIM)
             DCL &STAT *CHAR 1 /* Status */
             DCL &FRMDATI *CHAR 7 /* Fr. Date */
             DCL        &FRMDAT *CHAR 6 /* Fr. Datef*/
             DCL &NRDS *DEC (3 0) /* Generate No */
             DCL &SKL *CHAR 6 /* Letter No. */
             DCL &UPDATE *CHAR 1 /* Update */
             DCL &RDATI *CHAR 7 /* Run Date */
             DCL &RDAT *CHAR 6 /* Run Date */
             DCL &TYP *CHAR 3 /* Type */
             DCL &RTIM *CHAR 6 /* Run Time */
             DCL &TEXT *CHAR 50 /* Text */
             DCL &TYPE *CHAR 1 /* Job Type */

             RTVJOBA    TYPE(&TYPE)

             IF         (&TYPE *EQ '1') DO /* If Interactive */
             CHGVAR     &FRMDAT (%SST(&FRMDATI 6 2) *CAT +
                       %SST(&FRMDATI 4 2) *CAT %SST(&FRMDATI 2 2))
             IF (&UPDATE *EQ '1') DO
                 CHGVAR     &RDAT (%SST(&RDATI 6 2) *CAT +
                            %SST(&RDATI 4 2) *CAT %SST(&RDATI 2 2))
             SBMJOB     CMD(CALL FAXSHT1 (&SKL &FRMDAT)) +
                          JOB(FXS1C) JOBQ(QPGMR) LOG(4 99 *MSG) +
                          LOGCLPGM(*YES)
        /*   MONMSG CPF000     */
             ENDDO
             RETURN
             ENDDO

IF (&UPDATE *EQ '1') DO
             RTVMBRD    FILE(CUSLIB/QSKLSRC) MBR(&SKL) TEXT(&TEXT)
             CHGVAR     %SST(&TEXT 48 3) &TYP
             CHGPFM     FILE(CUSLIB/QSKLSRC) MBR(&SKL) TEXT(&TEXT)
             CHGDTAARA  DTAARA(CUSLIB/FXSDAT) VALUE(&RDATI)
             CHGDTAARA  DTAARA(CUSLIB/FXSTIM) VALUE(&RTIM)
             OVRDBF QSKLSRC CUSLIB/QSKLSRC &SKL
             OVRPRTF    FILE(QSYSPRT) PAGESIZE(68) LPI(6) CPI(10) +
                          OVRFLW(68) OUTQ(FAXSTARPRT) OUTPTY(7) +
                          HOLD(*NO) SECURE(*YES)
             CRTSRCPF    QTEMP/QLETSRC
        /*   MONMSG CPF000     */
             ADDPFM      QTEMP/QLETSRC  LETTER
             OVRDBF      QLETSRC QTEMP/QLETSRC
ENDDO
ELSE (OVRPRTF FILE(QSYSPRT) OUTQ(PRT04) HOLD(*YES))

             CHGVAR      &FRMDAT  (%SST(&FRMDATI 2 6))
             CALL  FXS1R (&STAT &FRMDAT &NRDS &UPDATE &RDATI &SKL +
                     &TYP &RTIM)
        /*   MONMSG CPF000     */
             DLTOVR     QSYSPRT
             IF (&UPDATE *EQ '1') (DLTF QTEMP/QLETSRC)
ENDPGM
````
