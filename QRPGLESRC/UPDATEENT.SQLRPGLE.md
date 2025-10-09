# UPDATEENT.SQLRPGLE Member Guide

## Overview
SQL-enabled RPG program `UPDATEENT` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `UPDATEENT`.
- **Outgoing:**
  - Calls programs/procedures: SQL_PRC_01

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
     Duwparms          s             10    varying

     C                   eval      uwparmf = upvarf
     C                   eval      uwparms = upvarS

      *---------------------------------------------------------------
      *Execute the update procedure 'SQL_PRC_01'
      *---------------------------------------------------------------
     C/EXEC SQL
     C+ Call SQL_PRC_01(:UwParmF, :UwParmS)
     C/END-EXEC
     C                   eval      *inlr = *on
      *-----------------------------------------------------------
      *Entry Parameter For This Program
      *-----------------------------------------------------------
     C     *Entry        Plist
     C                   parm                    UpVarF           10
     C                   parm                    UpVarS           10
````
