# CUSMNU.CLP Member Guide

## Overview
Control Language (CL) program `CUSMNU` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `CUSMNU`.
- **Outgoing:**
  - File/display interactions: CUSMNUDF
  - Calls programs: FAXERR1, FAXERR2, FAXSHT1, HLP001, QCMD, UTIL01, WKCUS8E, WKCUS8EF, WKCUS8P, WKCUSP, WKSECF6

## Source
````cl
             PGM

             DCLF       FILE(CUSMNUDF)

             DCL        VAR(&MSG) TYPE(*CHAR) LEN(80)
             DCL        VAR(&ERRCNT) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&CK) TYPE(*CHAR) LEN(240) +
                          VALUE('F1=Help     F3=Exit     +
                          F6=Messages     F9=Start Office     +
                          F24=More keys       F14=Sbm Jobs        +
                          F18=Start Writer    F19=Writer Messages +
                          F24=More keys       F20=Work Writer     +
                          F21=Output          F22=Utilites        +
                          F24=More keys       ')
             DCL        VAR(&$K) TYPE(*DEC) LEN(1 0) VALUE(1)
             DCL        VAR(&$S) TYPE(*DEC) LEN(3 0)
/*           DCL        VAR(&$S1) TYPE(*DEC) LEN(4 0)            */
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&STATUS) TYPE(*CHAR) LEN(01)
             DCL        VAR(&CNAME ) TYPE(*CHAR) LEN(10)

             MONMSG     MSGID(CPF4168 CPF5143) EXEC(GOTO SDAOFF)
             MONMSG     MSGID(CPF5144) EXEC(GOTO SDAOFF)
             MONMSG     MSGID(CPF4101) EXEC(GOTO SDAFILE)
             MONMSG     MSGID(CPF4131) EXEC(GOTO SDAFMT)
             MONMSG     MSGID(CPF6801) EXEC(GOTO SDAMSG)
             MONMSG     MSGID(CPF9999) EXEC(GOTO SDAERR)
/*           MONMSG     MSGID(CPF0684) EXEC(GOTO SDAEOF)    */

 SDAMENU:    CHGVAR     VAR(&MENUPGMQ) VALUE(CUSMNU)
             CHGVAR     VAR(&@@PGM) VALUE(CUSMNU)

 SDABEGIN:   CHGVAR     &$S VALUE(&$K * 80)
             CHGVAR     &$S VALUE(&$S - 79)
             CHGVAR     &$CMDF VALUE(%SST(&CK &$S 80))

             SNDRCVF    DEV(*FILE) RCDFMT(MENUFMT)
/*           MONMSG     MSGID(CPF0000)      */

             RMVMSG     CLEAR(*ALL)

             CHGVAR     VAR(&ERRCNT) VALUE(0)

 SDACF1:     /* CF1 COMMAND                                   */

             IF         COND(&IN01) THEN(DO)
             CALL       PGM(HLP001) PARM(@MENUPGMQ 'B')
/*           MONMSG     MSGID(CPF0000)      */
             GOTO       SDAMSG
             ENDDO

 SDACF3:     /* CF3 COMMAND                                   */

             IF         COND(&IN03) THEN(RETURN)

 SDACF6:     /* CF6 COMMAND                                   */

             IF         COND(&IN06) THEN(DO)
             DSPMSG
             GOTO       SDAMSG
             ENDDO

 SDACF9:     /* CF9  COMMAND                                  */

             IF         COND(&IN09) THEN(DO)
             CALL QCMD
/*           MONMSG     MSGID(CPF0000)      */
             GOTO       SDAMSG
             ENDDO
 SDACF14:    /* CF14 COMMAND                                  */

             IF         COND(&IN14) THEN(DO)
             WRKSBMJOB
             GOTO       SDAMSG
             ENDDO

 SDACF18:    /* CF18 COMMAND                                  */

             IF         COND(&IN18) THEN(DO)
             STRPRTWTR  PRT02
             MONMSG     (CPF3310)
             GOTO       SDAMSG
             ENDDO

 SDACF19:    /* CF19 COMMAND                                  */

             IF         COND(&IN19) THEN(DO)
             DSPMSG     MSGQ(QSYSOPR) MSGTYPE(*INQ)
             GOTO       SDAMSG
             ENDDO

 SDACF20:    /* CF20 COMMAND                                  */

             IF         COND(&IN20) THEN(DO)
             WRKWTR     PRT02
             GOTO       SDAMSG
             ENDDO

 SDACF21:    /* CF21 COMMAND                                  */

             IF         COND(&IN21) THEN(DO)
             WRKOUTQ    PRT02
             GOTO       SDAMSG
             ENDDO

 SDACF22:    /* CF22 COMMAND                                  */

             IF         COND(&IN22) THEN(DO)
             CALL       PGM(UTIL01) PARM(@MENUPGMQ 'B')
/*           MONMSG     MSGID(CPF0000)      */
             GOTO       SDAMSG
             ENDDO

 SDACF24:    /* CF24 COMMAND                                  */

             IF         COND(&IN24) THEN(DO)
             CHGVAR     (&$K) VALUE(&$K + 1)
             IF         (&$K *GT 3) CHGVAR &$K 1
             GOTO       SDAMSG
             ENDDO

 SDA00010:   /* 1    Edit Customer Database                             */

             IF         COND(&OPTION = '1  ') THEN(DO)
             CALL       WKCUSP
/*           MONMSG     MSGID(CPF0000)      */
             GOTO       SDAMSG
             ENDDO

 SDA00012:   /* 2    Position by Customer Number                        */

             IF         COND(&OPTION = '2  ') THEN(DO)
             CALL       WKCUS8E
/*           MONMSG     MSGID(CPF0000)      */
             GOTO       SDAMSG
             ENDDO

 SDA00015:   /* 3    Position by Serial Number                          */

             IF         COND(&OPTION = '3  ') THEN(DO)
             CALL       WKCUS8EF
/*           MONMSG     MSGID(CPF0000)      */
             GOTO       SDAMSG
             ENDDO

 SDA00017:   /* 4    Customers requiring new release                    */

             IF         COND(&OPTION = '4  ') THEN(DO)
             CALL       WKCUS8P
/*           MONMSG     MSGID(CPF0000)      */
             GOTO       SDAMSG
             ENDDO

 SDA00018:   /* 5    Print Flyer Letters in Batch Mode                  */

             IF         COND(&OPTION = '5  ') THEN(DO)
             CALL       FAXSHT1
/*           MONMSG     MSGID(CPF0000)      */
             GOTO       SDAMSG
             ENDDO

 SDA00020:   /* 6    Detail Report - Active Customers                   */

             IF         COND(&OPTION = '10 ') THEN(DO)
             CALL       WKSECF6
/*           MONMSG     MSGID(CPF0000)      */
             GOTO       SDAMSG
             ENDDO

 SDA00030:   /* 7    Summary Report - All Customers (excludes status 9  */
             /*                        and OLDMCH blank                 */

             IF         COND(&OPTION = '6  ') THEN(DO)
             CALL  FAXERR1
             GOTO       SDAMSG
             ENDDO
             IF         COND(&OPTION = '7  ') THEN(DO)
             CALL FAXERR2
             GOTO       SDAMSG
             ENDDO


 SDA00900:   /* 90   Sign Off                                           */

             IF         COND(&OPTION = '90 ') THEN(DO)
             ENDPASTHR
             MONMSG CPF0000
             SIGNOFF
             GOTO       SDAEND
             ENDDO

 SDAENDOP:   CHGVAR     VAR(&MSG) VALUE('SDA2007')

             SNDPGMMSG  MSGID(&MSG) MSGF(QSDAMSG) TOPGMQ(*SAME)
             GOTO       SDASFL

 SDAERR:     IF         COND(&ERRCNT > 0) THEN(GOTO SDAEND)

             CHGVAR     VAR(&ERRCNT) VALUE(&ERRCNT+1)
 SDAMSG:     RCVMSG     RMV(*NO) MSG(&MSG)

             IF         COND(&MSG = ' ') THEN(DO)
             SNDPGMMSG  MSG(&MSG)
             GOTO       SDAMSG
             ENDDO

 SDASFL:     CHGVAR     VAR(&IN02) VALUE('1')

             SNDF       DEV(*FILE) RCDFMT(MENUSFLC)

             GOTO       SDABEGIN

 SDAOFF:     SIGNOFF    LOG(*LIST)

 SDAFILE:    SNDPGMMSG  MSGID(SDA2002) MSGF(QSDAMSG)
             GOTO       SDAEND

 SDAFMT:     SNDPGMMSG  MSGID(SDA2006) MSGF(QSDAMSG)

 SDAEND:     RETURN

             CHGVAR     VAR(&MSGKEY) VALUE(&MSGKEY)
             ENDPGM
````
