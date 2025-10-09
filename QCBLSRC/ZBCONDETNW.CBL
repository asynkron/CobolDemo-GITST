       PROCESS DATETIME.
       IDENTIFICATION DIVISION.
       PROGRAM-ID.     CBCONDET.
       AUTHOR.         Databorough India.
       DATE-WRITTEN.   25 MAR. 2009.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-AS400.
       OBJECT-COMPUTER. IBM-AS400.
       SPECIAL-NAMES. LOCAL-DATA IS LOCALDATA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT DISPLAY-FILE
               ASSIGN TO WORKSTATION-WCONDETD
               ORGANIZATION TRANSACTION
               ACCESS MODE DYNAMIC
               RELATIVE KEY RECNO
               FILE STATUS IS SFL-STATUS
               CONTROL-AREA SCRN-CONTROL.

           SELECT CONDET-FILE
               ASSIGN TO DATABASE-CONDET
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY
               FILE STATUS IS CONDET-FILE-STATUS.

           SELECT CUSTS-FILE
               ASSIGN TO DATABASE-CUSTS
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY.

           SELECT STKMAS-FILE
               ASSIGN TO DATABASE-STKMAS
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY.

           SELECT STOMAS-FILE
               ASSIGN TO DATABASE-STOMAS
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY.

           SELECT STKBAL-FILE
               ASSIGN TO DATABASE-STKBAL
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY.

           SELECT CONHDR-FILE
               ASSIGN TO DATABASE-CONHDR
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

           SELECT TRNTYP-FILE
               ASSIGN TO DATABASE-TRNTYP
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY.

           SELECT CONDET-REPORT
              ASSIGN TO PRINTER-QPRINT
              ORGANIZATION IS SEQUENTIAL
              ACCESS MODE  IS SEQUENTIAL
              FILE STATUS  IS FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.

       FD  DISPLAY-FILE
           LABEL RECORDS STANDARD.
       01  DISPLAY-REC.
           COPY  DDS-ALL-FORMATS  OF  WCONDETD.

       FD  CONDET-FILE
           LABEL RECORDS ARE STANDARD.
       01  CONDET-RECORD.
           COPY DD-CONDETR     OF  CONDETNW.

       FD  CUSTS-FILE
           LABEL RECORDS ARE STANDARD.
       01  CUSTS-RECORD.
           COPY DDS-CUSTSR     OF  CUSTS.

       FD  STKMAS-FILE
           LABEL RECORDS ARE STANDARD.
       01  STKMAS-RECORD.
           COPY DDS-STKMASR    OF  STKMAS.

       FD  STOMAS-FILE
           LABEL RECORDS ARE STANDARD.
       01  STOMAS-RECORD.
           COPY DDS-STOMASR    OF  STOMAS.

       FD  STKBAL-FILE
           LABEL RECORDS ARE STANDARD.
       01  STKBAL-RECORD.
           COPY DDS-STKBALR    OF  STKBAL.

       FD  CONHDR-FILE
           LABEL RECORDS ARE STANDARD.
       01  CONHDR-RECORD.
           COPY DDS-CONHDRR    OF  CONHDR.

       FD  SLMEN-FILE
           LABEL RECORDS ARE STANDARD.
       01  SLMEN-RECORD.
           COPY DDS-RSLMEN     OF  SLMEN.

       FD  ORDSTS-FILE
           LABEL RECORDS ARE STANDARD.
       01  ORDSTS-RECORD.
           COPY DDS-STATUSR    OF  ORDSTS.

       FD  TRNTYP-FILE
           LABEL RECORDS ARE STANDARD.
       01  TRNTYP-RECORD.
           COPY DDS-TRNTYPR    OF  TRNTYP.

       FD  CONDET-REPORT
           LABEL RECORDS ARE OMITTED.
       01  FD-CONDETPRN-RECORD      PIC X(132).


       WORKING-STORAGE SECTION.
       01  FILE-STATUS                            PIC X(2).
       01  MSGID                       PIC X(7).
       01  WS-ERRMSG                   PIC X(132).
       01  WS-PAGENO                   PIC S9(2).
       01  WS-NO-OF-PAGES              PIC S9(2) VALUE 2.
       01  CONDET-FILE-STATUS          PIC X(2) VALUE SPACES.
       01  WS-VARIABLES.
           02  WS-ERROR                PIC X VALUE SPACE.
           02  WS-STATUS               PIC X VALUE SPACE.
           02  RECNO                   PIC 99 VALUE 0.
           02  RECORD-FOUND-SFL        PIC X VALUE SPACES.
           02  RECORD-FOUND-CUSTS      PIC X VALUE SPACES.
           02  RECORD-FOUND-DISTS      PIC X VALUE SPACES.
           02  RECORD-FOUND-SLMEN      PIC X VALUE SPACES.
           02  RECORD-FOUND-ORDSTS     PIC X VALUE SPACES.
           02  RECORD-FOUND            PIC X VALUE SPACES.
           02  RECORD-PROCESS          PIC X VALUE SPACES.
           02  RECORD-FOUND-TRNTYP     PIC X VALUE SPACES.
           02  RECORD-FOUND-CONHDR     PIC X VALUE SPACES.
           02  RECORD-FOUND-CONDET     PIC X VALUE SPACES.

       01  WS-FLAGS.
           02  SFL-STATUS PIC XX.
              88 SFL-FULL VALUE "9M".
           02  INDIC-ON      PIC 1 VALUE B"1".
           02  INDIC-OFF     PIC 1 VALUE B"0".

       01  WS-CONSTANTS.
           02  MAX-SFL-RECORDS  PIC 99 VALUE 50.
           02  NEW-LINES        PIC 99 VALUE 5.

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
      *    02 RECFORMAT1  PIC X(10).

       LINKAGE SECTION.
       01  LS-XWORDN                   PIC S9(6).
       01  LS-XWBCCD                   PIC X(11).
       01  LS-XWG4TX                   PIC X(40).


       PROCEDURE DIVISION
                  USING LS-XWORDN
                        LS-XWBCCD
                        LS-XWG4TX.

       MAIN-PROCESSING.
           PERFORM OPEN-FILES.
           PERFORM INIT-ROUTINE  THRU  INIT-EXIT.
           PERFORM UNTIL EXIT-KEY
      *‚DISPLAY CONTROL RECORD
           SET SUBFILE-CTL TO TRUE
           SET SUBFILE-CLEAR TO TRUE
           MOVE CORR WS-INDIC-AREA   TO  ZZCT01-O-INDIC
      *    MOVE CORB WS-INDIC-AREA   TO  ZZCT02-O-INDIC
           IF SHWREC  OF ZZCT01-O  = 0
      *      MOVE  2  TO   SHWREC  OF  ZZCT01-O
             MOVE  1  TO   SHWREC  OF  ZZCT01-O
           END-IF
           WRITE  DISPLAY-REC  FORMAT "ZZCT01"
           IF IN74 OF ZZCT01-O-INDIC = INDIC-OFF
             READ   DISPLAY-FILE  RECORD
           END-IF
           MOVE CORR ZZCT01-I-INDIC  TO  WS-INDIC-AREA

           MOVE    SPACES   TO    ZMSAGE OF ZZTR01-O
           MOVE CORR ZZCT01-I-INDIC  TO  WS-INDIC-AREA
           SET SUBFILE-DSP TO TRUE
           SET SUBFILE-END TO TRUE
           SET SUBFILE-CLEAR-NOT TO TRUE

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
           END-EVALUATE

           END-PERFORM.

       PROGRAM-EXIT.
           PERFORM CLOSE-FILES.
           STOP RUN.

      *PROCESS-ROUTINE.
       PR-EXIT. EXIT.

       LOAD-FORWARD-FILE.
       LFMSTF-EXIT. EXIT.

       LOAD-BACKWARD-FILE.
       LBMSTF-EXIT.  EXIT.

       BUILD-SUBFILE.
           MOVE 0 TO RECNO.
           MOVE LS-XWORDN TO CON-CONTRACT-NUMBER OF CONDET-RECORD.
           MOVE "Y" TO RECORD-FOUND-CONDET.
           START CONDET-FILE  KEY NOT < EXTERNALLY-DESCRIBED-KEY
                   INVALID
                       MOVE "N"  TO  RECORD-FOUND-CONDET
                       GO BSFL-EXIT.
           READ  CONDET-FILE   NEXT RECORD
                    AT END
                       MOVE "N"  TO  RECORD-FOUND-CONDET
                       GO BSFL-EXIT.

           IF  RECORD-FOUND-CONDET = "Y"
               PERFORM CREATE-SFL-FILE  THRU  CSFLF-EXIT
           ELSE
               MOVE  "No Records are available."  TO ZMSAGE OF ZZTR01-O
               GO BSFL-EXIT
           END-IF.
           IF  RECNO > 0
              INITIALIZE  ZZCT01-O
              MOVE CORR CONHDRR TO ZZCT01-O
              MOVE CORR CUSTSR  TO ZZCT01-O
              MOVE CORR RSLMEN  TO ZZCT01-O
              MOVE "CBCONDET" TO ZZPGM OF ZZCT01-O
      *       MOVE "CBCONDETB" TO ZZPGM OF ZZCT01-O
              PERFORM DISPLAY-SUBFILE  THRU  DSFL-EXIT
                            UNTIL  EXIT-KEY OR CANCEL-KEY
           END-IF.
       BSFL-EXIT.  EXIT.

       CREATE-SFL-FILE.
           MOVE 0  TO  RECNO.
           MOVE SPACES  TO  WS-STATUS.
           PERFORM FILL-SFL-FILE  THRU  FSFLF-EXIT
                    UNTIL RECORD-FOUND-CONDET = "N".
       CSFLF-EXIT. EXIT.

       FILL-SFL-FILE.
           IF  RECNO > MAX-SFL-RECORDS
               MOVE "N"   TO  RECORD-FOUND-CONDET
               GO  FSFLF-EXIT.
           PERFORM MOVE-CONDET-TO-SFL  THRU  MCTSFL-EXIT.
           MOVE CON-PRODUCT-DETAILS  OF  CONDET-RECORD
                            TO XWABCD OF STKMAS-RECORD.
           READ STKMAS-FILE
                 INVALID KEY
                     MOVE ALL "-" TO XWHLTX OF ZZSF01-O
                 NOT INVALID KEY
                     MOVE CORR STKMASR TO ZZSF01-O
           END-READ
           ADD  1  TO  RECNO
           PERFORM WRITE-SUBFILE-RECORD   THRU  WSFLR-EXIT.
           PERFORM READ-NEXT-CONDET-FILE  THRU  RNDTLF-EXIT.
       FSFLF-EXIT. EXIT.

       DISPLAY-SUBFILE.
           MOVE CORR WS-INDIC-AREA TO ZZCT01-O-INDIC.
           PERFORM    WRITE-READ-SFC      THRU    WRSFC-EXIT.
           MOVE  0  TO   RECNO.
           MOVE "Y" TO   RECORD-FOUND-SFL.
           EVALUATE  TRUE
             WHEN EXIT-KEY
                CONTINUE
             WHEN CANCEL-KEY
                CONTINUE
             WHEN OTHER
                PERFORM PROCESS-SUBFILE-RECORD  THRU  PSFLR-EXIT
                          UNTIL  RECORD-FOUND-SFL = "N"
           END-EVALUATE.
       DSFL-EXIT.   EXIT.

       PROCESS-SUBFILE-RECORD.
           PERFORM READ-NEXT-SFL-FILE   THRU   RNSFLF-EXIT.
           IF  RECORD-FOUND-SFL = "N"
               GO PSFLR-EXIT.
           EVALUATE  TRUE
             WHEN  DSSEL OF ZZSF01-I = "2"
               PERFORM CHGREC-ROUTINE  THRU  CHGREC-EXIT
             WHEN  DSSEL OF ZZSF01-I = "4"
               PERFORM DELREC-ROUTINE  THRU  CHGREC-EXIT
             WHEN  DSSEL OF ZZSF01-I = "5"
               PERFORM DSPREC-ROUTINE  THRU  DSPREC-EXIT
           END-EVALUATE.
           MOVE  SPACES TO DSSEL OF ZZSF01-I.
      **   PERFORM SFL-REWRITE-PARA     THRU    SFLRWP-EXIT.
           PERFORM REWRITE-SFL-RECORD   THRU    RWSFLR-EXIT.
       PSFLR-EXIT.   EXIT.

       SFL-REWRITE-PARA.
      *    IF  DSSEL OF ZZSF01-I = "D"
      *        MOVE 0 TO SFLSL OF SFL-O
      *    ENDIF.
       SFL-WRITE-PARA.
      *    IF  DSSEL OF ZZSF02-I = "D"
      *        MOVE 0 TO SFLSL OF SFL-D
      *    ENDIF.
       SFLRWP-EXIT.  EXIT.

       READ-MODIFIED-SFL-FILE.
      *    READ SUBFILE DISPLAY-FILE NEXT MODIFIED RECORD INTO ZZSF01-I
           READ SUBFILE DISPLAY-FILE NEXT MODIFIED RECORD
                FORMAT "ZZSF01" AT END
                MOVE "N" TO RECORD-FOUND-SFL
      *         MOVE "Y" TO RECORD-FOUND-SFL
                GO RMSFLF-EXIT.
           MOVE  CORR  ZZSF01-I   TO   ZZSF01-O.
       RMSFLF-EXIT.  EXIT.

       WRITE-SUBFILE-RECORD.
           WRITE SUBFILE DISPLAY-REC  FORMAT "ZZSF01"
                 INVALID KEY
                      DISPLAY "PROBLEM IN SUBFILE WRITING-P1 ".
           INITIALIZE  ZZSF01-O.
       WSFLR-EXIT.  EXIT.

       READ-NEXT-SFL-FILE.
           ADD 1 TO RECNO.
           MOVE "Y" TO RECORD-FOUND-SFL.
           READ SUBFILE DISPLAY-FILE FORMAT "ZZSF01"
             INVALID MOVE "N" TO RECORD-FOUND-SFL
                     GO RNSFLF-EXIT.
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
           PERFORM  INITIALIZE-SFLCTL.
           MOVE "CBCONDET" TO ZZPGM OF ZZCT01-O.
           ACCEPT ZZDATE OF ZZCT01-O FROM DATE.

           MOVE LS-XWORDN  TO  XWORDN OF CONHDR-RECORD.
           MOVE "Y" TO RECORD-FOUND-CONHDR
           READ  CONHDR-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CONHDR.

      *‚Customer
           MOVE XWBCCD OF CONHDR-RECORD  TO  XWBCCD OF CUSTS-RECORD.
           MOVE "Y" TO RECORD-FOUND-CUSTS
           READ  CUSTS-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CUSTS.
           IF RECORD-FOUND-CUSTS = "N"
              MOVE ALL "-" TO  XWG4TX OF ZZCT01-O
      *       MOVE ALL "-" TO  XWG4TX OF CUSTS-RECORD.

      *‚Representative
           MOVE PERSON OF CONHDR-RECORD TO  PERSON OF SLMEN-RECORD
           MOVE "Y" TO RECORD-FOUND-SLMEN
           READ  SLMEN-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-SLMEN.
           IF RECORD-FOUND-SLMEN = "N"
              MOVE ALL "-"  TO  PNAME OF SLMEN-RECORD.

      *‚Status
           MOVE XWSTAT OF CONHDR-RECORD  TO  XWSTAT OF ORDSTS-RECORD.
           MOVE "Y" TO RECORD-FOUND-ORDSTS
           READ  ORDSTS-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-ORDSTS.
           IF RECORD-FOUND-ORDSTS = "N"
              MOVE ALL "-"  TO  XWSDSC OF ORDSTS-RECORD.
       INIT-EXIT.  EXIT.

       OPEN-FILES.
               OPEN  INPUT  CUSTS-FILE
                            STKMAS-FILE
                            STOMAS-FILE
                            STKBAL-FILE
                            CONHDR-FILE
                            SLMEN-FILE
                            ORDSTS-FILE
                            TRNTYP-FILE
                     I-O    CONDET-FILE
                            DISPLAY-FILE
                     OUTPUT CONDET-REPORT.

       CLOSE-FILES.
               CLOSE   CUSTS-FILE
                       STKMAS-FILE
                       STOMAS-FILE
                       STKBAL-FILE
                       DISPLAY-FILE
                       SLMEN-FILE
                       ORDSTS-FILE
                       TRNTYP-FILE
                       CONHDR-FILE
                       CONDET-FILE
                       CONDET-REPORT.

       START-CUSTS-FILE.
           MOVE "Y"  TO RECORD-FOUND-CUSTS.
           START CUSTS-FILE KEY NOT < EXTERNALLY-DESCRIBED-KEY
                 INVALID  MOVE "N" TO RECORD-FOUND-CUSTS.
       SDTLF-EXIT.  EXIT.

       READ-NEXT-CONDET-FILE.
           MOVE "Y"   TO RECORD-FOUND-CONDET.
           READ  CONDET-FILE   NEXT RECORD
              AT END
                   MOVE "N"  TO  RECORD-FOUND-CONDET
                   GO RNDTLF-EXIT.
           IF CON-CONTRACT-NUMBER OF CONDET-RECORD NOT = LS-XWORDN
               GO READ-NEXT-CONDET-FILE
           END-IF.
       RNDTLF-EXIT. EXIT.

       READ-CUSTS-FILE.
           MOVE "Y"   TO RECORD-FOUND-CUSTS.
           READ  CUSTS-FILE   INVALID
                 MOVE "N"  TO  RECORD-FOUND-CUSTS.
       RDTLF-EXIT. EXIT.

      *DISPLAY-SFLCTL-FILE.
      *DSFCF-EXIT.   EXIT.

       MOVE-CONDET-TO-SFL.
           INITIALIZE  ZZSF01-O
      *                  REPLACING  ALPHANUMERIC BY SPACES
      *                                   NUMERIC BY ZEROS.
           MOVE CORR CONDETR TO ZZSF01-O.
           MOVE CON-PRODUCT-DETAILS  OF  CONDET-RECORD
                     TO  SWABCD OF ZZSF01-O.
           MOVE CON-REFERENCE-NUMBER  OF  CONDET-RECORD
                            TO SWT8TX OF ZZSF01-O.
       MCTSFL-EXIT.  EXIT.

       INITIALIZE-SFLCTL.
           INITIALIZE ZZCT01-O.

       CHGREC-ROUTINE.
           MOVE "UPDATE" TO ACTDSP OF ZZFT01-O.
           MOVE CORR ZZSF01-I  TO  ZZFT01-O
           PERFORM DSPSCN-ROUTINE  THRU  DSPSCN-EXIT.
           IF WS-ERROR NOT = "Y"
             MOVE "Y" TO RECORD-FOUND-CONHDR
             READ CONHDR-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CONHDR
             END-READ
             IF RECORD-FOUND-CONHDR = "Y"
      *            AND CONHDR-FILE-STATUS = "00"
                MOVE CORR ZZFT01-I  TO CONHDR-RECORD
                REWRITE CONHDR-RECORD
                     INVALID KEY
                       MOVE "Update on CONHDR file Invalid.."
                                           TO ZMSAGE OF ZZTR01-O
                       WRITE DISPLAY-REC FORMAT IS "ZZTR01"
                END-REWRITE
             ELSE
                MOVE "Record is not available for update.."
                                           TO ZMSAGE OF ZZTR01-O
                WRITE DISPLAY-REC FORMAT IS "ZZTR01"
             END-IF
           END-IF.
       CHGREC-EXIT. EXIT.

       DSPREC-ROUTINE.
           MOVE SPACES TO CONDET-FILE-STATUS.
           MOVE INDIC-ON  TO IN34 OF ZZFT01-O-INDIC.
           MOVE INDIC-OFF TO IN37 OF ZZFT01-O-INDIC.
           MOVE "DISPLAY" TO ACTDSP OF ZZFT01-O.
           MOVE CORR ZZSF01-I TO ZZFT01-O
           PERFORM GETREC-ROUTINE  THRU  GETREC-EXIT.
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
      *‚Prompt
      *       WHEN PROMPT-F4

      *‚Lines
              WHEN DTL-LINE
                PERFORM ZLINES-ROUTINE  THRU  ZLINES-EXIT
           END-EVALUATE.

           IF EXIT-KEY OR CANCEL-KEY
              GO DSPSCN-EXIT
           END-IF.
           IF DSSEL OF ZZSF01-I = "2"
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
      *    IF DSOPT OF ZZSF01-I = "A"
      *         GO DSPADD-EXIT
      *    END-IF.
           GO DSPSCN-CONT.
       DSPSCN-EXIT. EXIT.

       ZLINES-ROUTINE.
           IF RECORD-FOUND-CONHDR = "Y"
             CALL "WWCONDET"  USING XWORDN OF CONHDR-RECORD
                                    XWBCCD OF ZZCT01-O
                                    XWG4TX OF ZZCT01-O
             CANCEL "WWCONDET"
           END-IF.
       ZLINES-EXIT. EXIT.

       VALIDT-ROUTINE.
           MOVE SPACE TO WS-ERROR.
           MOVE SPACE TO ZMSAGE OF ZZFT01-O.

      * WHEN ADDING, CONTRACT MUST NOT BE ZERO
           IF XWORDN OF ZZFT01-O = ZEROS
              MOVE "Y" TO WS-ERROR
              MOVE "OEM0010" TO  MSGID
              CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
              GO VALIDT-EXIT
           END-IF

      * WHEN ADDING, CONTRACT MUST NOT EXIST
           IF ADD-MODE
              START CONHDR-FILE KEY EQUAL EXTERNALLY-DESCRIBED-KEY
                   INVALID KEY
                      MOVE "N" TO RECORD-FOUND
              END-START
              IF RECORD-FOUND = "N"
                MOVE "Y" TO WS-ERROR
                MOVE "Y2U0003" TO  MSGID
                CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
                GO VALIDT-EXIT
              END-IF
           END-IF

      * CUSTOMER
           MOVE "Y" TO RECORD-FOUND-CUSTS
           READ CUSTS-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CUSTS.
           IF RECORD-FOUND-CUSTS = "N"
             MOVE "Y" TO WS-ERROR
             MOVE "OEM0002" TO  MSGID
      *      MOVE "OEM0402" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             MOVE ALL "-"  TO  XWG4TX OF ZZFT01-O
             GO VALIDT-EXIT
           END-IF

      * STATUS
           MOVE "Y" TO RECORD-FOUND-ORDSTS
           READ ORDSTS-FILE
               INVALID KEY
                     MOVE "N" TO RECORD-FOUND-ORDSTS   END-READ
           IF RECORD-FOUND-ORDSTS = "N"
             MOVE "OEM0019" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             GO VALIDT-EXIT
           END-IF

      * SALESMAN
           MOVE "Y" TO RECORD-FOUND-SLMEN.
           READ SLMEN-FILE
                  INVALID KEY
                       MOVE "N" TO RECORD-FOUND-SLMEN.
           IF RECORD-FOUND-SLMEN = "N"
             MOVE "Y" TO WS-ERROR
             MOVE "OEM0023" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             GO VALIDT-EXIT
           END-IF
           GO VALIDT-ROUTINE.
       VALIDT-EXIT. EXIT.

       DELREC-ROUTINE.
           MOVE "DELETE" TO ACTDSP OF ZZFT01-O.

           MOVE CORR ZZSF01-I  TO  ZZFT01-O

           MOVE "Y" TO RECORD-FOUND-CONHDR
           READ CONHDR-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CONHDR
                   NOT INVALID KEY
                       MOVE CORR CONHDR-RECORD TO ZZFT01-O.

           IF RECORD-FOUND-CONHDR = "N"
      *       MOVE  "OES0100" TO MSGID
              MOVE  "OES0115" TO MSGID
              CALL "RTNMSGTEXT" USING  MSGID WS-ERRMSG
              MOVE  WS-ERRMSG  TO  ZMSAGE  OF  ZZFT01-O
           END-IF

           PERFORM DSPSCN-ROUTINE  THRU  DSPSCN-EXIT.

           IF DELETE-F23
              MOVE CORR ZZFT01-I  TO  ZZCNF1-O
              WRITE  DISPLAY-REC  FORMAT "ZZCNF1"
              READ   DISPLAY-FILE  RECORD
              MOVE CORR ZZCNF1-I-INDIC  TO  WS-INDIC-AREA
              DELETE CONHDR-FILE
                  INVALID
                    DISPLAY "Unable to delete CONHDR file.."
              END-DELETE
           END-IF.
       DELREC-EXIT. EXIT.

       GETREC-ROUTINE.
           MOVE XWORDN OF ZZCT01-O  TO
                        CON-CONTRACT-NUMBER OF CONDET-RECORD.
           MOVE XWABCD OF ZZSF01-I
                      TO CON-PRODUCT-DETAILS OF CONDET-RECORD.
           MOVE "Y" TO RECORD-FOUND-CONDET
           READ CONDET-FILE
                   INVALID KEY
                       MOVE "N" TO RECORD-FOUND-CONDET.
           IF RECORD-FOUND-CONDET = "N"
              MOVE  "OES0115" TO MSGID
              CALL "RTNMSGTEXT" USING  MSGID WS-ERRMSG
              MOVE  WS-ERRMSG  TO  ZMSAGE  OF  ZZFT01-O
           ELSE
             IF RECORD-FOUND-CONDET NOT = "00"
                IF CONDET-FILE-STATUS = "9D"
                   MOVE  "Y3U9999" TO  MSGID
                   CALL "RTNMSGTEXT" USING  MSGID  WS-ERRMSG
                ELSE
      *            MOVE  "OEM0005" TO  MSGID
                   MOVE  "OEM0004" TO  MSGID
                   CALL "RTNMSGTEXT" USING  MSGID  WS-ERRMSG
                   MOVE  WS-ERRMSG  TO  ZMSAGE  OF  ZZFT01-O
                END-IF
             ELSE
                PERFORM VALIDT-ROUTINE  THRU  VALIDT-EXIT
             END-IF
           END-IF.
       GETREC-EXIT. EXIT.

