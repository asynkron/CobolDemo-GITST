# WWRAREAS.RPGLE Member Guide

## Overview
ILE RPG program `WWRAREAS` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `WWRAREAS`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2005
     H*PROGRAM:  Work with Rep. Delivery Areas
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2005')

     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     Fwwrareasd cf   e             workstn sfile(zzsf01:sflrrn)
     Fdelival1  if   e           k disk

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D rep             s              3a
     D sflchanged      s               n   inz(*off)
     D sflrrn          s              5p 0
     D zcmd            s            200a
     D mainloop        s              5p 0 inz(*zeros)
     D cdate           s               d   datfmt(*iso) inz(*sys)

     D xbcclmsg        pr                  extpgm('XBCCLMSG')

     D xmcsnmsg        pr                  extpgm('XMCSNMSG')
     D                                7a   const
     D                               10a   const
     D                               10a   const
     D                               50a   const
     D                               10a   const
     D                                7a   const

     D smensel         pr                  extpgm('SMENSEL')
     D                                3a


      /free
       // ******************************************************************
       //M a i n l i n e   C o d e
       // ******************************************************************
       dow mainloop < *hival;

       //Build subfile
       exsr zsflwrt;
       //Display screens
       write(e) zztr01;
       write(e) zzmc01;
       exfmt(e) zzct01;
       //Remove messages
       xbcclmsg();
       //Action command keys
       if *in28;
       exsr zcmdkeys;
       else;
       //Else action selections
       exsr zselect;
       endif;

       enddo;
       // ******************************************************************
       //L o g i c a l   E n d   o f   P r o g r a m
       // ******************************************************************

       // ******************************************************************
       begsr zsflwrt;
       // ******************************************************************
       //Subroutine: Write data to subfile
       // ******************************************************************
       //Delete subfile
       if *in40;
       *in30 = *on;
       write(e) zzct01;
       *in30 = *off;
       endif;
       //Write subfile
       *in31 = *off;
       sflrrn = *zeros;

       setll(e) rep delivar;
       reade(e) rep delivar;

       dow not %eof(delival1) and not %error;

       sflrrn = sflrrn + 1;
       dssel = *blanks;
       dsxwbdcd = xwbdcd;
       dsxwgxtx = xwgxtx;
       write(e) zzsf01;

       reade(e) rep delivar;
       enddo;

       if sflrrn > *zeros;

       if not sflchanged;
       dsprec = 1;
       endif;

       if dsprec > sflrrn
        or dsprec < 1;
       dsprec = 1;
       endif;

       *in40 = *on;
       *in31 = *on;

       endif;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zselect;
       // ******************************************************************
       //Subroutine: Action selection
       // ******************************************************************
       sflchanged = *off;

       readc(e) zzsf01;

       //For each selection
       dow not %eof and not %error;

       sflchanged = *on;

       select;

       //Display
       when dssel = ' 5' or dssel = '5 ';
       exsr zdisplay;
       dsprec = sflrrn;

       endsl;

       dssel = *blanks;
       update(e) zzsf01;

       readc(e) zzsf01;

       //End: For each selection
       enddo;

       //If changes made then update display
       if sflchanged;
       exsr zsflwrt;
       endif;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zdisplay;
       // ******************************************************************
       //Subroutine: Display record
       // ******************************************************************
       chain(e) dsperson delivar;

       if %found(delival1);

       dsperson = person;
       dsxwbdcd = xwbdcd;
       dsxwgxtx = xwgxtx;

       dow not *in03 and not *in12;

       *in34 = *on;
       write(e) zztr01;
       write(e) zzmc01;
       exfmt(e) zzft01;
       xbcclmsg();

       enddo;

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

       //Initialise message subfile
       *in32 = *on;
       zzpgm = 'WWRAREAS';

       //Set date
       zzdate = %char(cdate);

       //If rep code not provided then prompt
       if rep = *blanks;
       smensel(rep);
       endif;

       //Set displayed rep code
       dsperson = rep;

       endsr;
       // ******************************************************************

      /end-free

     C**********************************************************************
     C*N o n - E x e c u t a b l e   C o d e
     C**********************************************************************
     C     *entry        plist
     C                   parm                    rep                            Return Code
     C**********************************************************************
````
