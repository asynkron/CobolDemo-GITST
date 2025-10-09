# CNTCMAINT.RPGLE Member Guide

## Overview
ILE RPG program `CNTCMAINT` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CNTCMAINT`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*COPYRIGHT DATABOROUGH LTD 2005
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Databorough Ltd. 2005') datedit(*dmy)

     F**********************************************************************
     F*F i l e s
     F**********************************************************************
     Fcntcmaintdcf   e             workstn
     Fcntacs    uf   e           k disk
     Fnamesidx  uf   e           k disk
     Fslmen     if   e           k disk

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D customer        s              5p 0
     D product         s              2a

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

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
     C*Retrieve record
     C     cntacskey     chain(e)  rcntac
     C                   if        not %found(cntacs)
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
     C                   eval      zprpcde = prpcde
     C                   eval      zusernm = usernm
     C                   eval      ztelno = telno
     C                   eval      zfaxno = faxno
     C                   eval      zemail = email
     C     *YMD          move      lctdat        zlctdat
     C     *YMD          move      apdate        zapdate
     C**   *YMD          move      apudate       zapudate
     C                   eval      zsinit = sinit
     C                   eval      zstatus = status

     C                   endsr
     C**********************************************************************

     C**********************************************************************
     C     updatefile    begsr
     C**********************************************************************
     C*Subroutine: Update file
     C**********************************************************************
     C                   eval      cusno = zcusno
     C                   eval      prpcde = zprpcde
     C                   eval      usernm = zusernm
     C                   eval      telno = ztelno
     C**                 eval      telno = ztelno
     C                   eval      faxno = zfaxno
     C                   eval      email = zemail
     C     *YMD          move      zlctdat       lctdat
     C     *YMD          move      zapdate       apdate
     C                   eval      sinit = zsinit
     C                   eval      status = zstatus

     C                   update(e) rcntac

     C*If update successful then update names index file
     C                   if        not %error

     C                   eval      ixname = usernm
     C     ixname        chain(e)  namesidxf
     C                   if        %found(namesidx)
     C                   eval      ixtelno = telno
     C                   eval      ixemail = email
     C                   update(e) namesidxf
     C                   endif

     C                   endif

     C                   endsr
     C**********************************************************************

     C**********************************************************************
     C*Subroutine: Validate screen
     C**********************************************************************
     C     validate      begsr
     C**********************************************************************
     C                   eval      *in33 = *off
     C                   eval      *in34 = *off
     C                   eval      *in35 = *off
     C                   eval      *in36 = *off
     C                   eval      *in37 = *off
     C                   eval      *in38 = *off
     C                   eval      *in43 = *off

     C                   eval      valid = *on

     C*Contact name
     C                   if        zusernm = *blanks
     C                   eval      *in33 = *on
     C                   eval      msgid = 'OEM0020'
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

     C*Salesman
     C                   if        zsinit <> *blanks
     C     zsinit        setll(e)  rslmen
     C                   if        not %equal(slmen)
     C                   eval      *in37 = *on
     C                   eval      msgid = 'OEM0023'
     C***                eval      msgid = 'OEM0157'
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
     C                   eval      *in38 = *on
     C                   eval      msgid = 'OEM0019'
     C                   callp(e)  rtnmsgtext(msgid:errormsg)
     C                   eval      valid = *off
     C                   leavesr
     C                   endif
     C                   endif

     C                   exsr      testEmail
     C                   exsr      testEmail

     C                   endsr
     C**********************************************************************

     C**********************************************************************
     C     testEmail     begsr
     C**********************************************************************
     C*Subroutine: Write screen
     C**********************************************************************
     C                   eval      pmsg = 'Hello World'
     C                   call      'SNDEMAIL'
     C                   parm      zemail        pemail          250
     C                   parm                    pmsg           2500
     C                   endsr
     C
     C**********************************************************************
     C     *inzsr        begsr
     C**********************************************************************
     C*Subroutine: Perform Initialisation Routines
     C**********************************************************************
     C*Set screen values
     C*- Program name
     C                   eval      zzpgm = 'CNTCMAINT'
     C*- Date
     C                   eval      mth='JanFebMarAprMayJunJulAugSepOctNovDec'
     C                   move      *date         gotdate
     C                   extrct    gotdate:*d    zday
     C                   extrct    gotdate:*y    zyr
     C                   extrct    gotdate:*m    xmth
     C                   eval      zmth = %subst(mth:((xmth-1)*3)+1:3)
     C                   eval      zzdate = zdate

     C*- Protect key fields
     C                   eval      *in31 = *on
     C                   eval      *in32 = *on
     C***                eval      *in35 = *off

     C*Set customer number, product code
     C                   eval      cusno = customer
     C                   eval      prpcde = product

     C                   endsr
     C**********************************************************************

     C**********************************************************************
     C*N o n - E x e c u t a b l e   C o d e
     C**********************************************************************
     C     *entry        plist
     C                   parm                    customer                       Return Code
     C                   parm                    product                        Return Code

     C     cntacskey     klist
     C                   kfld                    cusno                          Return Code
     C                   kfld                    prpcde                         Return Code
     C**********************************************************************
**
 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
````
