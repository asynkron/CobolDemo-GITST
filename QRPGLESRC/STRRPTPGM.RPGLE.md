# STRRPTPGM.RPGLE Member Guide

## Overview
ILE RPG program `STRRPTPGM` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `STRRPTPGM`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H* --------------------------------------------------------------------
     H* COPYRIGHT DATABOROUGH LTD 2013
     H* DESCRIPTION : Write Out Product Report
     H* PROGRAM :     PRDRPTPGM
     H* AUTHOR :      Deepak Mishra
     H* VERSION :     1.00      DATE : 09-05-2013
     H* --------------------------------------------------------------------
     H*********************************************************************
     H debug(*yes) copyright('DATABOROUGH LTD. 2013')
     H option(*srcstmt: *nodebugio: *showcpy)
     F*********************************************************************
     F* F i l e s
     F*********************************************************************
     Fstrbaldtl if   e             disk
     Fstrbalrpt o    e             printer oflind(*in99)

     D*********************************************************************
     D* D e f i n i t i o n s
     D*********************************************************************
     D store           s             11a
     D*Program Status Data Structure
     D/copy $DPSSR
      /Free
        //*****************************************************************
        //  M a i n  L i n e  C o d e
        //*****************************************************************
        *in99 = '1';
        //Read The File
        read(e) strbaldtl;
        dow not%eof(strbaldtl);
          if *in99;
             w@time = %Dec(%Time():*ISO);
             w@date = %Dec(%Date():*USA);
            store  = ' ';
            //Write Header
            write header;
            //Write Heading
            write heading;
            write heading1;
            *in99 = '0';
          endif;
          if store = XWAACS;
            XWAACS = ' ';
          endif;
          //Write The Field Value
          write field;
          read(e) strbaldtl;
          store = XWAACS;
        enddo;
        //Write Footer
        write footer;
       *inlr = *on;
      /end-free
     C*********************************************************************
     C* C o p y  B o o k s
     C*********************************************************************
     C*Program Status Data Structure
     C/copy $CPSSR
````
