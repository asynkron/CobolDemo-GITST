# DSPPTYPES.RPGLE Member Guide

## Overview
ILE RPG program `DSPPTYPES` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `DSPPTYPES`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2005
     H*PROGRAM:  Display Product
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2005')

     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     Fdspptypesdcf   e             workstn
     Fptypes    if   e           k disk
     Fcusfla    if   e           k disk

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D product         s              2a
     D mainloop        s              5p 0 inz(*zeros)
     D cdate           s               d   datfmt(*iso) inz(*sys)
     D*cdate1          s               d   datfmt(*iso) inz(*sys)

      /free
       // ******************************************************************
       //M a i n l i n e   C o d e
       // ******************************************************************
       dow mainloop < *hival;

       //Display screen
       exfmt(e) zzft01;
       //write(e) zzft02;
       //Action command keys
       if *in28;
       exsr zcmdkeys;
       endif;

       enddo;
       // ******************************************************************
       //L o g i c a l   E n d   o f   P r o g r a m
       // ******************************************************************

       // ******************************************************************
       begsr zgetrec;
       // ******************************************************************
       //Subroutine: Retrieve record
       // ******************************************************************
       chain(e) product rprods;

       if %found(ptypes);
       zprpcde = prpcde;
       zpdesf = pdesf;
       zpqty = pqty;
       zpunt = punt;
       zpprc = pprc;
       //zpprc1 = pprc1;
       endif;

       //Determine if current product
       exsr zcurrent;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zcurrent;
       // ******************************************************************
       //Subroutine: Determine if current product
       // ******************************************************************
       setll(e) prpcde rcusf;
       if %found(cusfla);
       zcurprod = 'YES';
       else;
       zcurprod = 'NO';
       endif;

       endsr;
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
       //exsr zfix;
       endsl;

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

       begsr *inzsr;
       // ******************************************************************
       //Subroutine: Initialisation routines
       // ******************************************************************
       //Set constants
       zmessage = 'F3=Exit  F12=Cancel';
       zzpgm = 'DSPPTYPES';
       zzdate = %char(cdate);

       //Retrieve record
       exsr zgetrec;

       endsr;
       // ******************************************************************

      /end-free

     C**********************************************************************
     C*N o n - E x e c u t a b l e   C o d e
     C**********************************************************************
     C     *entry        plist
     C                   parm                    product                        Return Code
     C**********************************************************************
````
