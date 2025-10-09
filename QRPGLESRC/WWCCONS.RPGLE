     H*‚--------------------------------------------------------------------
     H*ˆCOPYRIGHT DATABOROUGH LTD 2005
     H*ˆPROGRAM:  Work with Customer Contacts
     H*‚--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2005')

     F**********************************************************************
     F*‚F i l e s
     F**********************************************************************
     Fwwcconsd  cf   e             workstn sfile(zzsf01:sflrrn)
     Fcntacs    if   e           k disk

     D**********************************************************************
     D*‚D e f i n i t i o n s
     D**********************************************************************
     D customer        s              5p 0
     D sflchanged      s               n   inz(*off)
     D sflrrn          s              5p 0
     D zcmd            s            200a
     D mainloop        s              5p 0 inz(*zeros)
     D cdate           s               d   datfmt(*iso) inz(*sys)
     D dsdate          s               d   datfmt(*iso)

     D xfdate          ds             6
     D  numdate                       6s 0
     D  chardate                      6a   overlay(numdate)

     D xbcclmsg        pr                  extpgm('XBCCLMSG')

     D xmcsnmsg        pr                  extpgm('XMCSNMSG')
     D                                7a   const
     D                               10a   const
     D                               10a   const
     D                               50a   const
     D                               10a   const
     D                                7a   const

     D cusfsel         pr                  extpgm('CUSFSEL')
     D                                5p 0

      /free
       // ******************************************************************
       //‚M a i n l i n e   C o d e
       // ******************************************************************
       dow mainloop < *hival;

       //‚Build subfile
       exsr zsflwrt;
       //‚Display screens
       write(e) zztr01;
       write(e) zzmc01;
       exfmt(e) zzct01;
       //‚Remove messages
       xbcclmsg();
       //‚Action command keys
       if *in28;
       exsr zcmdkeys;
       else;
       //‚Else action selections
       exsr zselect;
       endif;

       enddo;
       // ******************************************************************
       //‚L o g i c a l   E n d   o f   P r o g r a m
       // ******************************************************************

       // ******************************************************************
       begsr zsflwrt;
       // ******************************************************************
       //‚Subroutine: Write data to subfile
       // ******************************************************************
       //‚Delete subfile
       if *in40;
       *in30 = *on;
       write(e) zzct01;
       *in30 = *off;
       endif;
       //‚Write subfile
       *in31 = *off;
       sflrrn = *zeros;

       setll(e) customer rcntac;
       reade(e) customer rcntac;

       dow not %eof(cntacs) and not %error;

       sflrrn = sflrrn + 1;
       dssel = *blanks;
       dsprpcde = prpcde;
       dsusernm = usernm;
       dstelno = telno;
       write(e) zzsf01;

       reade(e) customer rcntac;
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
       //‚Subroutine: Action selection
       // ******************************************************************
       sflchanged = *off;

       readc(e) zzsf01;

       //‚For each selection
       dow not %eof and not %error;

       sflchanged = *on;

       select;

       //‚Display
       when dssel = ' 5' or dssel = '5 ';
       exsr zdisplay;
       dsprec = sflrrn;

       endsl;

       dssel = *blanks;
       update(e) zzsf01;

       readc(e) zzsf01;

       //‚End: For each selection
       enddo;

       //‚If changes made then update display
       if sflchanged;
       exsr zsflwrt;
       endif;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zdisplay;
       // ******************************************************************
       //‚Subroutine: Display record
       // ******************************************************************
       chain(e) dscusno rcntac;

       if %found(cntacs);

       dscusno = cusno;
       dsprpcde = prpcde;
       dsusernm = usernm;
       dstelno = telno;
       dsfaxno = faxno;
       dsemail = email;
       //dsemail = email;
       numdate = lctdat;
       dsdate = %date(chardate:*YMD0);
       dslctdat = %char(dsdate);
       numdate = apdate;
       dsdate = %date(chardate:*YMD0);
       dsapdate = %char(dsdate);
       dssinit = sinit;
       dsstatus = status;

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
       //‚Subroutine: Action command keys
       // ******************************************************************
       select;
       when *in03;
       exsr zf03;
       when *in12;
       exsr zf12;
       // leavesr;
       endsl;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zf03;
       // ******************************************************************
       //‚Subroutine: F3=Exit
       // ******************************************************************
       *inlr = *on;
       return;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zf12;
       // ******************************************************************
       //‚Subroutine: F12=Cancel
       // ******************************************************************
       *inlr = *on;
       return;

       endsr;
       // ******************************************************************

       begsr *inzsr;
       // ******************************************************************
       //‚Subroutine: Initialisation routines
       // ******************************************************************

       //‚Initialise message subfile
       *in32 = *on;
       zzpgm = 'WWCCONS';

       //‚Set date
       zzdate = %char(cdate);

       //‚If customer number not provided then prompt
       if customer = *zeros;
       cusfsel(customer);
       endif;

       //‚Set displayed customer no.
       dscusno = customer;

       endsr;
       // ******************************************************************

      /end-free

     C**********************************************************************
     C*‚N o n - E x e c u t a b l e   C o d e
     C**********************************************************************
     C     *entry        plist
     C                   parm                    customer                       Return Code
     C**********************************************************************
