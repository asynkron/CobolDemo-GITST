# DELETEENT.SQLRPGLE Member Guide

## Overview
SQL-enabled RPG program `DELETEENT` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `DELETEENT`.
- **Outgoing:**
  - Calls programs/procedures: SQL_PRC_03

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2015
     H*
     H*PROGRAM:  X-Analysis: Demo Sql Stored Procedures.
     H*AUTHOR:   Pranav Kumar
     H*VERSION:  No:   1.00
     H*--------------------------------------------------------------------
      *--------------------------------------------------------------------
      *D e f i n i t i o n s
      *--------------------------------------------------------------------
     Duwparmf          s             10    varying

     C                   eval      uwparmf = upvar

      *--------------------------------------------------------------------
      *Execute the update procedure 'SQL_PRC_03'
      *--------------------------------------------------------------------
     C/EXEC SQL
     C+ Call SQL_PRC_03(:UwParmF)
     C/END-EXEC
     C                   eval      *inlr = *on
      *--------------------------------------------------------------------
      *Entry Parameter For This Program
      *--------------------------------------------------------------------
     C     *Entry        Plist
     C                   parm                    UpVar            10
````
