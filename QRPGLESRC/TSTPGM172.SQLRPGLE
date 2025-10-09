     D var1            s              2a
     D var2            s             11a
     D var3            s             40a
     D stmt            s           1000a   inz(*blanks)

     C                   eval      stmt = 'Select XWAACS into :var3 From +
     C                                    CONDETL1 where +
     C                                    XWORDN = :var1 and XWABCD = :var2'
     C/exec sql
     C+   execute immediate :stmt
     C/end-exec

      /free

       stmt = 'Select ' +
               'XWAACS into :var3 From ' +
               'CONDETL1 where ' +
               'XWORDN = :var1 and XWABCD = :var2';

        exec sql
          execute immediate :stmt;

        exec sql
          Select XWG4TX into :var3 From CUSTSL1
          Where XWBNCD = :var1 and XWBCCD = :var2;

        exec sql
          Update CONDETL2 set XWAACS = :var1;

        exec sql
          Delete from CONDETL3 where XWAACS = :var1;

        *inlr = *on;
        return;

      /end-free
