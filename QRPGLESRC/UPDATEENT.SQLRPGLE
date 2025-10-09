     H*ˆ--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2015
     H*‚
     H*ˆPROGRAM:  X-Analysis: Demo Sql Stored Procedures.
     H*ˆAUTHOR:   Pranav Kumar
     H*ˆVERSION:  No:   1.00
     H*ˆ--------------------------------------------------------------------
      *‚--------------------------------------------------------------------
      *‚D e f i n i t i o n s
      *‚--------------------------------------------------------------------
     Duwparmf          s             10    varying
     Duwparms          s             10    varying

     C                   eval      uwparmf = upvarf
     C                   eval      uwparms = upvarS

      *‚---------------------------------------------------------------
      *‚Execute the update procedure 'SQL_PRC_01'
      *‚---------------------------------------------------------------
     C/EXEC SQL
     C+ Call SQL_PRC_01(:UwParmF, :UwParmS)
     C/END-EXEC
     C                   eval      *inlr = *on
      *‚-----------------------------------------------------------
      *‚Entry Parameter For This Program
      *‚-----------------------------------------------------------
     C     *Entry        Plist
     C                   parm                    UpVarF           10
     C                   parm                    UpVarS           10
