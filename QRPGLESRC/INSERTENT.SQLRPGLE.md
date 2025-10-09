# INSERTENT.SQLRPGLE Member Guide

## Overview
SQL-enabled RPG program `INSERTENT` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `INSERTENT`.
- **Outgoing:**
  - Calls programs/procedures: SQL_PRC_02

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
     Duwparmt          s             10    varying

     C                   eval      uwparmf = upvarf
     C                   eval      uwparms = upvars
     C                   eval      uwparmt = upvart

      *--------------------------------------------------------------------
      *Execute the procedure 'SQL_PRC_02' in order to insert entry
      *--------------------------------------------------------------------

     C/EXEC SQL
     C+ Call SQL_PRC_02(:UwParmF, :UwParmS, :UwParmT)
     C/END-EXEC
     C                   eval      *inlr = *on

      *--------------------------------------------------------------------
      *Entry Parameter For This Program
      *--------------------------------------------------------------------
     C     *Entry        Plist
     C                   parm                    UpVarF           10
     C                   parm                    UpVarS           10
     C                   parm                    UpVarT           10
````
