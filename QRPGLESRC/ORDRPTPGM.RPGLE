     H* --------------------------------------------------------------------
     H*‚ COPYRIGHT DATABOROUGH LTD 2013
     H*‚ DESCRIPTION : Write Out Order Report
     H*‚ PROGRAM :     ORDRPTPGM
     H*‚ AUTHOR :      Deepak Mishra
     H*‚ VERSION :     1.00      DATE : 09-05-2013
     H* --------------------------------------------------------------------
     H*‚********************************************************************
     H debug(*yes) copyright('DATABOROUGH LTD. 2013')
     H option(*srcstmt: *nodebugio: *showcpy)
     F*‚********************************************************************
     F*‚ F i l e s
     F*‚********************************************************************
     Fordbaldtl if   e             disk
     Fordbalrpt o    e             printer oflind(*in99)

     D*‚********************************************************************
     D*‚ D e f i n i t i o n s
     D*‚********************************************************************
     D customer        s             11a
     D netval          s              6a
     D*‚Program Status Data Structure
     D/copy $DPSSR
      /Free
        //‚*****************************************************************
        //‚  M a i n  L i n e  C o d e
        //‚*****************************************************************
        *in99 = '1';
        //‚Read The File
        read(e) ordbaldtl;
        dow not%eof(ordbaldtl);
          if *in99;
            customer = ' ';
            netval = ' ';
            w@time = %Dec(%Time():*ISO);
            w@date = %Dec(%Date():*USA);
            //‚Write Header
            write header;
            //‚Write Heading
            write heading;
            write heading1;
            *in99 = '0';
          endif;
          netrcd = XWA5QT * XWPRIC;
          if customer = XWBCCD;
            XWBCCD = ' ';
          endif;
          if netval = %char(XWORDN);
            XWORDN1 = ' ';
          else;
            XWORDN1 = %char(XWORDN);
          endif;
          //‚Write The Field Value
          write field;
          read(e) ordbaldtl;
          customer = XWBCCD;
          netval = %char(XWORDN);
        enddo;
        //‚Write Footer
        write footer;
       *inlr = *on;
      /end-free
     C*‚********************************************************************
     C*‚ C o p y  B o o k s
     C*‚********************************************************************
     C*‚Program Status Data Structure
     C/copy $CPSSR
