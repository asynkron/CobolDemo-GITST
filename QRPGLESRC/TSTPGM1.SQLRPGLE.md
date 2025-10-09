# TSTPGM1.SQLRPGLE Member Guide

## Overview
SQL-enabled RPG program `TSTPGM1` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `TSTPGM1`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     D var1            s              5p 0
     D var2            s             10a
     D var3            s             10a
     D stmt            s           1000a   inz(*blanks)

     C                   eval      stmt = 'Select FLD13 into :var3 From +
     C                                    TSTPF1L1 where +
     C                                    FLD11 = :var1 and FLD12 = :var2'
     C/exec sql
     C+   execute immediate :stmt
     C/end-exec

      /free

        exec sql
          Select FLD13 into :var3 From TSTPF1L3
          Where FLD11 = :var1 and FLD14 = :var2;

        *inlr = *on;
        return;

      /end-free
````
