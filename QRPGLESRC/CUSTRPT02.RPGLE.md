# CUSTRPT02.RPGLE Member Guide

## Overview
ILE RPG program `CUSTRPT02` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CUSTRPT02`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     HOPTION(*SRCSTMT:*NODEBUGIO) DFTACTGRP(*NO)
     FCUSTSR02  O    E             Printer Infds(@Fp2)
     F                                     Oflind(*IN70)
     FTRNHSTL1  IF   E           K DISK
     FCUSTS     IF   E           K DISK    prefix(C_)
     D*Program Message Data Structure
     D psds           SDS
     D sds_pgm               334    343
     D*Definition of local variables to perform Sorting
     D*@PGNBR1         S              4S 0
     D @PGNBR2         S              4S 0
     D UWBCCD          S                   like(xwbccd)
     D
     D @FP2            DS
     D  P2@NAM                83     92
     D  P2@OvFlow            188    189B 0
     D  P2@Line              367    368B 0
     D  P2@Page              369    372B 0
      *Prototype Declaration
     D* Entry to program
     C**************************************************************************
     C     *Entry        Plist
     C                   Parm                    Uwbccd
     C
     C**                 Eval      @PgmName1=sds_pgm
     C                   Eval      @PgmName2=sds_pgm
     C                   Exsr      PrtSR
     C                   Eval      *Inlr=*ON
     C**************************************************************************
     C     PrtSR         Begsr
     C                   if        Not %Open(CUSTSR02)
     C                   Open      CUSTSR02
     C                   Endif
     C
     C                   Eval      @PGNBR2=@PGNBR2+1
     C                   write     HDG2
     C**                 if        uwbccd = wbccd
     C                   if        uwbccd = *blanks
     C     *loval        setll(e)  custs
     C                   read(e)   custs
     C                   else
     C     uwbccd        setll(e)  custs
     C     uwbccd        reade(e)  custs
     C                   endif
     C                   dow       not %eof(custs)
     C                   eval      XWBCCD = C_XWBCCD
     C                   eval      XWBNCD = C_XWBNCD
     C**                 eval      XWCNDF = C_XWCNDF
     C     k@trnhst      setll(e)  TRNHSTL1
     C     k@trnhst      reade(e)  TRNHSTL1
     C                   dow       not %eof(TRNHSTL1)
     C
     C                   If        P2@Line >= P2@OvFlow
     C                   Eval      @PGNBR2=@PGNBR2+1
     C                   Write     HDG2
     C*                  Eval      *IN70=*ON
     C                   Eval      *IN70=*OFF
     C                   Endif
     C
     C                   write     DTL2
     C     k@trnhst      reade(e)  trnhstl1
     C                   Enddo
     C*Write Total Records
     C                   if        uwbccd = *blanks
     C                   read(e)   custs
     C                   else
     C     uwbccd        reade(e)  custs
     C                   endif
     C                   Enddo
     C                   write     EOFP2
     C                   Close     CUSTSR02
     C                   Endsr
     C********************************************************************
     C*     Parameter List
     C********************************************************************
     C     k@Trnhst      Klist
     C                   kfld                    XWBNCD
     C                   kfld                    XWBCCD
     C
     C********************************************************************
````
