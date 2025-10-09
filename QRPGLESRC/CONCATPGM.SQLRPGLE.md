# CONCATPGM.SQLRPGLE Member Guide

## Overview
SQL-enabled RPG program `CONCATPGM` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CONCATPGM`.
- **Outgoing:**
  - Calls programs/procedures: CONCATSTR

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2015
     H*
     H*PROGRAM:  X-Analysis: Demo Sql Stored Procedures.
     H*AUTHOR:   Pranav Kumar
     H*VERSION:  No:   1.00
     H*--------------------------------------------------------------------
     Duwparmf          s             10    varying
     Duwparms          s             20    varying

     C                   eval      uwparmf = upvar

      *-----------------------------------------------------------
      *Execute the procedure 'CONCATSTR' in order to display entry
      *-----------------------------------------------------------
     C/EXEC SQL
     C+ Call CONCATSTR(:UwParmF, :UwParmS)
     C/END-EXEC

     C     uwparms       dsply

     C                   eval      *inlr = *on
      *-----------------------------------------------------------
      *Entry Parameter For This Program
      *-----------------------------------------------------------
     C     *Entry        Plist
     C                   parm                    UpVar            10
````
