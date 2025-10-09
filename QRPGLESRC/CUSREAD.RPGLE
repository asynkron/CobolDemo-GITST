     FCUSFL1    IF   E           k disk
     FCUSTS     IF   E           k disk
     FCUSFL3    IF   E           k disk    rename(rcusf:rcusf3)
     FTRNHSTL9  IF   E           k disk
     C* Normal SETLL/READ  with CHAIN inside loop
     C     *loval        setll     custs
     C                   read      custs
     C                   dow       not %eof(custs)
     C     cusno         chain     CUSFL3
     C*                  eval      xwbccd = wbccd
     C*                  eval      xwbccd = *blanks
     C                   read      custs
     C                   enddo
     C*
     C* CHAIN instead of SETLL and CHAIN inside loop
     C                   eval      xwbccd = *blanks
     C     xwbccd        chain     custs
     C                   dou       %eof(custs)
     C     cusno         chain     CUSFL3
     C                   read      custs
     C                   enddo
     C*
     C* SETLL used to validate instead of chain
     C**                 eval      xwbccd = *blanks
     C     *loval        setll     cusfl1
     C                   read      cusfl1
     C                   dow       not %eof(cusfl1)
     C     cusno         setll     CUSFL3
     C                   if        not %equal(cusfl3)
     C                   endif
     C                   read      cusfl1
     C                   enddo
     C*
     C*
     C                   move      *on           *inlr
     C                   return
