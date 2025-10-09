# ZBCONHDR.CBL Member Guide

## Overview
COBOL program `ZBCONHDR` encapsulates business logic within the COBOL layer.

## Dependency Map
- **Incoming:** CL or command drivers that call COBOL program `ZBCONHDR`.
- **Outgoing:**
  - Accesses files: CONHDR, CONHDRL1, CUSFL3, CUSTS, DISPLAY, ORDSTS, SLMEN
  - Calls programs: CBCONDET, CUSTSSEL, ORDSTSEL, RTNMSGTEXT, SLMENSEL, XBCCLMSG
  - Includes copybooks: DDS

## Source
````cobol
       PROCESS DATETIME.
       IDENTIFICATION DIVISION.
       PROGRAM-ID.     CBCONHDR.
       AUTHOR.         Databorough India.
       DATE-WRITTEN.   20 MAR. 2009.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-AS400.
       OBJECT-COMPUTER. IBM-AS400.
       SPECIAL-NAMES. LOCAL-DATA IS LOCALDATA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT DISPLAY-FILE
               ASSIGN TO WORKSTATION-WCONHDRD
               ORGANIZATION TRANSACTION
               ACCESS MODE DYNAMIC
               RELATIVE KEY RECNO
               FILE STATUS IS SFL-STATUS
               CONTROL-AREA SCRN-CONTROL.

           SELECT CONHDR-FILE
               ASSIGN TO DATABASE-CONHDR
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY
               FILE STATUS IS CONHDR-FILE-STATUS.

           SELECT CONHDRL1-FILE
               ASSIGN TO DATABASE-CONHDRL1
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY
                                      WITH DUPLICATES.

           SELECT CUSTS-FILE
               ASSIGN TO DATABASE-CUSTS
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY.

           SELECT SLMEN-FILE
               ASSIGN TO DATABASE-SLMEN
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY
                                      WITH DUPLICATES.

           SELECT ORDSTS-FILE
               ASSIGN TO DATABASE-ORDSTS
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY.

           SELECT CUSFL3-FILE
               ASSIGN TO DATABASE-CUSFL3
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY.

       DATA DIVISION.
       FILE SECTION.

       FD  DISPLAY-FILE
           LABEL RECORDS STANDARD.
       01  DISPLAY-REC.
           COPY  DDS-ALL-FORMATS  OF  WCONHDRD
              REPLACING XWCREF BY SCR-CUSREF
                        XWSTAT BY SCR-STATUS.

       FD  CONHDR-FILE
           LABEL RECORDS ARE STANDARD.
       01  CONHDR-RECORD.
           COPY DDS-CONHDRR       OF  CONHDR.

       FD  CONHDRL1-FILE
           LABEL RECORDS ARE STANDARD.
       01  CONHDRL1-RECORD.
           COPY DDS-CONHDRR       OF  CONHDRL1.

       FD  CUSTS-FILE
           LABEL RECORDS ARE STANDARD.
       01  CUSTS-RECORD.
           COPY DDS-CUSTSR        OF  CUSTS.

       FD  SLMEN-FILE
           LABEL RECORDS ARE STANDARD.
       01  SLMEN-RECORD.
           COPY DDS-RSLMEN        OF  SLMEN.

       FD  ORDSTS-FILE
           LABEL RECORDS ARE STANDARD.
       01  ORDSTS-RECORD.
           COPY DDS-STATUSR       OF  ORDSTS.

       FD  CUSFL3-FILE
           LABEL RECORDS ARE STANDARD.
       01  CUSFL3-RECORD.
           COPY DDS-RCUSF         OF  CUSFL3.

       WORKING-STORAGE SECTION.
       01  ONE                         PIC 1 VALUE B"1".
       01  MSGID                       PIC X(7).
       01  WS-ERRMSG                   PIC X(132).
       01  WS-PAGENO                   PIC S9(2).
       01  WS-NO-OF-PAGES              PIC S9(2) VALUE 2.
       01  CONHDR-FILE-STATUS          PIC X(2) VALUE SPACES.
       01  WS-VARIABLES.
           02  WS-ERROR                PIC X   VALUE SPACE.
           02  NO-ERR-SFL              PIC X   VALUE SPACE.
           02  WS-STATUS               PIC X   VALUE SPACE.
           02  RECNO                   PIC 99 VALUE 0.
           02  RECORD-FOUND-SFL        PIC X VALUE SPACES.
           02  RECORD-FOUND-CUSTS      PIC X VALUE SPACES.
           02  RECORD-FOUND-SLMEN      PIC X VALUE SPACES.
           02  RECORD-FOUND-ORDSTS     PIC X VALUE SPACES.
           02  RECORD-FOUND            PIC X VALUE SPACES.
           02  RECORD-PROCESS          PIC X VALUE SPACES.
           02  RECORD-FOUND-CUSFL3     PIC X VALUE SPACES.
           02  RECORD-FOUND-CONHDR     PIC X VALUE SPACES.
           02  RECORD-FOUND-CONHDRL1   PIC X VALUE SPACES.
       01  WS-XWG4TX                   PIC X(40).

       01  WS-FLAGS.
           02  SFL-STATUS PIC XX.
              88 SFL-FULL VALUE "9M".
           02  INDIC-ON      PIC 1 VALUE B"1".
           02  INDIC-OFF     PIC 1 VALUE B"0".

       01  WS-CONSTANTS.
           02  MAX-SFL-RECORDS  PIC 99 VALUE 50.
           02  NEW-LINES        PIC 99 VALUE 5.

      *01  WS-NEW-CONSTANTS.
      *    02  NEW-SFL-RECORDS  PIC 99 VALUE 50.

       01  WS-OPR-SWITCH.
           02  OPR-SW1                  PIC 1  VALUE B"0".
               88  CHANGE-MODE          VALUE B"1".
               88  CHANGE-MODE-OFF      VALUE B"0".

       01  WS-INDIC-AREA.
           02  IN03                    PIC 1  INDIC 03.
               88  EXIT-KEY            VALUE B"1".
           02  IN04                    PIC 1  INDIC 04.
               88  PROMPT-F4           VALUE B"1".
           02  IN06                    PIC 1  INDIC 06.
               88  ADD-MODE            VALUE B"1".
           02  IN07                    PIC 1  INDIC 07.
               88  DTL-LINE            VALUE B"1".
           02  IN12                    PIC 1  INDIC 12.
               88  CANCEL-KEY          VALUE B"1".
           02  IN23                    PIC 1  INDIC 23.
               88  DELETE-F23          VALUE B"1".
           02  IN25                    PIC 1  INDIC 25.
               88  ROLLUP-KEY          VALUE B"1".
           02  IN26                    PIC 1  INDIC 26.
               88  ROLLDOWN-KEY        VALUE B"1".
           02  IN31                    PIC 1  INDIC 31.
               88  SUBFILE-END         VALUE B"1".
           02  IN71                    PIC 1  INDIC 71.
               88  SUBFILE-DSP         VALUE B"1".
           02  IN72                    PIC 1  INDIC 72.
               88  SUBFILE-CTL         VALUE B"1".
           02  IN74                    PIC 1  INDIC 74.
               88  SUBFILE-CLEAR       VALUE B"1".
               88  SUBFILE-CLEAR-NOT   VALUE B"0".

       01  SCRN-CONTROL.
           02 FUNCT       PIC XX.
           02 DEVICEFILE  PIC X(10).
           02 RECFORMAT   PIC X(10).

       LINKAGE SECTION.
       01  LS-SWBCCD                   PIC X(11).


       PROCEDURE DIVISION
                  USING LS-SWBCCD.

       MAIN-PROCESSING.

           OPEN  INPUT  SLMEN-FILE
                        ORDSTS-FILE
                        CUSFL3-FILE
                        CUSTS-FILE
                        CONHDRL1-FILE
                  I-O   CONHDR-FILE
                        DISPLAY-FILE.

           PERFORM INIT-ROUTINE  THRU  INIT-EXIT.
           PERFORM PROCESS-ROUTINE   THRU  PR-EXIT
                       UNTIL  EXIT-KEY.

       PROGRAM-EXIT.
           PERFORM CLOSE-FILES.
           STOP RUN.

       PROCESS-ROUTINE.
           PERFORM   DISPLAY-SFLCTL-FILE     THRU   DSFCF-EXIT.
           EVALUATE  TRUE
           WHEN  EXIT-KEY
                 CONTINUE
           WHEN  CANCEL-KEY
                 PERFORM INITIALIZE-SFLCTL
           WHEN  ROLLUP-KEY
                      PERFORM  LOAD-FORWARD-FILE
                                THRU  LFMSTF-EXIT
           WHEN  ROLLDOWN-KEY
                      PERFORM  LOAD-BACKWARD-FILE
                                 THRU  LBMSTF-EXIT
           WHEN  OTHER
                 PERFORM BUILD-SUBFILE  THRU  BSFL-EXIT
      *    WHEN  OTHER
      *          PERFORM LOAD-RECORDS  THRU  LRCD-EXIT
           END-EVALUATE.
       PR-EXIT. EXIT.

       LOAD-FORWARD-FILE.
       LFMSTF-EXIT. EXIT.

       LOAD-BACKWARD-FILE.
       LBMSTF-EXIT.  EXIT.

       BUILD-SUBFILE.
           MOVE 0 TO RECNO.
           MOVE LS-SWBCCD TO  XWBCCD OF CONHDRL1-RECORD.
           MOVE "Y" TO RECORD-FOUND-CONHDRL1.
           START CONHDRL1-FILE  KEY NOT < EXTERNALLY-DESCRIBED-KEY
                   INVALID KEY
                       MOVE "N"  TO  RECORD-FOUND-CONHDRL1
                       GO BSFL-EXIT.
           READ  CONHDRL1-FILE   NEXT RECORD
                    AT END
                       MOVE "N"  TO  RECORD-FOUND-CONHDRL1
      *                MOVE "Y"  TO  RECORD-FOUND-CONHDRL1
                       GO BSFL-EXIT.

           IF  RECORD-FOUND-CONHDRL1 = "Y"
               PERFORM CREATE-SFL-FILE    THRU    CSFLF-EXIT
           ELSE
               MOVE  "No Records are available."  TO ZMSAGE OF ZZTR01-O
               GO BSFL-EXIT
           END-IF.
           IF  RECNO > 0
              INITIALIZE  ZZCT01-O
              MOVE CORR CUSTSR TO ZZCT01-O
              MOVE CORR RSLMEN TO ZZCT01-O
              MOVE CORR RCUSF  TO ZZCT01-O
              MOVE PERSON OF CUSTS-RECORD TO  PERCUS
              MOVE PNAME OF SLMEN-RECORD  TO  SNAME OF ZZCT01-O
              MOVE "CBCONHDR" TO ZZPGM OF ZZCT01-O
              PERFORM DISPLAY-SUBFILE  THRU  DSFL-EXIT
                            UNTIL  EXIT-KEY OR CANCEL-KEY
           END-IF.
      ***  MOVE INDIC-OFF TO IN03  OF WS-INDIC-AREA.
       BSFL-EXIT.  EXIT.

       CREATE-SFL-FILE.
           MOVE  0  TO  RECNO.
           MOVE  SPACES  TO  WS-STATUS.
           PERFORM  FILL-SFL-FILE     THRU   FSFLF-EXIT
                    UNTIL  RECORD-FOUND-CONHDRL1 = "N".
       CSFLF-EXIT.   EXIT.

       FILL-SFL-FILE.
           IF  RECNO > MAX-SFL-RECORDS
               MOVE "N"   TO  RECORD-FOUND-CONHDRL1
               GO  FSFLF-EXIT.
           PERFORM  MOVE-CONHDRL1-TO-SFL      THRU   MCTSFL-EXIT.
           ADD  1  TO  RECNO
           PERFORM   WRITE-SUBFILE-RECORD     THRU   WSFLR-EXIT.
           PERFORM   READ-NEXT-CONHDRL1-FILE  THRU   RNDTLF-EXIT.
       FSFLF-EXIT. EXIT.

       DISPLAY-SUBFILE.
           MOVE CORR WS-INDIC-AREA TO ZZCT01-O-INDIC.
           PERFORM    WRITE-READ-SFC      THRU    WRSFC-EXIT.
      **   MOVE CORR ZZCT01-I-INDIC  TO  WS-INDIC-AREA.
      **   MOVE CORR ZZCT02-I-INDIC  TO  WS-INDIC-AREA.
           MOVE  0  TO   RECNO.
           MOVE "Y" TO   RECORD-FOUND-SFL  NO-ERR-SFL.
           EVALUATE  TRUE
             WHEN EXIT-KEY
                CONTINUE
             WHEN CANCEL-KEY
                CONTINUE
             WHEN OTHER
                PERFORM PROCESS-SUBFILE-RECORD  THRU  PSFLR-EXIT
                          UNTIL  RECORD-FOUND-SFL = "N"
                PERFORM  SFL-ACTION-ROUTINE  THRU  SFLACTR-EXIT
           END-EVALUATE.
       DSFL-EXIT.   EXIT.

       PROCESS-SUBFILE-RECORD.
           PERFORM READ-NEXT-SFL-FILE   THRU   RNSFLF-EXIT.
           IF  RECORD-FOUND-SFL = "N"
               GO PSFLR-EXIT.
           EVALUATE  TRUE
             WHEN  DSSEL OF ZZSF01-I = "2"
               SET CHANGE-MODE TO TRUE
               PERFORM CHGREC-ROUTINE  THRU  CHGREC-EXIT
      *      WHEN  DSCPY OF ZZSF01-I = "3"
      *        PERFORM CPYREC-ROUTINE  THRU  CPYREC-EXIT
             WHEN  DSSEL OF ZZSF01-I = "4"
               PERFORM DELREC-ROUTINE  THRU  DELREC-EXIT
             WHEN  DSSEL OF ZZSF01-I = "5"
               PERFORM DSPREC-ROUTINE  THRU  DSPREC-EXIT
             WHEN  DSSEL OF ZZSF01-I = "7"
               MOVE SPACES TO WS-XWG4TX
               PERFORM ZLINES-ROUTINE  THRU  ZLINES-EXIT
           END-EVALUATE.
           MOVE  SPACES TO DSSEL OF ZZSF01-I.
           PERFORM REWRITE-SFL-RECORD   THRU    RWSFLR-EXIT.
       PSFLR-EXIT.   EXIT.

       SFL-ACTION-ROUTINE.
           MOVE  SPACES   TO    NO-ERR-SFL.
      *    IF INQUIRY-MODE     GO  SFLACTP-EXIT.
       SFLACTR-EXIT.  EXIT.

       READ-MODIFIED-SFL-FILE.
      *    READ SUBFILE DISPLAY-FILE NEXT MODIFIED RECORD INTO ZZSF01-I
           READ SUBFILE DISPLAY-FILE NEXT MODIFIED RECORD
                FORMAT "ZZSF01" AT END
                MOVE "N" TO RECORD-FOUND-SFL
                GO RMSFLF-EXIT.
           MOVE  CORR  ZZSF01-I   TO   ZZSF01-O.
       RMSFLF-EXIT.  EXIT.

       WRITE-SUBFILE-RECORD.
           WRITE SUBFILE DISPLAY-REC  FORMAT "ZZSF01"
                 INVALID KEY
                      DISPLAY "PROBLEM IN SUBFILE WRITING-P1 ".
           INITIALIZE  ZZSF01-O  REPLACING ALPHANUMERIC BY SPACES
                                        NUMERIC BY ZEROS.
       WSFLR-EXIT.  EXIT.

       READ-NEXT-SFL-FILE.
           ADD 1 TO RECNO.
           MOVE "Y" TO RECORD-FOUND-SFL.
      *    READ SUBFILE DISPLAY-FILE INTO ZZSF01-I FORMAT "ZZSF01"
           READ SUBFILE DISPLAY-FILE FORMAT "ZZSF01"
             INVALID MOVE "N" TO RECORD-FOUND-SFL
                     GO RNSFLF-EXIT.
      *****MOVE CORR ZZSF01-I     TO   ZZSF01-O.
       RNSFLF-EXIT.   EXIT.

       WRITE-READ-SFC.
           IF SHWREC  OF ZZCT01-O  = 0
             MOVE  1  TO   SHWREC  OF  ZZCT01-O.
           WRITE  DISPLAY-REC  FORMAT "ZZCT01".
           IF IN74 OF ZZCT01-O-INDIC = INDIC-OFF
             READ   DISPLAY-FILE  RECORD
           END-IF
           MOVE CORR ZZCT01-I-INDIC  TO  WS-INDIC-AREA.

           MOVE    SPACES   TO    ZMSAGE OF ZZTR01-O.
      **   MOVE  SFLRRN OF SFLCTL-O TO SFLRCD OF SFLCTL-O.
      **   MOVE  SFLRRN OF SFLCTL-O TO SFLRCD OF SFLCTL-O.

       WRSFC-EXIT.   EXIT.

       REWRITE-SFL-RECORD.
           REWRITE SUBFILE DISPLAY-REC   FORMAT "ZZSF01"
              INVALID KEY DISPLAY "PROBLEM IN SUBFILE REWRITING-P2"
                 MOVE B"1"  TO  IN03 OF  WS-INDIC-AREA
           END-REWRITE.
       RWSFLR-EXIT.  EXIT.

       INIT-ROUTINE.
           MOVE ALL B"0"  TO  WS-INDIC-AREA.
           INITIALIZE  ZZSF01-I  ZZSF01-O  ZZCT01-I  ZZCT01-O
                       ZZTR01-O WS-VARIABLES
              REPLACING NUMERIC BY ZEROS ALPHANUMERIC BY SPACES.
           PERFORM  INITIALIZE-SFLCTL.

           MOVE ZEROS  TO XWORDN OF ZZSF01-O.
           MOVE LS-SWBCCD TO  XWBCCD OF CUSTS-RECORD.
           MOVE "Y" TO RECORD-FOUND-CUSTS
           READ  CUSTS-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CUSTS.

           MOVE CUSNO  OF CUSTS-RECORD  TO  CUSNO OF CUSFL3-RECORD.
           MOVE "Y" TO RECORD-FOUND-CUSFL3
           READ  CUSFL3-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CUSFL3.

           MOVE PERSON OF CUSTS-RECORD TO  PERSON OF SLMEN-RECORD
           READ  SLMEN-FILE
                   INVALID KEY
                       MOVE ALL "-"  TO  PNAME OF SLMEN-RECORD.
       INIT-EXIT.  EXIT.


       CLOSE-FILES.
               CLOSE   CUSTS-FILE
                       DISPLAY-FILE
                       SLMEN-FILE
                       ORDSTS-FILE
                       CUSFL3-FILE
                       CONHDR-FILE
                       CONHDRL1-FILE.

       START-CUSTS-FILE.
           MOVE "Y"  TO RECORD-FOUND-CUSTS.
           START CUSTS-FILE KEY NOT < EXTERNALLY-DESCRIBED-KEY
                 INVALID  MOVE "N" TO RECORD-FOUND-CUSTS.
       SDTLF-EXIT.  EXIT.

       READ-NEXT-CONHDRL1-FILE.
           MOVE "Y"   TO RECORD-FOUND-CONHDRL1.
           READ  CONHDRL1-FILE   NEXT RECORD
              AT END
                   MOVE "N"  TO  RECORD-FOUND-CONHDRL1
                   GO RNDTLF-EXIT.
           IF XWBCCD OF CONHDRL1-RECORD NOT = LS-SWBCCD
               GO READ-NEXT-CONHDRL1-FILE
           END-IF.
       RNDTLF-EXIT. EXIT.

       READ-CUSTS-FILE.
           MOVE "Y"   TO RECORD-FOUND-CUSTS.
           READ  CUSTS-FILE   INVALID
                 MOVE "N"  TO  RECORD-FOUND-CUSTS.
       RDTLF-EXIT. EXIT.

       DISPLAY-SFLCTL-FILE.
           SET SUBFILE-CTL TO TRUE.
           SET SUBFILE-CLEAR TO TRUE.
           WRITE  DISPLAY-REC  FORMAT "ZZTR01".
           MOVE CORR WS-INDIC-AREA   TO  ZZCT01-O-INDIC.
           PERFORM WRITE-READ-SFC    THRU  WRSFC-EXIT.
           MOVE CORR ZZCT01-I-INDIC  TO  WS-INDIC-AREA.
           SET SUBFILE-DSP TO TRUE.
           SET SUBFILE-END TO TRUE.
           SET SUBFILE-CLEAR-NOT TO TRUE.
       DSFCF-EXIT.   EXIT.

       MOVE-CONHDRL1-TO-SFL.
           INITIALIZE  ZZSF01-O.
      *                  REPLACING  ALPHANUMERIC BY SPACES
      *                                   NUMERIC BY ZEROS.
           MOVE XWORDN OF CONHDRL1-RECORD TO XWORDN OF ZZSF01-O.
      *    MOVE XWCREF OF CONHDRL1-RECORD TO XWCREF OF ZZSF01-O.
           MOVE XWCREF OF CONHDRL1-RECORD TO SCR-CUSREF OF ZZSF01-O.
           MOVE XWDLDT OF CONHDRL1-RECORD TO XWDLDT OF ZZSF01-O.
      *    MOVE XWSTAT OF CONHDRL1-RECORD TO XWSTAT OF ZZSF01-O.
           MOVE XWSTAT OF CONHDRL1-RECORD TO SCR-STATUS OF ZZSF01-O.
           MOVE XWTAMT OF CONHDRL1-RECORD TO XWTAMT OF ZZSF01-O.
           MOVE PERSON OF CONHDRL1-RECORD TO PERSON OF ZZSF01-O.
       MCTSFL-EXIT.  EXIT.

       INITIALIZE-SFLCTL.
           INITIALIZE ZZCT01-O.

       CHGREC-ROUTINE.
           MOVE SPACES TO CONHDR-FILE-STATUS.
           MOVE INDIC-OFF  TO   IN34 OF ZZFT01-O-INDIC
                                IN36 OF ZZFT01-O-INDIC
                                IN37 OF ZZFT01-O-INDIC.
           MOVE "UPDATE" TO ACTDSP OF ZZFT01-O.

           MOVE CORR ZZSF01-I  TO  ZZFT01-O

           MOVE XWORDN OF ZZSF01-I  TO  XWORDN OF CONHDR-RECORD.
           MOVE "Y" TO RECORD-FOUND-CONHDR
           READ CONHDR-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CONHDR
                   NOT INVALID KEY
                       MOVE CORR CONHDR-RECORD TO ZZFT01-O.

           IF RECORD-FOUND-CONHDR = "N"
              MOVE  "OES0115" TO MSGID
              CALL "RTNMSGTEXT" USING  MSGID WS-ERRMSG
              MOVE  WS-ERRMSG  TO  ZMSAGE  OF  ZZFT01-O
           ELSE
              IF CONHDR-FILE-STATUS NOT = "00"
                IF CONHDR-FILE-STATUS = "9D"
                   MOVE  "Y3U9999" TO  MSGID
                   CALL "RTNMSGTEXT" USING  MSGID  WS-ERRMSG
                ELSE
                   MOVE  "OEM0004" TO  MSGID
                   CALL "RTNMSGTEXT" USING  MSGID  WS-ERRMSG
                   MOVE  WS-ERRMSG  TO  ZMSAGE  OF  ZZFT01-O
                END-IF
              ELSE
      *         MOVE XWSTAT OF ZZSF01-I  TO  XWSTAT OF ORDSTS-RECORD
                MOVE SCR-STATUS OF ZZSF01-I TO  XWSTAT OF ORDSTS-RECORD
                MOVE "Y" TO RECORD-FOUND-ORDSTS
                READ ORDSTS-FILE
                    INVALID KEY
                        MOVE "N" TO RECORD-FOUND-ORDSTS   END-READ
                MOVE CORR STATUSR  TO ZZFT01-O
                IF RECORD-FOUND-ORDSTS = "N"
                  MOVE ALL "-"  TO  XWSDSC OF ZZFT01-O
                END-IF

                MOVE PERSON OF ZZSF01-I  TO  PERSON OF SLMEN-RECORD
                MOVE "Y" TO RECORD-FOUND-SLMEN
                READ SLMEN-FILE
                    INVALID KEY
                        MOVE "N" TO RECORD-FOUND-SLMEN    END-READ
                MOVE CORR RSLMEN  TO  ZZFT01-O
                IF RECORD-FOUND-SLMEN = "N"
                  MOVE ALL "-"  TO  PNAME  OF ZZFT01-O
                END-IF
              END-IF
           END-IF

           PERFORM DSPSCN-ROUTINE  THRU  DSPSCN-EXIT.
           IF WS-ERROR NOT = "Y"
             MOVE "Y" TO RECORD-FOUND-CONHDR
             READ CONHDR-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CONHDR
             END-READ
             IF RECORD-FOUND-CONHDR = "Y"
                   AND CONHDR-FILE-STATUS = "00"
                MOVE CORR ZZFT01-I  TO CONHDR-RECORD
                REWRITE CONHDR-RECORD
                     INVALID KEY
                       MOVE "Update on CONHDR file Invalid.."
                                              TO ZMSAGE OF ZZFT01-O
                       WRITE DISPLAY-REC FORMAT IS "ZZTR01"
                END-REWRITE
             ELSE
                MOVE "Record is not available for update.."
                                              TO ZMSAGE  OF ZZFT01-O
                WRITE DISPLAY-REC FORMAT IS "ZZTR01"
             END-IF
           END-IF.
           IF NOT EXIT-KEY AND NOT CANCEL-KEY
              MOVE CORR ZZFT01-I  TO  ZZCNF1-O
              WRITE  DISPLAY-REC  FORMAT "ZZCNF1"
              READ   DISPLAY-FILE  RECORD
           END-IF.
       CHGREC-EXIT. EXIT.

       DSPREC-ROUTINE.
           MOVE SPACES TO CONHDR-FILE-STATUS.
           MOVE INDIC-ON   TO   IN34 OF ZZFT01-O-INDIC.
           MOVE INDIC-OFF  TO   IN36 OF ZZFT01-O-INDIC
                                IN37 OF ZZFT01-O-INDIC.
           MOVE "DISPLAY" TO ACTDSP OF ZZFT01-O.

           MOVE CORR ZZSF01-I  TO  ZZFT01-O

           MOVE XWORDN OF ZZSF01-I  TO  XWORDN OF CONHDR-RECORD.
           MOVE "Y" TO RECORD-FOUND-CONHDR
           READ CONHDR-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CONHDR
                   NOT INVALID KEY
                       MOVE CORR CONHDR-RECORD TO ZZFT01-O.

           IF RECORD-FOUND-CONHDR = "N"
              MOVE  "OES0115" TO MSGID
              CALL "RTNMSGTEXT" USING  MSGID WS-ERRMSG
              MOVE  WS-ERRMSG  TO  ZMSAGE  OF  ZZFT01-O
           ELSE
              IF CONHDR-FILE-STATUS = "9D"
                 MOVE  "Y3U9999" TO  MSGID
                 CALL "RTNMSGTEXT" USING  MSGID  WS-ERRMSG
              ELSE
                 MOVE  "OEM0004" TO  MSGID
                 CALL "RTNMSGTEXT" USING  MSGID  WS-ERRMSG
      *-         MOVE  WS-ERRMSG  TO  ZMSAGE  OF  ZZFT01-O
              END-IF
      *       MOVE XWSTAT OF ZZSF01-I  TO  XWSTAT OF ORDSTS-RECORD
              MOVE SCR-STATUS OF ZZSF01-I TO  XWSTAT OF ORDSTS-RECORD
              MOVE "Y" TO RECORD-FOUND-ORDSTS
              READ ORDSTS-FILE
                    INVALID KEY
                        MOVE "N" TO RECORD-FOUND-ORDSTS   END-READ
              MOVE CORR STATUSR  TO ZZFT01-O
              IF RECORD-FOUND-ORDSTS = "N"
                MOVE ALL "-"  TO  XWSDSC OF ZZFT01-O
              END-IF

              MOVE PERSON OF ZZSF01-I  TO  PERSON OF SLMEN-RECORD
              MOVE "Y" TO RECORD-FOUND-SLMEN
              READ SLMEN-FILE
                    INVALID KEY
                        MOVE "N" TO RECORD-FOUND-SLMEN    END-READ
              MOVE CORR RSLMEN  TO  ZZFT01-O
              IF RECORD-FOUND-SLMEN = "N"
                MOVE ALL "-"  TO  PNAME  OF ZZFT01-O
              END-IF
           END-IF

           PERFORM DSPSCN-ROUTINE  THRU  DSPSCN-EXIT.
       DSPREC-EXIT. EXIT.

       DSPSCN-ROUTINE.
           WRITE  DISPLAY-REC  FORMAT "ZZFT01".
       DSPSCN-CONT.
           READ   DISPLAY-FILE  RECORD.
           MOVE CORR ZZFT01-I-INDIC  TO  WS-INDIC-AREA.

           CALL "XBCCLMSG".
           CANCEL "XBCCLMSG".

           EVALUATE TRUE
      *Prompt
      *       WHEN PROMPT-F4
            WHEN IN04 OF ZZFT01-I IS EQUAL TO ONE
               PERFORM  SRPROM-ROUTINE  THRU  SRPROM-EXIT

      *Lines
              WHEN DTL-LINE
                PERFORM ZLINES-ROUTINE  THRU  ZLINES-EXIT
           END-EVALUATE.

           IF EXIT-KEY OR CANCEL-KEY
              GO DSPSCN-EXIT
           END-IF.
           IF CHANGE-MODE
              PERFORM VALIDT-ROUTINE  THRU  VALIDT-EXIT
              IF WS-ERROR = "Y"
                GO DSPSCN-CONT
              ELSE
                GO DSPSCN-EXIT
              END-IF
           END-IF.
           IF DSSEL OF ZZSF01-I = "4"
                GO DSPSCN-EXIT
           END-IF.
           GO DSPSCN-CONT.
       DSPSCN-EXIT. EXIT.

       ZLINES-ROUTINE.
           MOVE XWORDN OF ZZSF01-I  TO  XWORDN OF CONHDR-RECORD.
           MOVE "Y" TO RECORD-FOUND-CONHDR
           READ CONHDR-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CONHDR.
           IF RECORD-FOUND-CONHDR = "Y"
             CALL "CBCONDET"  USING XWORDN OF CONHDR-RECORD
                                    XWBCCD OF CONHDR-RECORD
                                    WS-XWG4TX
             CANCEL "CBCONDET"
           END-IF.
       ZLINES-EXIT. EXIT.

       VALIDT-ROUTINE.
           MOVE SPACE TO WS-ERROR.
           MOVE SPACE TO ZMSAGE OF ZZFT01-O.
           MOVE INDIC-OFF  TO  IN40 OF ZZFT01-O-INDIC
                               IN41 OF ZZFT01-O-INDIC
                               IN42 OF ZZFT01-O-INDIC
                               IN43 OF ZZFT01-O-INDIC.

      * WHEN ADDING, CONTRACT MUST NOT BE ZERO
           IF XWORDN OF ZZFT01-O = ZEROS
              MOVE "Y" TO WS-ERROR
              MOVE INDIC-ON TO IN40 OF ZZFT01-O-INDIC
              MOVE "OEM0010" TO  MSGID
              CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
              GO VALIDT-EXIT
           END-IF

      * WHEN ADDING, CONTRACT MUST NOT EXIST
           IF ADD-MODE
              MOVE XWORDN OF ZZFT01-I  TO  XWORDN OF CONHDR-RECORD
               MOVE "Y" TO RECORD-FOUND
              START CONHDR-FILE KEY EQUAL EXTERNALLY-DESCRIBED-KEY
                   INVALID KEY
                      MOVE "N" TO RECORD-FOUND
              END-START
              IF RECORD-FOUND = "N"
                MOVE INDIC-ON TO IN40 OF ZZFT01-O-INDIC
                MOVE "Y2U0003" TO  MSGID
                CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
                GO VALIDT-EXIT
              END-IF
           END-IF

      * CUSTOMER
           MOVE LS-SWBCCD TO  XWBCCD OF CUSTS-RECORD.
           MOVE "Y" TO RECORD-FOUND-CUSTS
           READ CUSTS-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CUSTS.
           IF RECORD-FOUND-CUSTS = "N"
             MOVE "Y" TO WS-ERROR
             MOVE INDIC-ON TO IN41 OF ZZFT01-O-INDIC
             MOVE "OEM0002" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             MOVE ALL "-"  TO  XWG4TX OF ZZFT01-O
             GO VALIDT-EXIT
           END-IF

      * STATUS
      *    MOVE XWSTAT OF ZZFT01-I  TO  XWSTAT OF ORDSTS-RECORD
           MOVE SCR-STATUS OF ZZFT01-I TO  XWSTAT OF ORDSTS-RECORD
           MOVE "Y" TO RECORD-FOUND-ORDSTS
           READ ORDSTS-FILE
               INVALID KEY
                     MOVE "N" TO RECORD-FOUND-ORDSTS   END-READ
           IF RECORD-FOUND-ORDSTS = "N"
             MOVE "Y" TO WS-ERROR
             MOVE INDIC-ON TO IN42 OF ZZFT01-O-INDIC
             MOVE "OEM0019" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             MOVE ALL "-"  TO  XWSDSC OF ZZFT01-O
             GO VALIDT-EXIT
           END-IF

      * SALESMAN
           MOVE PERSON OF ZZFT01-I  TO  PERSON OF SLMEN-RECORD.
           MOVE "Y" TO RECORD-FOUND-SLMEN.
           READ SLMEN-FILE
                  INVALID KEY
                       MOVE "N" TO RECORD-FOUND-SLMEN.
           IF RECORD-FOUND-SLMEN = "N"
             MOVE "Y" TO WS-ERROR
             MOVE INDIC-ON TO IN43 OF ZZFT01-O-INDIC
             MOVE "OEM0023" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             MOVE ALL "-"  TO  PNAME  OF ZZFT01-O
             GO VALIDT-EXIT
           END-IF.
      *    GO VALIDT-ROUTINE.
       VALIDT-EXIT. EXIT.

       DELREC-ROUTINE.
           MOVE INDIC-OFF  TO   IN36 OF ZZFT01-O-INDIC.
           MOVE INDIC-ON   TO   IN34 OF ZZFT01-O-INDIC
                                IN37 OF ZZFT01-O-INDIC.
           MOVE "DELETE" TO ACTDSP OF ZZFT01-O.

           MOVE CORR ZZSF01-I  TO  ZZFT01-O

           MOVE SPACES TO CONHDR-FILE-STATUS.
           MOVE XWORDN OF ZZSF01-I  TO  XWORDN OF CONHDR-RECORD.
           MOVE "Y" TO RECORD-FOUND-CONHDR
           READ CONHDR-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CONHDR
                   NOT INVALID KEY
                       MOVE CORR CONHDR-RECORD TO ZZFT01-O.

           IF RECORD-FOUND-CONHDR = "N"
              MOVE  "OES0115" TO MSGID
              CALL "RTNMSGTEXT" USING  MSGID WS-ERRMSG
              MOVE  WS-ERRMSG  TO  ZMSAGE  OF  ZZFT01-O
           ELSE
              IF CONHDR-FILE-STATUS = "9D"
                 MOVE  "Y3U9999" TO  MSGID
                 CALL "RTNMSGTEXT" USING  MSGID  WS-ERRMSG
              ELSE
                 MOVE  "OEM0004" TO  MSGID
                 CALL "RTNMSGTEXT" USING  MSGID  WS-ERRMSG
                 MOVE  WS-ERRMSG  TO  ZMSAGE  OF  ZZFT01-O
              END-IF

           END-IF

           PERFORM DSPSCN-ROUTINE  THRU  DSPSCN-EXIT.

           IF DELETE-F23
              MOVE CORR ZZFT01-I  TO  ZZCNF1-O
      ******* WRITE  DISPLAY-REC  FORMAT "ZZCNF1"
      ******* READ   DISPLAY-FILE  RECORD
              MOVE CORR ZZCNF1-I-INDIC  TO  WS-INDIC-AREA
              DELETE CONHDR-FILE
                  INVALID
                      MOVE "Unable to delete CONHDR file.."
                                    TO ZMSAGE OF ZZCNF1-O
      ************    WRITE DISPLAY-REC FORMAT "ZZCNF1"
              END-DELETE
           END-IF.
       DELREC-EXIT. EXIT.

       SRPROM-ROUTINE.
           EVALUATE TRUE
              WHEN SFIELD OF ZZFT01-I = "XWBCCD"
                 CALL "CUSTSSEL"  USING XWBCCD OF ZZFT01-I
                                        XWG4TX OF ZZFT01-O
                 CANCEL "CUSTSSEL"

              WHEN SFIELD OF ZZFT01-I = "XWSTAT"
                 CALL "ORDSTSEL"  USING SCR-STATUS OF ZZSF01-I
                                        XWSDSC OF ZZFT01-O
                 CANCEL "ORDSTSEL"

              WHEN SFIELD OF ZZFT01-I = "PERSON"
                 CALL "SLMENSEL"  USING PERSON OF ZZFT01-I
                                        PNAME  OF ZZFT01-O
                 CANCEL "SLMENSEL"

           END-EVALUATE.
       SRPROM-EXIT.  EXIT.
````
