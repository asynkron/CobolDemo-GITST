# PUR01.RPG Member Guide

## Overview
RPG III program `PUR01` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `PUR01`.
- **Outgoing:**
  - Accesses files/display: 3=Exit, 3=Exit  EN, 3=Exit  En

## Source
````rpg
     FPUR01DF CF  E                    WORKSTN
     F                                        @RRN1 KSFILE OESFL
     FCUSTS   IF  E           K        DISK
     FCONHDR  UF  E           K        DISK                      A
     FCONDET  UF  E           K        DISK                      A
     FSTKMAS  IF  E           K        DISK
     FSTOMAS  IF  E           K        DISK
     FSTKBAL  IF  E           K        DISK
     FTRNHSTL2IF  E           K        DISK
     FSLMEN   IF  E           K        DISK
     F*
     E                    CMD     1   3 78               CMD Key Data
     E*
     I           SDS
     I                                     *ROUTINE $ROUT
     I                                     *STATUS  $STAT
     I                                     *PARMS   $PARM
     I                                     *PROGRAM @@PGM
     I                                      244 253 @@JOB
     I*
     C*****************************************************************
     C* Receive Parameters
     C           *ENTRY    PLIST
     C                     PARM           @@RTN   1        Return Code
     C*
     C* Until F3
     C           *IN03     DOUEQ'1'
     C*
     C*  Initialise screen
     C                     MOVEACMD,1     CMDDTA
     C                     MOVEL*BLANKS   CSNAME
     C                     MOVEL*BLANKS   CSADD1
     C                     MOVEL*BLANKS   CSADD2
     C                     MOVEL*BLANKS   CSADD3
     C                     MOVEL*BLANKS   CSPSCD
     C                     Z-ADD*ZERO     DSORDN
     C                     MOVE *BLANKS   DSCSNO
     C                     MOVEL'0'       *IN34
     C                     MOVEL'1'       *IN33
     C*
     C*  Get Order No. & Customer No.
     C                     WRITEOECLR                  99
     C                     WRITEOETRL                  99
     C                     EXFMTOESFLC                 99
     C*
     C* So long as Exit not requested #1
     C           *IN03     IFNE '1'
     C*
     C* Validate order no.
     C           DSORDN    IFLT 20000
     C           DSORDN    ORGT 29999
     C                     MOVEL'OEM0005' ZMSGID  7
     C                     ENDIF
     C*
     C*  Retrieve Customer Details
     C                     EXSR $RVCUS
     C*
     C*  Set up blank subfile for Order lines
     C                     EXSR $ORLNS
     C*
     C*  Display Order Entry screen
     C                     MOVEL'1'       *IN34
     C                     MOVEL'0'       *IN33
     C                     MOVEACMD,3     CMDDTA
     C                     WRITEOETRL                  99
     C                     EXFMTOESFLC                 99
     C*
     C* So long as Exit not requested #2
     C           *IN03     IFNE '1'
     C*
     C*  Validate Order Data
     C                     EXSR $VALID
     C*
     C*  Redisplay Order Entry screen
     C                     MOVEACMD,2     CMDDTA
     C                     WRITEOETRL                  99
     C                     EXFMTOESFLC                 99
     C*
     C* So long as Exit not requested #3
     C           *IN03     IFNE '1'
     C*
     C*  Create Order
     C                     EXSR $CRORD
     C*  Delete SFL
     C                     MOVEL'1'       *IN30
     C                     WRITEOESFLC                 99
     C                     MOVEL'0'       *IN30
     C*
     C* End: So long as Exit not requested #3
     C                     END
     C*
     C* End: So long as Exit not requested #2
     C                     END
     C*
     C* End: So long as Exit not requested #1
     C                     END
     C*
     C* End: Until F3
     C                     END
     C*
     C* Terminate Program
     C                     MOVEL'0'       @@RTN
     C                     SETON                     LR
     C                     RETRN
     C*****************************************************************
     C*
     C*****************************************************************
     C           $RVCUS    BEGSR
     C*
     C* Get Customer Record
     C           DSCSNO    CHAINCUSTS                4040                 @@REDR
     C           PERSON    CHAINSLMEN                8181                 @@REDR
     C           *IN40     IFEQ '1'                                       @@REDR
     C                     MOVEL*BLANKS   CSNAME
     C                     MOVEL*BLANKS   CSADD1
     C                     MOVEL*BLANKS   CSADD2
     C                     MOVEL*BLANKS   CSADD3
     C                     MOVEL*BLANKS   CSPSCD
     C                     END
     C*
     C                     ENDSR
     C*****************************************************************
     C*
     C*****************************************************************
     C           $ORLNS    BEGSR
     C*
     C* Set up blank order lines
     C                     MOVEL'0'       *IN35
     C                     Z-ADD*ZERO     @RRN1   50
     C                     Z-ADD*ZERO     N2      50
     C                     DO   10
     C                     ADD  1         @RRN1
     C                     ADD  1         N2
     C                     Z-ADDN2        OLLNNO
     C                     Z-ADD*ZERO     OLPROD
     C                     MOVEL*BLANKS   PRDESC
     C                     Z-ADD*ZERO     OLQTY
     C                     WRITEOESFL                  31                 @@SF01
     C                     END
     C*
     C                     ENDSR
     C*****************************************************************
     C*
     C*****************************************************************
     C           $CRORD    BEGSR
     C*
     C* Create Order
     C*
     C* 1. Order Header
     C                     Z-ADDDSORDN    XWORDN
     C           XWORDN    CHAINCONHDRR              4040                 @@REDR
     C           *IN40     IFEQ '0'                                       @@REDR
     C*                    MOVEL'A'       OHSTAT
     C*                    MOVEL'AAA'     OHTYPE
     C                     MOVE DSCSNO    XWBCCD
     C                     UPDATCONHDRR                55
     C                     ELSE                                           @@REDR
     C                     Z-ADDDSORDN    XWORDN
     C*                    MOVEL'A'       OHSTAT
     C*                    MOVEL'AAA'     OHTYPE
     C                     MOVE DSCSNO    XWBCCD
     C                     WRITECONHDRR                55
     C                     END                                            @@REDR
     C*
     C* 2. Order Details
     C                     Z-ADDDSORDN    XWORDN
     C                     Z-ADD1         @RRN1   50
     C*
     C* For each record in subfile
     C           @RRN1     DOWLE10                                        @@REDR
     C*
     C           @RRN1     CHAINOESFL                4242                 @@REDR
     C*
     C*  If successfully retrieved
     C           *IN42     IFEQ '0'                                       @@REDR
     C*
     C*
     C*   If data entered
     C           OLPROD    IFNE *ZEROS                                    @@REDR
     C*
     C           LINKEY    CHAINCONDETR              4141                 @@REDR
     C                     MOVE OLPROD    XWABCD
     C                     MOVE OLQTY     XWA5QT
     C           *IN41     IFEQ '0'                                       @@REDR
     C                     UPDATCONDETR                55
     C                     ELSE                                           @@REDR
     C                     WRITECONDETR                55
     C                     END                                            @@REDR
     C*
     C*   End: If data entered
     C                     END
     C*
     C*  End: If successfully retrieved
     C                     END
     C*
     C                     ADD  1         @RRN1
     C* End: For each record in subfile
     C                     END
     C*
     C                     ENDSR
     C*****************************************************************
     C*
     C*****************************************************************
     C           $VALID    BEGSR
     C*
     C* Validate Order
     C*
     C                     MOVEL'1'       *IN35
     C                     Z-ADD1         @RRN1
     C*
     C* For each record in subfile
     C           @RRN1     DOWLE10                                        @@REDR
     C*
     C           @RRN1     CHAINOESFL                4141                 @@REDR
     C*
     C*  If successfully retrieved
     C           *IN41     IFEQ '0'                                       @@REDR
     C*
     C*   If data entered
     C           XWABCD    IFNE *ZEROS                                    @@REDR
     C*
     C*    Validate Product & Get Product Description
     C           XWABCD    CHAINSTKMASR              4242                 @@REDR
     C           XWABCD    CHAINSTKBALR              4343                 @@REDR
     C           XWAACS    CHAINSTOMASR              4343                 @@REDR
     C           XWABCD    CHAINTRNHSTL2             4343                 @@REDR
     C*
     C                     UPDATOESFL                  31                 @@SF01
     C*
     C*   End: If data entered
     C                     END
     C*
     C*  End: If successfully retrieved
     C                     END
     C*
     C                     ADD  1         @RRN1
     C* End: For each record in subfile
     C                     END
     C*
     C                     MOVEL'0'       *IN35
     C*
     C                     ENDSR
     C*****************************************************************
     C* Definitions
     C*
     C           LINKEY    KLIST                                          @@REDR
     C                     KFLD           XWORDN                          @@REDR
     C                     KFLD           XWABCD                          @@REDR
     C*
     C*****************************************************************
**
F3=Exit
F3=Exit  ENTER=continue
F3=Exit  Enter Order Lines, then ENTER to continue
````
