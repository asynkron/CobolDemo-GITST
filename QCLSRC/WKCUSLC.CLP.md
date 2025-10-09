# WKCUSLC.CLP Member Guide

## Overview
Control Language (CL) program `WKCUSLC` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `WKCUSLC`.
- **Outgoing:**
  - Calls programs: CVTTOBIN

## Source
````cl
             PGM  (&PARM &CHOICES)
             DCL  &PARM *CHAR 21
             DCL  &CHOICES *CHAR 2000
             DCL  &THIRTY *CHAR 2     /* 30 In binary */
             DCL  &NUMBER *CHAR 2     /* Number of entries in binary */
             DCL  &CNT  *DEC (5 0) 8  /* Running total of entries */
             DCL  &POS  *DEC (5 0)    /* Position */
             DCL  &CNTA *CHAR  5      /* Work variable */
             DCL  &MBR  *CHAR 10      /* Returned Member Name */
             DCL  &TEXT *CHAR 50      /* Returned Text name */
/*           DCL  &TNAM *CHAR 50  */  /* Text name */
/*PR*/       DCL  &LIB  *CHAR 10 VALUE('CUSLIB2')
             MONMSG CPF0000
             IF (%SST(&PARM 21 1) *EQ 'C') CHGVAR &CHOICES +
             'B,C,E,F,I,O,P,R,TXTnnn,SKLnnn'
             ELSE DO
             CALL CVTTOBIN ('00030' &THIRTY)
             CHGVAR &CHOICES +
                    (&THIRTY *CAT 'B       Brochure              ' +
               *CAT  &THIRTY *CAT 'C       Create Skeleton Letter' +
               *CAT  &THIRTY *CAT 'E       Edit Skeleton Letter  ' +
               *CAT  &THIRTY *CAT 'F       Free Format Letter    ' +
               *CAT  &THIRTY *CAT 'I       Invoice               ' +
               *CAT  &THIRTY *CAT 'O       Order                 ' +
               *CAT  &THIRTY *CAT 'P       Proforma              ' +
               *CAT  &THIRTY *CAT 'R       Release               ')
             RTVMBRD    FILE(&LIB/QSKLSRC) MBR(*FIRSTMBR) +
                          RTNMBR(&MBR) TEXT(&TEXT)
             MONMSG CPF0000  EXEC(GOTO NEXT)
 TOP:        CHGVAR &POS ((&CNT * 32) + 1)
             CHGVAR %SST(&CHOICES &POS 32) +
                  (&THIRTY *CAT %SST(&MBR 1 8) *CAT %SST(&TEXT 1 22))
             CHGVAR &CNT (&CNT + 1)
             RTVMBRD    FILE(&LIB/QSKLSRC) MBR(&MBR *NEXT) +
                          RTNMBR(&MBR) TEXT(&TEXT)
             MONMSG CPF0000 EXEC(GOTO NEXT)
             GOTO TOP
 NEXT:       CHGVAR &CNTA &CNT
             CALL CVTTOBIN (&CNTA &NUMBER)
             CHGVAR &CHOICES (&NUMBER *CAT &CHOICES)
             ENDDO
             ENDPGM
````
