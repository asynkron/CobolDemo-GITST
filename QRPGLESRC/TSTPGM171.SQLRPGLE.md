# TSTPGM171.SQLRPGLE Member Guide

## Overview
SQL-enabled RPG program `TSTPGM171` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `TSTPGM171`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     D var1            s              2a
     D var2            s             11a
     D var3            s             40a
     D stmt            s           1000a   inz(*blanks)

     C                   eval      stmt = 'Select XWG4TX into :var3 From +
     C                                    CUSTSL2 where +
     C                                    XWBNCD = :var1 and XWBCCD = :var2'
     C/exec sql
     C+   execute immediate :stmt
     C/end-exec

     C                   eval      stmt = 'Select XWG4TX '
     C                   eval      stmt = %trim(stmt) + ' into :var3 From '+
     C                                                  ' CUSTSL2 where'
     C                   eval      stmt = %trim(stmt) + ' XWBNCD = :var1'
     C                   eval      stmt = %trim(stmt)+ ' and XWBCCD = :var2'
     C/exec sql
     C+   execute immediate :stmt
     C/end-exec

      /free

       //stmt = 'Select ' +
       //        'XWG4TX into :var3 From ' +
       //        'CUSTSL1 where ' +
       //        'XWBNCD = :var1 and XWBCCD = :var2';

       stmt = 'Select XWG4TX ';
       stmt = %trim(stmt) + ' into :var3 From '+
              ' CUSTSL3 where';
       stmt = %trim(stmt) + ' XWBNCD = :var1';
       stmt = %trim(stmt)+ ' and XWBCCD = :var2';

        exec sql
          execute immediate :stmt;

        exec sql
          Select XWG4TX into :var3 From CUSTSL1
          Where XWBNCD = :var1 and XWBCCD = :var2;

        exec sql
          Update CUSTSL4 set XWBNCD = :var1;

        exec sql
          Delete from CUSTSL5 where XWBNCD = :var1;

        *inlr = *on;
        return;

      /end-free
````
