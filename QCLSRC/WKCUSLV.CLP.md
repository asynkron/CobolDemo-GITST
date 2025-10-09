# WKCUSLV.CLP Member Guide

## Overview
Control Language (CL) program `WKCUSLV` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `WKCUSLV`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
             PGM       PARM(&CUSNC &PREFIX &MBR &LETNR &FAX +
                                                       &EDT &SKLEDT)
             DCL        &CUSNC *CHAR 5
             DCL        &MBR *CHAR 6
             DCL        &PREFIX *CHAR 5
             DCL        &LETNR  *CHAR 3
             DCL        &FAX *LGL
             DCL        &EDT *CHAR 1
   /*        DCL        &EDIT *CHAR 1    */
             DCL        &SKLEDT *CHAR 6
             MONMSG CPF0000
   /* Member name must start with SKL or TXT */
             IF ((%SST(&MBR 2 1) *NE ' ') *AND +
                 (%SST(&MBR 1 3) *NE 'SKL') *AND  +
                (%SST(&MBR 1 3) *NE 'TXT')) DO
             SNDPGMMSG  MSGID(UTL0007) MSGF(X@MSGF) MSGDTA('0000') +
                                         MSGTYPE(*DIAG)
             SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
             GOTO FINISH
             ENDDO
   /* Member exits */
             IF (%SST(&MBR 2 1) *NE ' ') DO
             CHKOBJ CUSLIB/QSKLSRC *FILE &MBR
             MONMSG     MSGID(CPF9815) EXEC(DO)
             SNDPGMMSG  MSGID(UTL0006) MSGF(X@MSGF) +
                          MSGDTA('0000' *CAT &MBR) MSGTYPE(*DIAG)
             SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
             GOTO FINISH
             ENDDO
             ENDDO
   /* Skeleton Letter exits */
             IF   (%SST(&MBR 1 2) *EQ 'E ') DO
             IF (&SKLEDT *EQ '*LAST ') RTVDTAARA CUSLIB/SKLNO &SKLEDT
             RTVMBRD  FILE(CUSLIB/QSKLSRC) MBR(&SKLEDT)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSGID(UTL0006) MSGF(X@MSGF) +
                          MSGDTA('0000' *CAT &SKLEDT) MSGTYPE(*DIAG)
             SNDPGMMSG  MSGID(CPF0002) MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
             ENDDO
             ENDDO
 FINISH:     ENDPGM
````
