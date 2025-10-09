# WKCUS8EF.RPG Member Guide

## Overview
RPG III program `WKCUS8EF` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `WKCUS8EF`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     FCUSFL3  IF  E           K        DISK
     E                    @TEL       17  1
     E                    FAX        12  1
     E                    @FAX       17  1
     E                    @WA        17  1
     ITELNO       DS
     I                                        1  17 @TEL
     IFAXNO       DS
     I                                        1  12 FAX
     I@FAXNO      DS
     I                                        1  17 @FAX
     I@WADS       DS
     I                                        1  17 @WA
     C           *ENTRY    PLIST
     C                     PARM           CUSNC   5
     C                     PARM @WADS     @FAXNO 17
     C****
     C                     MOVE CUSNC     CUSNO
     C           CUSNO     CHAINCUSFL3               LR
     C* If record found.
     C           *INLR     IFEQ '0'
     C                     MOVE *BLANK    @WADS
     C* Terminate if there is no fax number on the database.
     C           FAXNO     CABEQ*BLANK    FINISH
     C* Extract fax number digits. Store its length in @F.
     C                     Z-ADD*ZERO     @F      20
     C                     DO   12        @X      20
     C           FAX,@X    IFGE '0'
     C           FAX,@X    ANDLE'9'
     C                     ADD  1         @F
     C                     MOVE FAX,@X    @WA,@F
     C                     ENDIF
     C                     ENDDO
     C* If there is no telephone number on the database then terminate
     C* with the current fax number on the database.
     C           TELNO     CABEQ*BLANK    FINISH
     C                     MOVE @WADS     @FAXNO
     C                     MOVE *BLANK    @WADS
     C***                  MOVE *BLANK    @WACUS
     C* Extract telephone number digits (minus any extension number)
     C* Store its length in @T.
     C                     Z-ADD*ZERO     @T      20
     C                     Z-ADD1         @X
     C           @X        DOWLE17
     C           @TEL,@X   ANDNE'X'
     C           @TEL,@X   ANDNE'x'
     C           @TEL,@X   IFGE '0'
     C           @TEL,@X   ANDLE'9'
     C                     ADD  1         @T
     C                     MOVE @TEL,@X   @WA,@T
     C                     ENDIF
     C                     ADD  1         @X
     C                     ENDDO
     C* If the fax number is longer than the telephone number then
     C* terminate with the current fax number on the database.
     C           @F        IFGT @T
     C                     MOVE @FAXNO    @WADS
     C                     ELSE
     C* If the fax number is shorter than the telephone number then
     C* prefix the beginning digits of the telephone number to the fax
     C* number to make up the length.
     C* Eg.
     C*      Tel No. 0932 829222 x14 ; Fax No. 854468
     C*            Fax Number would become 0932854468
     C           @T        SUB  @F        @X
     C                     ADD  1         @X
     C                     MOVEA@FAXNO    @WA,@X
     C                     MOVE @WADS     @FAXNO
     C* Punctuate the fax number with '-'. Use the telephone number to
     C* decide where to punctuate.
     C* Eg.
     C*      Tel No. (0932) 829222 x14 ; Fax No. 854468
     C*             Fax Number would become 0932-854468
     C                     MOVE *BLANK    @WADS
     C                     Z-ADD*ZERO     @W      20
     C                     Z-ADD@T        @X
     C                     Z-ADD*ZERO     @T
     C                     Z-ADD*ZERO     @F
     C***                  ADD  *ZERO     @ST
     C                     EXSR $NEXT
     C           @T        DOWLE17
     C           @F        ANDLT@X
     C           @TEL,@T   ANDNE'X'
     C           @TEL,@T   ANDNE'x'
     C                     ADD  1         @W
     C           @TEL,@T   IFGE '0'
     C           @TEL,@T   ANDLE'9'
     C                     ADD  1         @T
     C                     ADD  1         @F
     C                     MOVE @FAX,@F   @WA,@W
     C                     ELSE
     C                     MOVE '-'       @WA,@W
     C                     EXSR $NEXT
     C**                   LEAVESR
     C                     ENDIF
     C                     ENDDO
     C                     ENDIF
     C           FINISH    TAG
     C                     SETON                     LR
     C* End: record found.
     C                     ENDIF
     C                     RETRN
     C*
     C           $NEXT     BEGSR
     C* Read upto next character in telephone number string to process.
     C           @NEXT     DOUEQ'Y'
     C                     ADD  1         @T
     C                     MOVE 'Y'       @NEXT   1
     C           @T        IFLE 17
     C           @TEL,@T   ANDNE'X'
     C           @TEL,@T   ANDNE'x'
     C           @TEL,@T   IFLT '0'
     C           @TEL,@T   ORGT '9'
     C                     MOVE 'N'       @NEXT
     C                     ENDIF
     C                     ENDIF
     C                     ENDDO
     C                     ENDSR
````
