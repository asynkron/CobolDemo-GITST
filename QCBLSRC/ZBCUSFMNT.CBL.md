# ZBCUSFMNT.CBL Member Guide

## Overview
COBOL program `ZBCUSFMNT` encapsulates business logic within the COBOL layer.

## Dependency Map
- **Incoming:** CL or command drivers that call COBOL program `ZBCUSFMNT`.
- **Outgoing:**
  - Accesses files: CUSFL3, DISPLAY, DISTS
  - Calls programs: CUSFSEL, DSPDISTS, RTNMSGTEXT, WWCCONS, WWRAREAS
  - Includes copybooks: DDS

## Source
````cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID.     CBCUSFMNT.
       AUTHOR.         Databorough India.
       DATE-WRITTEN.   26 MAR. 2009.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-AS400.
       OBJECT-COMPUTER. IBM-AS400.
       SPECIAL-NAMES. LOCAL-DATA IS LOCALDATA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT DISPLAY-FILE
               ASSIGN TO WORKSTATION-CUSFMAINTD
               ORGANIZATION TRANSACTION
               FILE STATUS IS DISPLAY-STATUS
               CONTROL-AREA SCRN-CONTROL.

           SELECT CUSFL3-FILE
               ASSIGN TO DATABASE-CUSFL3
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY.

           SELECT DISTS-FILE
               ASSIGN TO DATABASE-DISTS
               ORGANIZATION IS INDEXED
               ACCESS IS DYNAMIC
               RECORD KEY IS EXTERNALLY-DESCRIBED-KEY
                        WITH DUPLICATES.

       DATA DIVISION.
       FILE SECTION.

       FD  DISPLAY-FILE
           LABEL RECORDS STANDARD.
       01  DISPLAY-REC.
           COPY  DDS-ALL-FORMATS  OF  CUSFMAINTD.

       FD  CUSFL3-FILE
           LABEL RECORDS ARE STANDARD.
       01  CUSFL3-RECORD.
           COPY DDS-RCUSF         OF  CUSFL3.

       FD  DISTS-FILE
           LABEL RECORDS ARE STANDARD.
       01  DISTS-RECORD.
           COPY DDS-RPRODS        OF  DISTS.

       WORKING-STORAGE SECTION.
       01  MSGID                       PIC X(7).
       01  WS-ERRMSG                   PIC X(132).
       01  WS-NO-OF-PAGES              PIC S9(2) VALUE 2.
       01  WS-VARIABLES.
           02  WS-ERROR                PIC X VALUE SPACE.
           02  RECNO                   PIC 99 VALUE 0.
           02  RECORD-FOUND-SFL        PIC X VALUE SPACES.
           02  RECORD-FOUND-DISTS      PIC X VALUE SPACES.
           02  RECORD-FOUND-SLMEN      PIC X VALUE SPACES.
           02  RECORD-FOUND            PIC X VALUE SPACES.
           02  RECORD-PROCESS          PIC X VALUE SPACES.
           02  RECORD-FOUND-CUSFL3     PIC X VALUE SPACES.
           02  RECORD-FOUND-CONHDR     PIC X VALUE SPACES.
       01  WS-XWG4TX                   PIC X(40).
       01  WS-EXIT-MAIN                PIC X(1) VALUE "N".
       01  WS-STATUSES                 PIC X(1).
           88 STATUSES                 VALUE "4" "5" "6" "7" "8" "9".

       01  WS-FLAGS.
           02  DISPLAY-STATUS PIC XX.
              88 SCR-ERR  VALUE "9N".
           02  INDIC-ON      PIC 1 VALUE B"1".
           02  INDIC-OFF     PIC 1 VALUE B"0".

       01  WS-CONSTANTS.
           02  MAX-SFL-RECORDS  PIC 99 VALUE 50.
           02  NEW-LINES        PIC 99 VALUE 5.

       01  WS-OPR-SWITCH.
           02  OPR-SW1                  PIC 1  VALUE B"0".
               88  CHANGE-MODE          VALUE B"1".
               88  CHANGE-MODE-OFF      VALUE B"0".
           02  OPR-SW2                  PIC 1  VALUE B"0".
               88  VALID-OK             VALUE B"1".
               88  VALID-NOT-OK         VALUE B"0".

       01  WS-INDIC-AREA.
           02  IN03                    PIC 1  INDIC 03.
               88  EXIT-KEY            VALUE B"1".
           02  IN12                    PIC 1  INDIC 12.
               88  CANCEL-KEY          VALUE B"1".
           02  IN08                    PIC 1  INDIC 08.
               88  CONTACTS-F08        VALUE B"1".
           02  IN09                    PIC 1  INDIC 09.
               88  DIST-F09            VALUE B"1".
           02  IN10                    PIC 1  INDIC 10.
               88  DLVRY-AREA-F10      VALUE B"1".

       01  SCRN-CONTROL.
           02 FUNCT       PIC XX.
           02 DEVICEFILE  PIC X(10).
           02 RECFORMAT   PIC X(10).

       LINKAGE SECTION.
       01  LS-CUSTOMER                 PIC S9(5) COMP.
       01  LS-UPDATED                  PIC X(1).


       PROCEDURE DIVISION
                  USING LS-CUSTOMER  LS-UPDATED.

       MAIN-PROCESSING.
           PERFORM OPEN-FILES.
           PERFORM INITIAL-RTN  THRU  INITIAL-EXIT.
           PERFORM PROCESS-ROUTINE  THRU  PRC-EXIT
                       UNTIL  EXIT-KEY.

       PROGRAM-EXIT.
           PERFORM CLOSE-FILES.
           STOP RUN.

       PROCESS-ROUTINE.
           MOVE LS-CUSTOMER TO CUSNO OF CUSFL3-RECORD.
           READ CUSFL3-FILE
                  INVALID KEY
                       PERFORM CLOSE-FILES
                       STOP RUN.
      * Set Screen Values
           PERFORM WRITESCN-RTN  THRU WRITESCN-EXIT.
           MOVE "Please make required changes.. "
                                 TO ZMESSAGE.

           PERFORM UNTIL  EXIT-KEY OR CANCEL-KEY
             WRITE  DISPLAY-REC  FORMAT "ZZFT01"
             READ  DISPLAY-FILE  RECORD

             EVALUATE TRUE
               WHEN CONTACTS-F08
                 CALL "WWCCONS"  USING ZCUSNO OF ZZFT01-O
                 CANCEL "WWCCONS"
                 GO PROCESS-ROUTINE
               WHEN DIST-F09
                 CALL "DSPDISTS" USING ZDSDCDE OF ZZFT01-O
                 CANCEL "DSPDISTS"
                 GO PROCESS-ROUTINE
               WHEN DLVRY-AREA-F10
                 CALL "WWRAREAS" USING ZSINIT OF ZZFT01-O
                 CANCEL "WWRAREAS"
                 GO PROCESS-ROUTINE
             END-EVALUATE

             PERFORM VALIDATE-RTN  THRU  VALIDATE-EXIT
             IF VALID-OK
               PERFORM UPDFILE-RTN  THRU  UPDFILE-EXIT
               GO PRC-EXIT
             ELSE
               MOVE WS-ERRMSG TO ZMESSAGE
             END-IF
           END-PERFORM.
       PRC-EXIT. EXIT.

       INITIAL-RTN.
           MOVE "CBCUSFMNT" TO ZZPGM.
      * Protect Customer Number
           MOVE B"1" TO IN31.
      * If Customer number not provided
           IF LS-CUSTOMER = ZEROS
             CALL "CUSFSEL" USING LS-CUSTOMER
           END-IF
      * Initialise updated flag
           MOVE "N" TO LS-UPDATED.
       INITIAL-EXIT.  EXIT.

      *INITIAL-RTN.
      *    MOVE "CBCUSFMNT" TO ZZPGM.
      * Protect Customer Number
      *    MOVE B"1" TO IN31.
      * If Customer number not provided
      * Initialise updated flag
      *    MOVE "N" TO LS-UPDATED.
      *INITIAL-EXIT.  EXIT.

       OPEN-FILES.
               OPEN  INPUT  DISTS-FILE
                     I-O    DISPLAY-FILE
                            CUSFL3-FILE.

       CLOSE-FILES.
               CLOSE   DISPLAY-FILE
                       CUSFL3-FILE
                       DISTS-FILE.

       VALIDATE-RTN.
           MOVE ALL B"0" TO ZZFT01-O-INDIC.
           MOVE B"1" TO IN31.
           SET VALID-OK TO TRUE.
      * Customer name
           IF ZCNAME OF ZZFT01-I = SPACES
             MOVE INDIC-ON TO IN32
             MOVE "OEM0012" TO  MSGID
      *      MOVE "OEM0010" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             SET VALID-NOT-OK TO TRUE
             GO VALIDATE-EXIT
           END-IF
      * Telephone number
           IF ZTELNO OF ZZFT01-I NOT = SPACES
                 AND ZTELNO OF ZZFT01-I IS NOT NUMERIC
             MOVE INDIC-ON TO IN34
             MOVE "OEM0014" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             SET VALID-NOT-OK TO TRUE
             GO VALIDATE-EXIT
           END-IF
      * Fax number
           IF ZFAXNO OF ZZFT01-I NOT = SPACES
                 AND ZFAXNO OF ZZFT01-I IS NOT NUMERIC
             MOVE INDIC-ON TO IN35
             MOVE "OEM0015" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             SET VALID-NOT-OK TO TRUE
             GO VALIDATE-EXIT
           END-IF
      * Distributor
           IF ZDSDCDE OF ZZFT01-I NOT = SPACES
             MOVE ZDSDCDE OF ZZFT01-I TO DSDCDE OF DISTS-RECORD
             MOVE "Y" TO RECORD-FOUND
             START DISTS-FILE KEY EQUAL EXTERNALLY-DESCRIBED-KEY
                   INVALID KEY
                      MOVE "N" TO RECORD-FOUND  END-START
             IF RECORD-FOUND = "N"
               MOVE INDIC-ON TO IN38
               MOVE "OEM0018" TO  MSGID
               CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
               SET VALID-NOT-OK TO TRUE
               GO VALIDATE-EXIT
             END-IF
           END-IF
      * Status
           IF ZSTATUS OF ZZFT01-I NOT = SPACES
             MOVE ZSTATUS OF ZZFT01-I TO WS-STATUSES
             IF NOT STATUSES
               MOVE INDIC-ON TO IN39
               MOVE "OEM0019" TO  MSGID
               CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
               SET VALID-NOT-OK TO TRUE
               GO VALIDATE-EXIT
             END-IF
           END-IF
      * Contact
           IF ZUSERNM OF ZZFT01-I = SPACES
             MOVE INDIC-ON TO IN40
             MOVE "OEM0020" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             SET VALID-NOT-OK TO TRUE
             GO VALIDATE-EXIT
           END-IF
      * Title
           IF ZSALUT OF ZZFT01-I NOT = SPACES
            IF ZSALUT OF ZZFT01-I NOT = "Mr"
               AND ZSALUT OF ZZFT01-I NOT = "Mrs"
               AND ZSALUT OF ZZFT01-I NOT = "Ms"
               AND ZSALUT OF ZZFT01-I NOT = "Dr"
               AND ZSALUT OF ZZFT01-I NOT = "Doctor"
               AND ZSALUT OF ZZFT01-I NOT = "Professor"
               AND ZSALUT OF ZZFT01-I NOT = "Sir"
               AND ZSALUT OF ZZFT01-I NOT = "Lord"
               AND ZSALUT OF ZZFT01-I NOT = "Lady"
             MOVE INDIC-ON TO IN41
             MOVE "OEM0021" TO  MSGID
             CALL "RTNMSGTEXT"  USING  MSGID  WS-ERRMSG
             SET VALID-NOT-OK TO TRUE
             GO VALIDATE-EXIT
            END-IF
           END-IF.
       VALIDATE-EXIT.

       WRITESCN-RTN.
           INITIALIZE ZZFT01-O.
           MOVE CUSNO OF CUSFL3-RECORD TO ZCUSNO OF ZZFT01-O.
           MOVE CNAME  TO ZCNAME OF ZZFT01-O.
           MOVE ADD1   TO ZADD1  OF ZZFT01-O.
           MOVE ADD2   TO ZADD2  OF ZZFT01-O.
           MOVE ADD3   TO ZADD3  OF ZZFT01-O.
           MOVE ADD4   TO ZADD4  OF ZZFT01-O.
           MOVE CNTRY  TO ZCNTRY OF ZZFT01-O.
           MOVE PSCD   TO ZPSCD  OF ZZFT01-O.
           MOVE TELNO  TO ZTELNO OF ZZFT01-O.
           MOVE FAXNO  TO ZFAXNO OF ZZFT01-O.
           MOVE EMAIL  TO ZEMAIL OF ZZFT01-O.
           MOVE WEBSIT TO ZWEBSIT OF ZZFT01-O.
           MOVE DSDCDE OF CUSFL3-RECORD TO ZDSDCDE OF ZZFT01-O.
           MOVE SINIT  TO ZSINIT  OF ZZFT01-O.
           MOVE USERNM TO ZUSERNM OF ZZFT01-O.
           MOVE SALUT  TO ZSALUT  OF ZZFT01-O.
           MOVE JTITLE TO ZJTITLE OF ZZFT01-O.
       WRITESCN-EXIT. EXIT.

       UPDFILE-RTN.
           MOVE ZCUSNO OF ZZFT01-O  TO CUSNO OF CUSFL3-RECORD.
           MOVE ZCNAME OF ZZFT01-O TO CNAME.
           MOVE ZADD1  OF ZZFT01-O TO ADD1.
           MOVE ZADD2  OF ZZFT01-O TO ADD2.
           MOVE ZADD3  OF ZZFT01-O TO ADD3.
           MOVE ZADD4  OF ZZFT01-O TO ADD4.
           MOVE ZCNTRY OF ZZFT01-O TO CNTRY.
           MOVE ZPSCD  OF ZZFT01-O TO PSCD.
           MOVE ZTELNO OF ZZFT01-O TO TELNO.
           MOVE ZFAXNO OF ZZFT01-O TO FAXNO.
      *    MOVE ZEMLAD OF ZZFT01-O TO EMAILADD.
           MOVE ZEMAIL OF ZZFT01-O TO EMAIL.
           MOVE ZWEBSIT OF ZZFT01-O TO WEBSIT.
           MOVE ZDSDCDE OF ZZFT01-O TO DSDCDE OF CUSFL3-RECORD.
           MOVE ZSINIT  OF ZZFT01-O TO SINIT.
      *--Cobol reserve word >> STATUS
      *    MOVE ZSTATUS OF ZZFT01-O TO STATUS OF CUSFL3-RECORD.
           MOVE ZUSERNM OF ZZFT01-O TO USERNM.
           MOVE ZSALUT  OF ZZFT01-O TO SALUT.
           MOVE ZJTITLE OF ZZFT01-O TO JTITLE.

           REWRITE CUSFL3-RECORD
                     NOT INVALID KEY
                       MOVE "Y" TO LS-UPDATED
           END-REWRITE.
       UPDFILE-EXIT. EXIT.
````
