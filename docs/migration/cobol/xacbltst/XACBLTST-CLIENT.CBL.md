# XACBLTST-CLIENT.CBL Modernization Harness

This wrapper program shows how existing IBM i callers can delegate concatenation to the new HTTP service without rewriting the COBOL entry point. It assembles a JSON payload, posts it through Db2 for i HTTP utilities, and falls back to the classic `XACBLTST` when anything goes wrong. Keeping this harness documented is essential for shops that need a reversible migration path.

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. XACBLTSTWS.

       WORKING-STORAGE SECTION.
       77  WS-BASE-URL            PIC X(256) VALUE SPACE.
       77  WS-ENDPOINT            PIC X(256) VALUE SPACE.
       77  WS-JSON-REQUEST        PIC X(256) VALUE SPACE.
       77  WS-JSON-RESPONSE       PIC X(2048) VALUE SPACE.
       77  WS-STATUS-CODE         PIC 9(3) COMP VALUE 0.
       77  WS-ERROR-MSG           PIC X(256) VALUE SPACE.
       77  WS-FILENAME-UTF8       PIC X(10) VALUE SPACE.
       77  WS-LIBRARY-UTF8        PIC X(10) VALUE SPACE.
       77  WS-FULLNAME            PIC X(21) VALUE SPACE.
       77  WS-HTTP-HEADERS        PIC X(512) VALUE
           'Content-Type: application/json\nAccept: application/json\n'.

       01  WS-CONVERT-TABLE.
           05 WS-CVT-LEN          PIC 9(4) COMP VALUE 10.
           05 WS-CVT-TABLE        PIC X(10) VALUE 'QTCPASC'.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  HV-BASE-URL            PIC X(256).
       01  HV-RESPONSE            SQL TYPE IS CLOB(2048) CCSID 1208.
       01  HV-REQUEST             SQL TYPE IS CLOB(256) CCSID 1208.
       01  HV-HEADERS             SQL TYPE IS CLOB(512) CCSID 1208.
       01  HV-STATUS              PIC S9(9) COMP-5.
       EXEC SQL END DECLARE SECTION END-EXEC.

       LINKAGE SECTION.
       01  PI-FIL.
           05  FIL                PIC X OCCURS 10.
       01  PI-LIB.
           05  LIB                PIC X OCCURS 10.
       01  PO-FILLIB.
           05  FILLIB             PIC X OCCURS 21.

       PROCEDURE DIVISION USING PI-FIL PI-LIB PO-FILLIB.

       MAINLINE.
           PERFORM INITIALISE-ENVIRONMENT
           IF WS-BASE-URL = SPACE
               MOVE 'Missing XACONCAT_URL environment variable.'
                   TO WS-ERROR-MSG
               PERFORM FALLBACK-TO-LEGACY
               GOBACK
           END-IF

           PERFORM BUILD-REQUEST
           PERFORM CALL-HTTP-SERVICE
           IF WS-STATUS-CODE = 200
               PERFORM PARSE-RESPONSE
               MOVE WS-FULLNAME TO PO-FILLIB
           ELSE
               PERFORM FALLBACK-TO-LEGACY
           END-IF

           GOBACK.

       INITIALISE-ENVIRONMENT.
           EXEC SQL
              SET :HV-BASE-URL = (
                SELECT COALESCE(VARIABLE_VALUE, '')
                  FROM TABLE(QSYS2.ENVIRONMENT_VARIABLE_INFO('XACONCAT_URL')) AS ENV
              )
           END-EXEC
           IF SQLCODE NOT = 0
               MOVE 'Unable to read XACONCAT_URL environment variable.'
                   TO WS-ERROR-MSG
           END-IF
           MOVE HV-BASE-URL TO WS-BASE-URL
           STRING WS-BASE-URL DELIMITED BY SPACE
                  '/api/v1/concat' DELIMITED BY SIZE
               INTO WS-ENDPOINT
           END-STRING.

       BUILD-REQUEST.
      *> Translate EBCDIC input to UTF-8 so the remote API receives clean JSON.
           CALL 'QDCXLATE' USING WS-CVT-LEN WS-CVT-TABLE PI-FIL WS-FILENAME-UTF8
           CALL 'QDCXLATE' USING WS-CVT-LEN WS-CVT-TABLE PI-LIB WS-LIBRARY-UTF8
           STRING '{"fileName":"' DELIMITED BY SIZE
                  WS-FILENAME-UTF8 DELIMITED BY SIZE
                  '","library":"' DELIMITED BY SIZE
                  WS-LIBRARY-UTF8 DELIMITED BY SIZE
                  '"}' DELIMITED BY SIZE
             INTO WS-JSON-REQUEST
           END-STRING
           MOVE WS-JSON-REQUEST TO HV-REQUEST
           MOVE WS-HTTP-HEADERS TO HV-HEADERS.

       CALL-HTTP-SERVICE.
      *> Db2 for i built-in HTTP client posts the JSON to ASP.NET and
      *> captures both status and payload for downstream handling.
           EXEC SQL
              SELECT STATUS, RESPONSE
                INTO :HV-STATUS, :HV-RESPONSE
                FROM TABLE(
                     SYSTOOLS.HTTPPOSTCLOB(
                        URL => :WS-ENDPOINT,
                        HEADERS => :HV-HEADERS,
                        DATA => :HV-REQUEST,
                        TIMEOUT => 30)
                    ) AS X
           END-EXEC
           IF SQLCODE = 0
               MOVE HV-STATUS TO WS-STATUS-CODE
               IF WS-STATUS-CODE NOT = 200
                   MOVE HV-RESPONSE TO WS-JSON-RESPONSE
                   STRING 'HTTP ' DELIMITED BY SIZE
                          WS-STATUS-CODE DELIMITED BY SIZE
                          ' ' DELIMITED BY SIZE
                          HV-RESPONSE DELIMITED BY SIZE
                       INTO WS-ERROR-MSG
                   END-STRING
               ELSE
                   MOVE HV-RESPONSE TO WS-JSON-RESPONSE
               END-IF
           ELSE
               MOVE 'HTTPPOSTCLOB failed. SQLCODE=' TO WS-ERROR-MSG(1:29)
               MOVE SQLCODE TO WS-ERROR-MSG(30:6)
               MOVE 0 TO WS-STATUS-CODE
           END-IF.

       PARSE-RESPONSE.
      *> Minimal JSON parsing keeps the footprint small while extracting
      *> the concatenated name returned by ASP.NET.
           UNSTRING WS-JSON-RESPONSE DELIMITED BY '"fullName"' INTO WS-ERROR-MSG
           UNSTRING WS-JSON-RESPONSE DELIMITED BY '"fullName"' INTO WS-ERROR-MSG
           UNSTRING WS-JSON-RESPONSE DELIMITED BY '"' INTO WS-ERROR-MSG
           UNSTRING WS-JSON-RESPONSE DELIMITED BY '"' INTO WS-FULLNAME
           END-UNSTRING
           IF WS-FULLNAME = SPACE
               MOVE 'Missing fullName in response.' TO WS-ERROR-MSG
               PERFORM FALLBACK-TO-LEGACY
           END-IF.

       FALLBACK-TO-LEGACY.
      *> Preserve the original behavior if the API call fails.
           CALL 'XACBLTST' USING PI-FIL PI-LIB PO-FILLIB.
```

When administrators need to reverse course, this client can be disabled and the on-platform routine still works. The markdown capture ensures the modernization guide explains each callout without forcing readers into the COBOL member itself.
