# CUSTRPT01.RPGLE Member Guide

## Overview
ILE RPG program `CUSTRPT01` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CUSTRPT01`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     HOPTION(*SRCSTMT:*NODEBUGIO) DFTACTGRP(*NO)
     FCUSTSR01  O    E             Printer Infds(@Fp1)
     F                                     Oflind(*IN88)
     FTRNHSTL1  IF   E           K DISK
     FCUSTS     IF   E           K DISK    prefix(C_)
     D*Program Message Data Structure
     D psds           SDS
     D sds_proc          *proc
     D sds_pgm               334    343
     ** *******Definition for Message Variables******************
     D  msgId          S              7A
     D  sndrcv         S              1A   Inz('S')
     D  msgDta         S            128A
     D*Definition of Parameters for Program TMSR002
     D P@RETVAL        S              1P 0
     D K#Best5         S              1A   Inz('Y')
     D K#Passed        S              1A
     D*K#Reset         S              1A
     D*Definition of local variables to perform Sorting
     D Counter         S              3S 0 Inz(0)
     D @UNAME1         S             10A   INZ(*USER)
     D #Line1          S                   LIKE(P1@line)
     D @PGNBR1         S              4S 0
     D #Cust           S              4S 0
     D
     D @FP1            DS
     D  P1@NAM                83     92
     D  P1@OvFlow            188    189B 0
     D  P1@Line              367    368B 0
     D  P1@Page              369    372B 0
     D
      *Prototype Declaration
     D* Entry to program
     C**************************************************************************
     C                   Eval      @PgmName1=sds_pgm
     C**                 Exsr      RstSR
     C                   Exsr      PrtSR
     C                   Eval      *Inlr=*ON
     C**************************************************************************
     C     PrtSR         Begsr
     C                   if        Not %Open(CUSTSR01)
     C                   Open      CUSTSR01
     C                   Endif
     C
     C                   Eval      @PGNBR1=@PGNBR1+1
     C                   write     HDG1
     C                   read(e)   custs
     C                   dow       not %eof(custs)
     C                   eval      XWBCCD = C_XWBCCD
     C                   eval      XWBNCD = C_XWBNCD
     C                   eval      #CUST = 1
     C**                 eval      #CUST = 0
     C                   eval      TXWA5QT = 0
     C**                 eval      TXWA6QT = 1
     C                   eval      TXWVALU = 0
     C     k@trnhst      setll(e)  TRNHSTL1
     C     k@trnhst      reade(e)  TRNHSTL1
     C                   dow       not %eof(TRNHSTL1)
     C
     C                   if        #Cust = 1
     C                   write     CUSTHDR1
     C                   eval      #Cust = #Cust + 1
     C                   endif
     C
     C                   eval      TXWA5QT = TXWA5QT + XWA5QT
     C                   eval      TXWVALU = TXWVALU + XWVALU
     C*                  eval      TXWVAL = TXWVAL + XWVAL
     C
     C                   If        P1@Line >= P1@OvFlow
     C                   Eval      @PGNBR1=@PGNBR1+1
     C*                  write     CUSTHDR1
     C                   Eval      *IN88=*OFF
     C                   Endif
     C
     C                   write     DTL1
     C     k@trnhst      reade(e)  trnhstl1
     C                   Enddo
     C*Write Total Records
     C                   if        TXWA5QT <> 0 and TXWVALU <> 0
     C                   write     TOTLINE1
     C                   write     TOTL1
     C                   write     TOTLINE1
     C                   endif
     C                   read(e)   custs
     C                   Enddo
     C                   write     EOFP1
     C                   Close     CUSTSR01
     C                   Endsr
     C********************************************************************
     C*     Parameter List
     C********************************************************************
     C     P@List        PLIST
     C                   Parm                    msgId
     C                   Parm                    sndrcv
     C                   Parm                    msgDta
     C********************************************************************
     C     k@Trnhst      Klist
     C                   kfld                    XWBNCD
     C                   kfld                    XWBCCD
     C
     C********************************************************************
````
