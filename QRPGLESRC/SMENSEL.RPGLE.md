# SMENSEL.RPGLE Member Guide

## Overview
ILE RPG program `SMENSEL` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `SMENSEL`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2005
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2005')

     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     Fsmenseld  cf   e             workstn sfile(zzsfl:zsflrrn)
     Fslmen     if   e           k disk

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D salesman        s              3a
     D zsflrrn         s              5p 0 inz

      /free
       // ******************************************************************
       //M a i n l i n e   C o d e
       // ******************************************************************
       //Build subfile
       exsr zbuild;

       //Until Exit/Cancel
       dow not *in03
        and not *in12;

       //Display screen
       exfmt(e) zzctl;

       //If Exit/Cancel
       if *in03
        or *in12;
       salesman = *blanks;
       leave;

       endif;

       //If selection made
       readc(e) zzsfl;
       if not %eof(smenseld);
       salesman = dsperson;
       leave;
       endif;

       //End: Until Exit/Cancel
       enddo;

       //Terminate program
       *inlr = *on;
       return;
       // ******************************************************************
       //L o g i c a l   E n d   o f   P r o g r a m
       // ******************************************************************

       // ******************************************************************
       begsr zbuild;
       // ******************************************************************
       //Subroutine: Build subfile
       // ******************************************************************
       zsflrrn = *zeros;

       setll(e) *loval rslmen;
       read(e) rslmen;

       dow not %eof(slmen) and not %error;
       zsflrrn = zsflrrn + 1;
       dsperson = person;
       dspname = pname;
       //dspcume = pcume;
       write(e) zzsfl;
       read(e) rslmen;
       enddo;

       if zsflrrn > *zeros;
       *in31 = *on;
       endif;

       endsr;
       // ******************************************************************

      /end-free
     C**********************************************************************
     C*N o n - e x e c u t a b l e   C o d e
     C**********************************************************************
     C**ENTRY Parameter List
     C     *entry        plist
     C                   parm                    salesman
     C**********************************************************************
````
