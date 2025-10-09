       IDENTIFICATION DIVISION.
       PROGRAM-ID.  XACBLTST.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER.  IBM-AS400.
       OBJECT-COMPUTER.  IBM-AS400.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       I-O-CONTROL.
       DATA DIVISION.
       FILE SECTION.

      *WORKING STOREAGE SECTION
       WORKING-STORAGE SECTION.
       01  I           PIC 999 COMP-3.
       01  J           PIC 999 COMP-3.
      *01  X           PIC 999 COMP-3.
       LINKAGE SECTION.
       01  PI-FIL.
           03 FIL      PIC X OCCURS 10.
       01  PI-LIB.
           03 LIB      PIC X OCCURS 10.
       01  PO-FILLIB.
           03 FILLIB   PIC X OCCURS 21.
       PROCEDURE DIVISION USING
           PI-FIL
           PI-LIB
           PO-FILLIB.
       MAINLINE SECTION.
       MAINLINE-PARAGRAPH.
           MOVE ' ' TO PO-FILLIB.
           MOVE 1 TO J.
           MOVE 1 TO I.
      *    MOVE 1 TO X.
      *    MOVE 2 TO Y.
       L1-WHILE-LOOP.
           IF (I NOT > 10 AND FIL(I) NOT = ' ') THEN
               NEXT SENTENCE ELSE GO L2-WHILE-END.
             MOVE FIL(I) TO FILLIB(J).
             ADD 1, I GIVING I.
             ADD 1, J GIVING J.
           GO L1-WHILE-LOOP.
       L2-WHILE-END.
           MOVE '.' TO FILLIB(J).
           ADD 1, J GIVING J.
           MOVE 1 TO I.
       L3-WHILE-LOOP.
           IF (I NOT > 10 AND LIB(I) NOT = ' ') THEN
               NEXT SENTENCE ELSE GO L4-WHILE-END.
             MOVE LIB(I) TO FILLIB(J).
             ADD 1, I GIVING I.
             ADD 1, J GIVING J.
           GO L3-WHILE-LOOP.
       L4-WHILE-END.
           EXIT PROGRAM.
       EXIT-MAINLINE.
           EXIT.
