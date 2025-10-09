# XCMMENU.RPGLE Member Guide

## Overview
ILE RPG program `XCMMENU` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `XCMMENU`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2005
     H*PROGRAM:  X-Rev Main Menu
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2005')

     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     Fxcmmenudf cf   e             workstn

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D mainloop        s              5p 0 inz(*zeros)
     D cdate           s               d   datfmt(*iso) inz(*sys)

     D quscmdln        pr                  extpgm('QUSCMDLN')
     D cusfmaintc      pr                  extpgm('CUSFMAINTC')
     D orgmnt          pr                  extpgm('ORGMNT')
     D cus002          pr                  extpgm('CUS002')
     D wwcconsc        pr                  extpgm('WWCCONSC')
     D wwcusf          pr                  extpgm('WWCUSF')
     D wwrareasc       pr                  extpgm('WWRAREASC')

      /free
       // ******************************************************************
       //M a i n l i n e   C o d e
       // ******************************************************************
       dow mainloop < *hival;

       //Display menu
       exfmt(e) zzft01;

       //Action any requests
       select;
       //Command key
       when *in28;
       exsr zcmdkeys;
       //iter;
       //Option
       when option <> *blanks;
       exsr zoptions;
       endsl;

       enddo;
       // ******************************************************************
       //L o g i c a l   E n d   o f   P r o g r a m
       // ******************************************************************

       // ******************************************************************
       begsr zcmdkeys;
       // ******************************************************************
       //Subroutine: Action command keys
       // ******************************************************************
       select;
       when *in03;
       exsr zf03;
       when *in12;
       exsr zf12;
       when *in21;
       exsr zf21;
       endsl;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zoptions;
       // ******************************************************************
       //Subroutine: Action options
       // ******************************************************************
       select;
       when option = '1 ' or option = ' 1';
       cusfmaintc();
       when option = '2 ' or option = ' 2';
       orgmnt();
       when option = '3 ' or option = ' 3';
       cus002();
       when option = '4 ' or option = ' 4';
       wwcconsc();
       when option = '5 ' or option = ' 5';
       wwcusf();
       when option = '6 ' or option = ' 6';
       wwrareasc();
       //when option = '7 ' or option = ' 7';
       //iterreasc();
       endsl;

       option = *blanks;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zf03;
       // ******************************************************************
       //Subroutine: F3=Exit
       // ******************************************************************
       *inlr = *on;
       return;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zf12;
       // ******************************************************************
       //Subroutine: F12=Cancel
       // ******************************************************************
       *inlr = *on;
       return;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zf21;
       // ******************************************************************
       //Subroutine: F21=Command line
       // ******************************************************************
       quscmdln();

       endsr;
       // ******************************************************************

       begsr *inzsr;
       // ******************************************************************
       //Subroutine: Initialisation routines
       // ******************************************************************
       //Set constants
       zmessage = 'F3=Exit  F12=Cancel  F21=Command line';
       zzpgm = 'XCMMENU';
       zzdate = %char(cdate);

       endsr;
       // ******************************************************************

      /end-free

     C**********************************************************************
````
