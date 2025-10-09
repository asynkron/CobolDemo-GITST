       IDENTIFICATION DIVISION.
       PROGRAM-ID.    PRNCUSF.
       INSTALLATION.  DATABOROUGH INDIA.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-AS400.
       OBJECT-COMPUTER. IBM-AS400.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

           SELECT CUSF
              ASSIGN TO DATABASE-CUSF
              ORGANIZATION IS SEQUENTIAL
              ACCESS MODE  IS SEQUENTIAL
              FILE STATUS  IS FILE-STATUS.

           SELECT CUSFPRN
              ASSIGN TO PRINTER-QPRINT
              ORGANIZATION IS SEQUENTIAL
              ACCESS MODE  IS SEQUENTIAL
              FILE STATUS  IS FILE-STATUS.
      *
       DATA DIVISION.
       FILE SECTION.
      *
       FD  CUSF
           LABEL RECORDS ARE STANDARD.
       01  CUSF-REC.
           COPY DDS-ALL-FORMATS OF CUSF.
       01  FD-CUSF-EOB            PIC X(672).

       FD  CUSFPRN
           LABEL RECORDS ARE OMITTED.
       01  FD-CUSFPRN-RECORD      PIC X(132).


       WORKING-STORAGE SECTION.

       01  PROGRAM-CONSTANTS.
           05  YES                                PIC X(3) VALUE "YES".
      *    05  NO                                 PIC X(3) VALUE "NO".
           05  FLAG-OK                            PIC X(3) VALUE SPACES.

       01  PROGRAM-INDICATORS.
           05  INVALID-KEY-IND                    PIC X(03).
           05  EOF-IND                            PIC X(03).

       01  FILE-STATUS                            PIC X(2).
       01  WORK-FIELDS.
           05  WS-RECORDS-WRITTEN       PIC 9(09) VALUE ZEROS.
           05  WS-HEADING-LINE.
               10  FILLER                       PIC X(15) VALUE SPACES.
               10  FILLER                       PIC X(50)  VALUE
               " CUSTOMER LIST AS OF DATE ".

           05  WS-DETAIL-RECORDS.
               10  FILLER            PIC X(05)  VALUE SPACES.
               10  WS-COMPANY-NAME                PIC X(40).
               10  FILLER            PIC X(05)  VALUE SPACES.
               10  WS-CONTACT-PERSON              PIC X(20).
               10  FILLER            PIC X(05)  VALUE SPACES.
               10  WS-COMP-ADD                    PIC X(20).
               10  FILLER            PIC X(05)  VALUE SPACES.
               10  WS-PROD-CODE                   PIC X(10).
               10  FILLER            PIC X(9)  VALUE SPACES.
               10  WS-DIST-CODE                   PIC X(2).

           05  WS-DETAIL-LINE-2.
               10  FILLER                PIC X(01)  VALUE SPACES.

           05  WS-FOOTER-LINE.
               10  FILLER                         PIC X(20)  VALUE
               "  *******   END OF REPORT   *******   ".


       PROCEDURE DIVISION.

       START-PROGRAM.
           PERFORM 100-INITIALIZATION.
           PERFORM 200-PROCESS-CUSF-RECORDS
               UNTIL EOF-IND = YES.
           PERFORM 500-CLOSE-FILES.
           STOP RUN.

       100-INITIALIZATION.
           PERFORM 150-OPEN-FILES.
           MOVE SPACES TO EOF-IND.
           INITIALIZE WS-RECORDS-WRITTEN.

           MOVE WS-HEADING-LINE TO FD-CUSFPRN-RECORD.
           WRITE FD-CUSFPRN-RECORD AFTER ADVANCING PAGE.
           MOVE  SPACES  TO  FD-CUSFPRN-RECORD.
           WRITE FD-CUSFPRN-RECORD AFTER ADVANCING 1.
           PERFORM 400-READ-CHECK-CUSF.

       150-OPEN-FILES.
           OPEN INPUT CUSF.
           OPEN OUTPUT CUSFPRN.

       300-PRINT-RECORDS.
           MOVE WS-DETAIL-RECORDS  TO FD-CUSFPRN-RECORD.
           WRITE FD-CUSFPRN-RECORD AFTER ADVANCING 1.

       500-CLOSE-FILES.
           CLOSE CUSF.
           CLOSE CUSFPRN.


       200-PROCESS-CUSF-RECORDS.
           INITIALIZE WS-DETAIL-RECORDS.
           IF DSDCDE NOT = SPACES
                 MOVE CNAME TO WS-COMPANY-NAME
                 MOVE USERNM TO WS-CONTACT-PERSON
                 MOVE ADD4 TO WS-COMP-ADD
                 MOVE PRPCDE TO WS-PROD-CODE
                 MOVE DSDCDE TO WS-DIST-CODE
           END-IF
           PERFORM 300-PRINT-RECORDS.
           PERFORM 400-READ-CHECK-CUSF.
           IF EOF-IND = "YES"
             MOVE WS-FOOTER-LINE  TO FD-CUSFPRN-RECORD
             WRITE FD-CUSFPRN-RECORD AFTER ADVANCING 1
           END-IF.

      *    IF EOF-IND = "NO"
      *      WRITE FD-CUSFPRN-RECORD AFTER ADVANCING 1
      *    END-IF.

           IF PRPCDE = "XA"
             MOVE "XANALYSIS" TO WS-PROD-CODE
           END-IF.
           IF ADD4 = SPACES
             MOVE "LONDON" TO WS-COMP-ADD
           END-IF.
       400-PCR-EXIT. EXIT.

      ******************
      * I/O PROCESSING                                                 *
      ******************
       400-READ-CHECK-CUSF.
           READ CUSF NEXT RECORD
               AT END
                   MOVE YES TO EOF-IND.

