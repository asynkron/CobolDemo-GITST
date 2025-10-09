     H*ˆ--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2015
     H*‚
     H*ˆPROGRAM:  X-Analysis: Demo Sql Stored Procedures.
     H*ˆAUTHOR:   Pranav Kumar
     H*ˆVERSION:  No:   1.00
     H*ˆ--------------------------------------------------------------------
     Duwparmf          s             10    varying
     Duwparms          s             20    varying

     C                   eval      uwparmf = upvar

      *‚-----------------------------------------------------------
      *‚Execute the procedure 'CONCATSTR' in order to display entry
      *‚-----------------------------------------------------------
     C/EXEC SQL
     C+ Call CONCATSTR(:UwParmF, :UwParmS)
     C/END-EXEC

     C     uwparms       dsply

     C                   eval      *inlr = *on
      *‚-----------------------------------------------------------
      *‚Entry Parameter For This Program
      *‚-----------------------------------------------------------
     C     *Entry        Plist
     C                   parm                    UpVar            10
