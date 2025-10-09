# DEALENT.RPG38 Member Guide

## Overview
Source member `DEALENT` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `DEALENT`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
0139 FDL0030FMCF  E                    WORKSTN
0141 FDEALS   UF  E           K        DISK                      A
0143 FCUSDED  UF  E           K        DISK                      A
0145 FOLPOSD  UF  E           K        DISK
0146 FPRONOD  UF  E           K        DISK
0150 FSNAMED  IF  E           K        DISK
0151 FCLINTD  IF  E           K        DISK
     C           DL10PL    PLIST                                          001800
     C                     PARM           ##ACTN  1        Action code    001900
0809 C**   FIRST CYCLE CALCULATIONS
     C                     SETOF                     U7U8                 004000
     C                     Z-ADD1         S          80                   004100
0810 C*  SET UP SCREEN ID BY TAKING THE LAST TWO DIGITS OF SCREEN NAME
     C                     MOVE WS2       WSID    2                       006000
0811 C                     EXSR ZSYSTM                                    006200
0813 C   99                GOTO TABMIS                                    006300
0814 C**   CHAIN TO ALL NECESSARY INSTALLATION CONTROL RECORDS.
0815 C**   GET CONTROL DATA RECORD 2.
     C                     MOVE '11'      TABXXX                          006600
0817 C                     EXSR TABCHN                                    006700
0819 C   28                GOTO TABMIS                                    006800
0820 C**   GET CONTROL DATA RECORD 5.
0821 C                     MOVE '30'      TABKEY                          007000
0822 C                     EXSR TABCHN                                    007100
0824 C   28                GOTO TABMIS                                    007200
     C* Get control record 6.
0826 C                     MOVE '40'      TABKEY                          007400
0827 C                     EXSR TABCHN                                    007500
     C* Check all installation control data records present.
0829 C  N28                GOTO LOCHN                                     007700
     C* If table record missing.no further processing allowed.
0832 C           TABMIS    TAG                             **TABMIS TAG **008000
0833 C                     SETON                     86U7LR               008100
0834 C                     RETRN                                          008200
0852 C**   CHAIN TO CCY TABLE FOR BASE CCY AND LOCAL CCY DETAILS.
0853 C           LOCHN     TAG                             ** LOCHN TAG **008500
0854 C                     MOVEL'20      'TABKEY                          008600
0855 C  N38                MOVE BCCY      TABKEY                          008700
0856 C   38                MOVE LOCY      TABKEY                          008800
0857 C                     EXSR TABCHN                                    008900
0858 C**   STORE TELEX NOTICE DAYS FOR LOCAL CCY
0859 C   38                Z-ADDTNOT      LOCNOT  10                      009100
0859 C   38                Z-ADDCDP       LOCCDP  10                      009200
0859 C   38                GOTO KEYWRK                                    009300
0861 C**   STORE NO. OF DECIMALS FOR BASE CCY.
0862 C  N38                Z-ADDCDP       BASCDP  10 38  38               009500
0863 C                     GOTO LOCHN                                     009600
0835 C**   SET UP BLANK WORK FIELDS AND KEY FIELDS
0836 C           KEYWRK    TAG                             ** KEYWRK TAG *009800
     C                     MOVE *BLANKS   ##DS01                          009900
     C** SETUP ARRAY OF DEALING BRANCH CUSTOMER NOS.
     C                     EXSR BRNARR                                    010900
     C* Write FX input screen
0864 C           FIRST     TAG                             ** FIRST TAG **013500
0865 C**   RE-SET ERROR MESSAGE/CODE FIELDS
0866 C                     MOVE '    '    ERCD                            013800
0867 C**   RE-SET ARRAY INDEX.
0868 C                     Z-ADD1         S       20 0204                 014000
     C**   SET OPTION TAKEDOWN PROTECT INDICATOR
     C                     MOVE OPTDWN    *IN75                           014200
     C* Write/read  FX input screen
0863 C                     EXSR TIMESR                                    014400
0863 C  N34                EXFMTDL0030FA                                  014500
0863 C   34                WRITEDL0030FA                                  014600
0863 C   34                EXFMTDL0030FC                                  014700
0883 C  NKD                BITOF'012'     EXP     1                       015700
0898 C   KD                GOTO REVERS                                    015800
1932 C**   IF REVERSAL SCREEN AND CMD/8 NOT PRESSED GOTO FIRST
1932 C           SRNID     IFEQ 'SR'                       *** 1 ***      016000
     C   KH      BRNCH2    CABEQ*ZEROS    FIRST                           016100
0863 C   KH                GOTO SCR2                                      016200
0863 C                     GOTO FIRST                                     016300
0863 C                     END                             *** 1 ***      016400
1932 C**   IF ENQUIRY SCREEN RETURN TO FIRST OR SECOND IF CMD/8
1136 C**   VALIDATE DEAL SUB-TYPE
1138 C           SUBTPE    COMP '  '                     44               018600
1139 C   44                MOVE ' 102'    ERCD,S                          018700
1140 C   44      S         ADD  1         S                               018800
1141 C   44                GOTO BRVAL                                     018900
L108 C* For a single branch site, default to the branch code
L108 C**         BRCODE    IFEQ *BLANKS                    *** 1 ***
L108 C**                   MOVE ' 103'    ERCD,S
L108 C**                   ADD  1         S          46
L108 C**                   GOTO ORGVAL
L108 C**                   END                             *** 1 ***
0158 C   28                MOVE ' 103'    ERCD,S                          022000
0159 C   28      S         ADD  1         S          46                   022100
     C  N99      $RECT     COMP 40                   9999                 024400
     C  N99      $DBRCD    COMP BRCODE               9999                 024500
     C  N99      $RECI     COMP 'D'                  9696                 024600
     C  N99N96   $FDEL     COMP DEALNO                 9898               024700
     C   98      $LDEL     COMP DEALNO               98  98               024800
     C*    FOR ANY COMBINATION OF BRANCH, DEAL NUMBER AND DEAL TYPE
     C* WE MUST TEST WHETHER A VALID RANGE EXISTS
     C***98******DLTYP*****LOKUP$DT**********************97LD GS0075
     C   98      DLTYP     LOKUP$DT                      98LI GS0075      025300
     C   98                SETON                     99                   025400
     C                     END                              *** 2 ***     025500
     C* Not in range
     C  N98                MOVE ' 959'    ERCD,S                          025900
     C  N98                ADD  1         S          46                   026000
     C***98N97*************MOVE '*960'****ERCD,S**********LD GS0075
     C***98N97*************ADD  1*********S**********46***LD GS0075
     C*
     C* Release table if an update file                                   **
     C*----------BRCODE----IFNE BRANCH---------------------------------
     C*--------------------MOVE '-103'----ERCD,S-----------------------
     C*--------------------ADD  1---------S----------46----------------
     C*--------------------END  ---------------------------------------
     C*
     C                     END                             *** 1 ***      028700
````
