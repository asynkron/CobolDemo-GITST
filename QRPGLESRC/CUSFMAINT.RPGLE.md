# CUSFMAINT.RPGLE Member Guide

## Overview
ILE RPG program `CUSFMAINT` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CUSFMAINT`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*--------------------------------------------------------------------
     H*COPYRIGHT DATABOROUGH LTD 2004
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2004') datedit(*dmy)

     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     Fcusfmaintdcf   e             workstn
     Fcusfl3    uf   e           k disk
     Fdists     if   e           k disk


     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D customer        s              5p 0
     D updated         s              1a

     D valid           s               n
     D errormsg        s            132a
     D msgid           s              7a
     D z1              s              5p 0
     D statuses        s              1a   dim(37) ctdata perrcd(37)            CMD Key Data

     D zdate           ds            11
     D zday                           2a
     D filler1                        1a
     D zmth                           3a
     D filler2                        1a
     D zyr                            4a

     D gotdate         s             10d   datfmt(*eur)
     D xmth            s              2p 0
     D mth             s             36a

     D rtnmsgtext      pr                  extpgm('RTNMSGTEXT')
     D                                7a   const
     D                              132a

     D cusfsel         pr                  extpgm('CUSFSEL')
     D                                5p 0

     D dspdists        pr                  extpgm('DSPDISTS')
     D                                2a

     D wwccons         pr                  extpgm('WWCCONS')
     D                                5p 0

     D wwrareas        pr                  extpgm('WWRAREAS')
     D                                3a


     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
     C*Retrieve record
     C     cusno         chain(e)  rcusf
     C                   if        not %found(cusfl3)
     C                   eval      *inlr = *on
     C                   return
     C                   endif

     C*Set screen values
     C                   exsr      writescn
     C                   eval      zmessage='Please make required changes.'

     C*Until Exit/Cancel
     C                   dow       not *in03
     C                              and not *in12

     C*Display screen
     C                   exfmt(e)  zzft01

     C*If Exit/Cancel
     C                   if        *in03
     C                              or *in12
     C                   leave
     C                   endif

     C*Other Command Keys
     C                   select
     C                   when      *in08
     C                   callp(e)  wwccons(zcusno)
     C                   iter
     C                   when      *in09
     C                   callp(e)  dspdists(zdsdcde)
     C                   iter
     C                   when      *in10
     C                   callp(e)  wwrareas(zsinit)
     C                   iter
     C**                 when      *in03
     C**                 exsr      zexit
     C                   endsl

     C*Else validate
     C                   exsr      validate

     C*If valid
     C                   if        valid
     C*Update file and leave
     C                   exsr      updatefile
     C                   leave
     C*Else: If not valid
     C                   else
     C*Display error message
     C                   eval      zmessage = errormsg
     C*End: If valid
     C                   endif

     C*End: Until Exit/Cancel
     C                   enddo

     C                   eval      *inlr = *on
     C                   return
     C**********************************************************************
     C*L o g i c al   E n d   o f   P r o g r a m
     C**********************************************************************

     C**********************************************************************
     C     writescn      begsr
     C**********************************************************************
     C*Subroutine: Write screen
     C**********************************************************************
     C                   eval      zcusno = cusno
     C                   eval      zcname = cname
     C                   eval      zadd1 = add1
     C                   eval      zadd2 = add2
     C                   eval      zadd3 = add3
     C                   eval      zadd4 = add4
     C                   eval      zcntry = cntry
     C                   eval      zpscd = pscd
     C                   eval      ztelno = telno
     C                   eval      zfaxno = faxno
     C                   eval      zemail = email
     C                   eval      zwebsit = websit
     C                   eval      zdsdcde = dsdcde
     C                   eval      zsinit = sinit
     C                   eval      zstatus = status
     C                   eval      zusernm = usernm
     C                   eval      zsalut = salut
     C                   eval      zjtitle = jtitle
     C     *YMD          move      lctdat        zlctdat
     C     *YMD          move      apdate        zapdate

     C                   endsr
     C**********************************************************************

     C**********************************************************************
     C     updatefile    begsr
     C**********************************************************************
     C*Subroutine: Update file
     C**********************************************************************
     C                   eval      cusno = zcusno
     C                   eval      cname = zcname
     C                   eval      add1 = zadd1
     C                   eval      add2 = zadd2
     C                   eval      add3 = zadd3
     C                   eval      add4 = zadd4
     C                   eval      cntry = zcntry
     C                   eval      pscd = zpscd
     C                   eval      telno = ztelno
     C                   eval      faxno = zfaxno
     C                   eval      email = zemail
     C                   eval      websit = zwebsit
     C                   eval      dsdcde = zdsdcde
     C                   eval      sinit = zsinit
     C***                eval      snote = znote
     C                   eval      status = zstatus
     C                   eval      usernm = zusernm
     C                   eval      salut = zsalut
     C                   eval      jtitle = zjtitle
     C     *YMD          move      zlctdat       lctdat
     C     *YMD          move      zapdate       apdate

     C                   update(e) rcusf
     C                   if        not %error
     C                   eval      updated = 'Y'
     C                   endif

     C                   endsr
     C**********************************************************************

     C**********************************************************************
     C*Subroutine: Validate screen
     C**********************************************************************
     C     validate      begsr
     C**********************************************************************
     C                   eval      *in32 = *off
     C                   eval      *in33 = *off
     C                   eval      *in34 = *off
     C                   eval      *in35 = *off
     C                   eval      *in36 = *off
     C                   eval      *in37 = *off
     C                   eval      *in38 = *off
     C                   eval      *in39 = *off
     C                   eval      *in40 = *off
     C                   eval      *in41 = *off
     C                   eval      *in42 = *off
     C                   eval      *in43 = *off
     C                   eval      *in44 = *off

     C                   eval      valid = *on

     C*Customer name
     C                   if        zcname = *blanks
     C                   eval      *in32 = *on
     C                   eval      msgid = 'OEM0012'
     C                   callp(e)  rtnmsgtext(msgid:errormsg)
     C                   eval      valid = *off
     C                   leavesr
     C                   endif

     C*Telephone number
     C                   if        ztelno <> *blanks
     C     ' 0123456789' check     ztelno        z1
     C                   if        %found
     C                   eval      *in34 = *on
     C                   eval      msgid = 'OEM0014'
     C                   callp(e)  rtnmsgtext(msgid:errormsg)
     C                   eval      valid = *off
     C                   leavesr
     C                   endif
     C                   endif

     C*Fax number
     C                   if        zfaxno <> *blanks
     C     ' 0123456789' check     zfaxno        z1
     C                   if        %found
     C                   eval      *in35 = *on
     C                   eval      msgid = 'OEM0015'
     C                   callp(e)  rtnmsgtext(msgid:errormsg)
     C                   eval      valid = *off
     C                   leavesr
     C                   endif
     C                   endif

     C*Distributor
     C                   if        zdsdcde <> *blanks
     C     zdsdcde       setll(e)  rprods
     C                   if        not %equal(dists)
     C                   eval      *in38 = *on
     C                   eval      msgid = 'OEM0018'
     C                   callp(e)  rtnmsgtext(msgid:errormsg)
     C                   eval      valid = *off
     C                   leavesr
     C                   endif
     C                   endif

     C*Status
     C                   if        zstatus <> *blanks
     C                   eval      z1 = 1
     C     zstatus       lookup    statuses(z1)                           77
     C                   if        not %found
     C                   eval      *in39 = *on
     C                   eval      msgid = 'OEM0019'
     C                   callp(e)  rtnmsgtext(msgid:errormsg)
     C                   eval      valid = *off
     C                   leavesr
     C                   endif
     C                   endif

     C*Contact
     C                   if        zusernm = *blanks
     C                   eval      *in40 = *on
     C                   eval      msgid = 'OEM0020'
     C                   callp(e)  rtnmsgtext(msgid:errormsg)
     C                   eval      valid = *off
     C                   leavesr
     C                   endif

     C*Title
     C                   if        zsalut <> *blanks
     C                   if        zsalut <> 'Mr'
     C                              and zsalut <> 'Mrs'
     C                              and zsalut <> 'Ms'
     C                              and zsalut <> 'Dr'
     C                   eval      *in41 = *on
     C                   eval      msgid = 'OEM0021'
     C                   callp(e)  rtnmsgtext(msgid:errormsg)
     C                   eval      valid = *off
     C                   leavesr
     C                   endif
     C                   endif

     C                   endsr
     C**********************************************************************

     C**********************************************************************
     C     *inzsr        begsr
     C**********************************************************************
     C*Subroutine: Perform Initialisation Routines
     C**********************************************************************
     C*Set screen values
     C*- Program name
     C                   eval      zzpgm = 'CUSFMAINT'
     C*- Date
     C                   eval      mth='JanFebMarAprMayJunJulAugSepOctNovDec'
     C                   move      *date         gotdate
     C                   extrct    gotdate:*d    zday
     C                   extrct    gotdate:*y    zyr
     C                   extrct    gotdate:*m    xmth
     C                   eval      zmth = %subst(mth:((xmth-1)*3)+1:3)
     C                   eval      zzdate = zdate
     C*- Protect customr number
     C                   eval      *in31 = *on

     C*If customer number not provided then prompt
     C                   if        customer = *zeros
     C                   callp(e)  cusfsel(customer)
     C                   endif

     C*Set customer number
     C                   eval      cusno = customer

     C*Initialise updated flag
     C                   eval      updated = 'N'

     C                   endsr
     C**********************************************************************

     C**********************************************************************
     C*N o n - E x e c u t a b l e   C o d e
     C**********************************************************************
     C     *entry        plist
     C                   parm                    customer                       Return Code
     C                   parm                    updated                        Return Code
     C**********************************************************************
**
 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
````
