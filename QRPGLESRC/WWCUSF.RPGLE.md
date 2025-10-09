# WWCUSF.RPGLE Member Guide

## Overview
ILE RPG program `WWCUSF` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `WWCUSF`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2005
     H*PROGRAM:  Work with Customer Sites
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2005')

     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     Fwwcusfd   cf   e             workstn sfile(zzsf01:sflrrn)
     Fcusfl3    uf a e           k disk
     Fdists     if   e           k disk

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D sflchanged      s               n   inz(*off)
     D sflrrn          s              5p 0
     D zcmd            s            200a
     D zupdated        s              1a
     D mainloop        s              5p 0 inz(*zeros)
     D cdate           s               d   datfmt(*iso) inz(*sys)
     D statuses        s              1a   dim(37) ctdata perrcd(37)            CMD Key Data

     D xbcclmsg        pr                  extpgm('XBCCLMSG')

     D xmcsnmsg        pr                  extpgm('XMCSNMSG')
     D                                7a   const
     D                               10a   const
     D                               10a   const
     D                               50a   const
     D                               10a   const
     D                                7a   const

     D cusfmaint       pr                  extpgm('CUSFMAINT')
     D                                5p 0 const
     D                                1a

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
       // Leave;
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

       setll(e) *loval rcusf;
       read(e) rcusf;

       dow not %eof(cusfl3) and not %error;

       sflrrn = sflrrn + 1;
       dssel = *blanks;
       dscusno = cusno;
       dscname = cname;
       dstelno = telno;
       write(e) zzsf01;

       read(e) rcusf;
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
       //*in61 = *off;

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

       //Change
       when dssel = ' 2' or dssel = '2 ';
       cusfmaint(dscusno:zupdated);
       dsprec = sflrrn;

       //Delete
       when dssel = ' 4' or dssel = '4 ';
       exsr zdelete;
       if sflrrn > 1;
       dsprec = sflrrn - 1;
       else;
       dsprec = 1;
       endif;

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
       begsr zdelete;
       // ******************************************************************
       //Subroutine: Delete record
       // ******************************************************************
       chain(e) dscusno rcusf;

       if %found(cusfl3);

       dscusno = cusno;
       dscname = cname;
       dsadd1 = add1;
       dsadd2 = add2;
       dsadd3 = add3;
       dsadd4 = add4;
       dscntry = cntry;
       dspscd = pscd;
       dstelno = telno;
       dsfaxno = faxno;
       dsemail = email;
       dswebsit = websit;
       dsdsdcde = dsdcde;
       dsstatus = status;
       dsusernm = usernm;
       *in23='1';

       dow not *in03 and not *in12;

       write(e) zzmc01;
       exfmt(e) zzft01;
       xbcclmsg();

       if not *in03 and not *in12;

       delete(e) rcusf;

       //"Record deleted."
       xmcsnmsg('OEM0030':'OEMSGF':'XRAPPS':' ':'*PRV':'*COMP');
       leave;

       endif;

       enddo;

       endif;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zdisplay;
       // ******************************************************************
       //Subroutine: Display record
       // ******************************************************************
       chain(e) dscusno rcusf;

       if %found(cusfl3);

       dscusno = cusno;
       dscname = cname;
       dsadd1 = add1;
       dsadd2 = add2;
       dsadd3 = add3;
       dsadd4 = add4;
       dscntry = cntry;
       dspscd = pscd;
       dstelno = telno;
       dsfaxno = faxno;
       dsemail = email;
       dswebsit = websit;
       dsdsdcde = dsdcde;
       //dsdsde = dsdcde;
       dsstatus = status;
       dsusernm = usernm;
       *in23='0';

       dow not *in03 and not *in12;

       *in34 = *on;
       write(e) zzmc01;
       exfmt(e) zzft01;
       xbcclmsg();

       enddo;

       endif;

       endsr;
       // ******************************************************************

       // ******************************************************************
       begsr zadd;
       // ******************************************************************
       //Subroutine: Add record
       // ******************************************************************
       dscusno = *zeros;
       dscname = *blanks;
       dsadd1 = *blanks;
       dsadd2 = *blanks;
       dsadd3 = *blanks;
       dsadd4 = *blanks;
       dscntry = *blanks;
       dspscd = *blanks;
       //dspscdse = *blanks;
       dstelno = *blanks;
       dsfaxno = *blanks;
       dsemail = *blanks;
       dswebsit = *blanks;
       dsdsdcde = *blanks;
       dsstatus = *blanks;
       dsusernm = *blanks;

       *in03 = *off;
       *in12 = *off;
       *in23 = *off;

       dow not *in03 and not *in12;

       *in34 = *off;
       write(e) zzmc01;
       exfmt(e) zzft02;
       xbcclmsg();

       *in50 = *off;
       *in51 = *off;
       *in52 = *off;
       *in53 = *off;
       *in54 = *off;
       *in55 = *off;
       *in56 = *off;
       *in57 = *off;
       *in58 = *off;
       *in59 = *off;
       *in60 = *off;

       if not *in03 and not *in12;

       //Customer number
       if dscusno = *zeros;
       *in51 = *on;
       xmcsnmsg('OEM0002':'OEMSGF':'XRAPPS':' ':'*PRV':'*COMP');
       iter;
       endif;

       //Customer name
       if dscname = *blanks;
       *in52 = *on;
       xmcsnmsg('OEM0012':'OEMSGF':'XRAPPS':' ':'*PRV':'*COMP');
       iter;
       endif;

       //Telephone number
       if dstelno <> *blanks;
       if %check(' 0123456789':dstelno) > *zeros;
       *in54 = *on;
       xmcsnmsg('OEM0014':'OEMSGF':'XRAPPS':' ':'*PRV':'*COMP');
       iter;
       endif;
       endif;

       //Fax number
       if dsfaxno <> *blanks;
       if %check(' 0123456789':dsfaxno) > *zeros;
       *in55 = *on;
       xmcsnmsg('OEM0015':'OEMSGF':'XRAPPS':' ':'*PRV':'*COMP');
       iter;
       endif;
       endif;

       //Distributor
       if dsdsdcde <> *blanks;
       setll(e) dsdsdcde rprods;
       if not %equal(dists);
       *in58 = *on;
       xmcsnmsg('OEM0018':'OEMSGF':'XRAPPS':' ':'*PRV':'*COMP');
       iter;
       endif;
       endif;

       //Status
       if dsstatus <> *blanks;
       if %lookup(dsstatus:statuses) = *zeros;
       *in59 = *on;
       xmcsnmsg('OEM0019':'OEMSGF':'XRAPPS':' ':'*PRV':'*COMP');
       iter;
       endif;
       endif;

       //Contact
       if dsusernm = *blanks;
       *in60 = *on;
       xmcsnmsg('OEM0020':'OEMSGF':'XRAPPS':' ':'*PRV':'*COMP');
       iter;
       endif;

       clear rcusf;
       cusno = dscusno;
       cname = dscname;
       add1 = dsadd1;
       add2 = dsadd2;
       add3 = dsadd3;
       add4 = dsadd4;
       cntry = dscntry;
       pscd = dspscd;
       telno = dstelno;
       faxno = dsfaxno;
       email = dsemail;
       websit = dswebsit;
       dsdcde = dsdsdcde;
       status = dsstatus;
       usernm = dsusernm;
       write(e) rcusf;

       //"Record added."
       xmcsnmsg('OEM0031':'OEMSGF':'XRAPPS':' ':'*PRV':'*COMP');

       leave;

       endif;

       enddo;

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
       when *in06;
       exsr zadd;
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
       zzpgm = 'WWCUSF';

       //Set date
       zzdate = %char(cdate);

       endsr;
       // ******************************************************************

      /end-free
**
 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
````
