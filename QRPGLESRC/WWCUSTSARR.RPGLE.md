# WWCUSTSARR.RPGLE Member Guide

## Overview
ILE RPG program `WWCUSTSARR` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `WWCUSTSARR`.
- **Outgoing:**
  - Calls programs/procedures: RTNMTX

## Source
````rpg
      //--------------------------------------------------------------------
      //COPYRIGHT DATABOROUGH LTD 2007
      //PROGRAM:  Work with Customers
      //--------------------------------------------------------------------
     H DATEDIT(*YMD)
     H OPTION(*NODEBUGIO:*SRCSTMT)
      //*********************************************************************
      //F i l e s
      //*********************************************************************
     FWCUSTSDARRCF   E             WORKSTN
     FCUSTS     UF A E           K DISK
     F                                     INFDS(FILEDS)
     FSLMEN     IF   E           K DISK
     FCUSFL3    IF   E           K DISK
     FCUSGRP    IF   E           K DISK
     FDISTS     IF   E           K DISK
     FCONHDRL1  IF   E           K DISK
     FTRNHSTL3  IF   E           K DISK
      //*********************************************************************
      //D e f i n i t i o n s
      //*********************************************************************
      //Set constants



      // On-screen array and index:
     D OSArrIdx        S             10U 0

     D                 DS
     D OSArr                   1    624A   Dim(12)
     D  OSA01                  1     52A
     D  OSA02                 53    104A
     D  OSA03                105    156A
     D  OSA04                157    208A
     D  OSA05                209    260A
     D  OSA06                261    312A
     D  OSA07                313    364A
     D  OSA08                365    416A
     D  OSA09                417    468A
     D  OSA10                469    520A
     D  OSA11                521    572A
     D  OSA12                573    624A

      // Selection array and index:
     D DSSELIdx        S             10U 0

     D                 DS
     D DSSEL                   1     12A   Dim(12)
     D  DSSEL01                1      1A
     D  DSSEL02                2      2A
     D  DSSEL03                3      3A
     D  DSSEL04                4      4A
     D  DSSEL05                5      5A
     D  DSSEL06                6      6A
     D  DSSEL07                7      7A
     D  DSSEL08                8      8A
     D  DSSEL09                9      9A
     D  DSSEL10               10     10A
     D  DSSEL11               11     11A
     D  DSSEL12               12     12A

     D Count           S             10U 0 Inz(0)

     D RTNMTX          C                   CONST('RTNMSGTEXT')
     D INIDAT          C                   CONST('0001-01-01')

     d FILEDS          ds
     d  FILESTS               11     15s 0

     D  sflrrn         s              5p 0
     D  sflchg         s              1a   inz('0')
     D  sflCTR         s              3P 0

     D                 DS                  INZ
     D  ZDATE                  1     10
     D  ZYR                    1      4
     D  FILLR1                 5      5
     D  ZMTH                   6      7
     D  FILLR2                 8      8
     D  ZDAY                   9     10

     D CUSTMNT1        PR                  ExtPgm('CUSTMNT1')
     D  XWBCCD                       11A   Const

      //*********************************************************************
     IRCUSF
     I              DSDCDE                      XSDCDE

      //*********************************************************************
      //M a i n l i n e   C o d e
      //*********************************************************************
      //Build subfile
      /Free
       ExSR SflWrt;

       DoW *IN03 = *OFF and *IN12 = *OFF;
         LOCATE = *BLANKS;
         //Display screens
         Write ZZTR01;
         If *IN99;
           Write ZZMC01;
         EndIf;
         ExFmt FLTSCN;
         //Remove messages
      /END-FREE
     C                   CALL      'XBCCLMSG'
      /FREE
         IF *IN03 = '1'
         OR *IN12 = '1';
           Leave;
         EndIf;
         //Action positioner request
         If LOCATE <> *BLANKS;
           SFLRRN = 0;
           XWBCCD = LOCATE;
           ExSR SflWrt;
           Iter;
         EndIf;
         //Action command keys
         If *IN28;
           ExSR CmdKey;
         Else;
           //Else action selections
           ExSR ZSelec;
         EndIf;
         //If changes made then update display
         If SFLCHG = *ON;
           XWBCCD = *LOVAL;
           ExSR SflWrt;
         EndIf;

       EndDo;

       *INLR = *ON;
       Return;

       //*********************************************************************
       //L o g i c a l   E n d   o f   P r o g r a m
       //*********************************************************************

       //*********************************************************************
       BegSR SflWrt;
         //*********************************************************************
         //Subroutine: Write data to subfile
         //*********************************************************************
         //Delete subfile
         If SFLRRN = 0;
           *IN74 = *ON;
           *IN71 = *OFF;
           *IN72 = *OFF;
           *IN81 = *OFF;
           *IN74 = *OFF;
           Clear OSArr;
           SFLRRN = 0;
           SETLL XWBCCD CUSTS;
         EndIf;
         Clear OSArr;
         SFLCTR = 0;
         DOW *IN81 = '0'
         AND SFLCTR < 12;
           READ(N) CUSTS;
           *IN81 = %EOF;
           If *IN81 = '0';
             SFLRRN += 1;
             SFLCTR += 1;
             If SFLCTR = 1;
               SHWREC = SFLRRN;
             EndIf;
             DSSEL(SFLCTR) = *BLANKS;
             If SFLCTR >= 1 and SFLCTR <= %ELEM(OSArr);
               %Subst(OSArr(SFLCTR):1:11) = XWBCCD;
               %Subst(OSArr(SFLCTR):13:40) = XWG4TX;
               DSSEL(SFLCTR) = *BLANKS;
             EndIf;
           EndIf;
         EndDo;

         If SFLRRN > 0;
           *IN71 = *ON;
         EndIf;
         *IN72 = *ON;

       EndSr;
       //*********************************************************************

       //*********************************************************************
       BegSR CmdKey;
         //*********************************************************************
         //Subroutine: Action command keys
         //*********************************************************************
         Select;

         When *IN26 = '1';
           ExSR SFLWRT;

         When *IN06 = '1';
           EXSR addrec;
           SHWREC = 1;
           SFLCHG = '1';
         EndSl;                                                               //E---------01

         *IN12 = *OFF;
       EndSr;
       //*********************************************************************

       //*********************************************************************
       BegSr ZSelec;
         //*********************************************************************
         //Subroutine: Action selection
         //*********************************************************************
         SFLCHG = *OFF;

         //For each selection
         For Count = 1 to %Elem(OSArr);
           If DSSEL(Count) <> *BLANKS;
             XWBCCD = %Subst(OSArr(Count):1:11);
             XWG4TX =  %Subst(OSArr(Count):13:40);
             SFLCHG = *ON;

             Select;
             //Change
             When DSSEL(Count) = '2';
               ExSR chgrec;
             //Delete
             When DSSEL(Count) = '4';
               ExSR delrec;
             //Display
             When DSSEL(Count) = '5';
               ExSR dsprec;
             //Customer Detail Maintenance
             When DSSEL(Count) = '6';
               CUSTMNT1(XWBCCD);
             //Work with Orders
             When DSSEL(Count) = '8';
               ExSR ZOrder;
             //Work with Transaction history
             When DSSEL(Count) = '9';
               ExSR ZHISTO;
             EndSl;

             DSSEL(Count) = *BLANKS;
           //End: For each selection
           EndIf;

         EndFor;

         *IN12 = *OFF;

       EndSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR dspscns;
         //*********************************************************************
         //Subroutine: Display detail screens
         //*********************************************************************
         //Display screen, depending upon page no.
         EXFMT ZZFT01;

         EXSR MVSCDB;

      /END-FREE
     C                   CALL      'XBCCLMSG'
      /FREE
         EXSR OFFIND;

         //Process Command Keys
         SELECT;
           //Prompt
         WHEN *IN04 = '1';
           EXSR SRPROM;
           //Orders
         WHEN *IN08 = '1';
           EXSR ZORDER;
           //Transaction history
         WHEN *IN09 = '1';
           EXSR ZHISTO;
           //* Custtomer History
           //*   *IN07         WHENEQ    '1'
           //*                 EXSR      ZCUSTS
         ENDSL;

       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR VALID1;
         //*********************************************************************
         //Subroutine: Validation #1
         //*********************************************************************
      /END-FREE
     C                   DO
      // WHEN ADDING CUSTOMER MUST NOT BE ZERO
      /FREE
           IF XWBCCD = *BLANKS;
      /END-FREE
     C                   MOVE      '1'           *IN99
     C                   MOVE      *ON           *IN31
     C                   MOVE      'OEM0002'     MSGID
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
      /FREE
             LEAVE;
           ENDIF;
           // WHEN ADDING CUSTOMER MUST NOT EXIST
           IF ACTDSP = 'ADDITION';
             SETLL XWBCCD CUSTS;
             *IN99 = %EQUAL;
             IF *IN99 = '1';
      /END-FREE
     C                   MOVE      *ON           *IN31
     C                   MOVE      'Y2U0003'     MSGID
     C                   MOVEL     *ALL'-'       XWG4TX
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
      /FREE
               LEAVE;
             ENDIF;
           ENDIF;
           //Customer name
           IF XWG4TX = *BLANKS;
      /END-FREE
     C                   MOVE      *ON           *IN32
     C                   MOVE      *ON           *IN99
     C                   MOVE      'OEM0012'     MSGID
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
      /FREE
             LEAVE;
           ENDIF;
           //- CUSTOMER GROUP
           CHAIN XWBNCD CUSGRP;
           *IN99 = NOT %FOUND;
           IF *IN99 = '1';
      /END-FREE
     C                   MOVE      '1'           *IN33
     C                   MOVE      'OES0374'     MSGID
     C                   MOVEL     *ALL'-'       XWKHTX
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
      /FREE
             LEAVE;
           ENDIF;
           //- SALESMAN
           CHAIN PERSON SLMEN;
           *IN99 = NOT %FOUND;
           IF *IN99 = '1';
      /END-FREE
     C                   MOVE      '1'           *IN34
     C                   MOVE      'OEM0023'     MSGID
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
     C                   MOVE      *ALL'-'       PNAME
      /FREE
             LEAVE;
           ENDIF;
           //- Distributor
           CHAIN DSDCDE DISTS;
           *IN99 = NOT %FOUND;
           IF *IN99 = '1';
      /END-FREE
     C                   MOVE      '1'           *IN35
     C                   MOVE      'OEM0018'     MSGID
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
     C                   MOVE      *ALL'-'       DNAME
      /FREE
             LEAVE;
           ENDIF;
         ENDDO;
       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR ADDREC;
         //*********************************************************************
         //Subroutine: Add a record
         //*********************************************************************
      /END-FREE
     C                   MOVE      '0'           *IN94
     C                   MOVE      '1'           *IN96
     C                   MOVE      '0'           *IN97
     C                   MOVEL     'ADDITION'    ACTDSP
      /FREE
         EXSR OFFIND;

         clear custsr;
         pname = *blanks;
         dname = *blanks;
         xwkhtx = *blanks;
         exsr mvdbsc;

         //For each screen page
         DOW *IN03 <> '1'
         AND *IN12 <> '1';

           EXSR DSPSCNS;

           IF *IN03 = '1'
           OR *IN12 = '1';
             LEAVE;
           ENDIF;

           IF *IN04 = '1'
           OR *IN08 = '1'
           OR *IN09 = '1';
             ITER;
           ENDIF;

           EXSR VALID1;

           //If errors found
           IF *IN99 = '1';
             //Display error message and re-display screen
      /END-FREE
     C                   MOVEL     ERRMSG        ZMSAGE
      /FREE
             exsr mvdbsc;
             iter;
           ENDIF;

           //Request confirmation
           EXFMT ZZCNF1;
           IF *IN03 <> '1'
           AND *IN12 <> '1';
             //If confirmation received then write record
             WRITE(E) CUSTSR;
             *IN99 = %ERROR;
             IF *IN99 = '1';
      /END-FREE
     C                   MOVE      'Y2U0004'     MSGID
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
      // Display error message
     C                   MOVEL     ERRMSG        ZMSAGE
      /FREE
             ELSE;
               LEAVE;
             ENDIF;
           ENDIF;

         ENDDO;

       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR CHGREC;
         //*********************************************************************
         //Subroutine: Change a record
         //*********************************************************************
      /END-FREE
     C                   MOVEL     '  UPDATE'    ACTDSP
     C                   MOVE      '0'           *IN94
     C                   MOVE      '0'           *IN96
     C                   MOVE      '0'           *IN97
      /FREE
         EXSR OFFIND;

         EXSR GETREC;

         //If no record or file error
         IF *IN99 = *OFF
         AND *IN66 = *OFF;

           DOW *IN03 <> '1'
           AND *IN12 <> '1';

             EXSR DSPSCNS;

             IF *IN03 = '1'
             OR *IN12 = '1';
               LEAVE;
             ENDIF;

             IF *IN04 = '1'
             OR *IN08 = '1'
             OR *IN09 = '1';
               ITER;
             ENDIF;

             EXSR VALID1;

             //If errors found
             IF *IN99 = '1';
               //Display error message and re-display screen
      /END-FREE
     C                   MOVEL     ERRMSG        ZMSAGE
      /FREE
               exsr mvdbsc;
               iter;
             ENDIF;

             //Request confirmation
             EXFMT ZZCNF1;
             IF *IN03 <> '1'
             AND *IN12 <> '1';
               //If confirmation received then update record
               chain(e) xwbccd custsr;
               if %found(custs);
                 exsr mvscdb;
                 UPDATE(E) CUSTSR;
                 *IN99 = %ERROR;
                 IF *IN99 = '1';
      /END-FREE
     C                   MOVE      'Y2U0007'     MSGID
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
      // Display error message
     C                   MOVEL     ERRMSG        ZMSAGE
      /FREE
                 ENDIF;
               else;
                 unlock(e) custs;
               endif;
             ENDIF;

           ENDDO;

           //End: If no record or file error
         ENDIF;

      /END-FREE
     C                   MOVE      SFLRRN        SHWREC

      /FREE
       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR DELREC;
         //*********************************************************************
         //Subroutine: Delete a record
         //*********************************************************************
      /END-FREE
     C                   MOVEL     '  DELETE'    ACTDSP
     C                   MOVE      '1'           *IN94
     C                   MOVE      '0'           *IN96
     C                   MOVE      '1'           *IN97
      /FREE
         EXSR OFFIND;

         EXSR GETREC;

         DOW *IN03 <> '1'
         AND *IN12 <> '1';

           EXSR DSPSCNS;

           IF *IN03 = '1'
           OR *IN12 = '1';
             LEAVE;
           ENDIF;

           IF *IN04 = '1'
           OR *IN08 = '1'
           OR *IN09 = '1';
             ITER;
           ENDIF;

           //Request confirmation
           EXFMT ZZCNF1;

           IF *IN03 <> '1'
           AND *IN12 <> '1';
             //If confirmation received then delete record
             chain(e) xwbccd custsr;
             if %found(custs);
               delete(e) custsr;
             else;
               unlock(e) custs;
             endif;
             LEAVE;
           ENDIF;

           //End: If not F3/F12
         ENDDO;

      /END-FREE
     C                   MOVE      SFLRRN        SHWREC

      /FREE
       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR DSPREC;
         //*********************************************************************
         //Subroutine: Display a record
         //*********************************************************************
      /END-FREE
     C                   MOVE      '1'           *IN94
     C                   MOVE      '0'           *IN96
     C                   MOVE      '0'           *IN97
     C                   MOVEL     ' DISPLAY'    ACTDSP
      /FREE
         EXSR OFFIND;

         EXSR GETREC;

         DOW *IN03 <> '1'
         AND *IN12 <> '1';

           EXSR DSPSCNS;

           IF *IN03 = '1'
           OR *IN12 = '1';
             LEAVE;
           ENDIF;

           IF *IN04 = '1'
           OR *IN08 = '1'
           OR *IN09 = '1';
             ITER;
           ENDIF;

         ENDDO;

      /END-FREE
     C                   MOVE      SFLRRN        SHWREC

      /FREE
       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR GETREC;
         //*********************************************************************
         //Subroutine: Retrieve a record
         //*********************************************************************
         CHAIN(NE) XWBCCD CUSTS;
         *IN99 = NOT %ERROR AND NOT %FOUND;
         *IN66 = %ERROR;

         select;
           //If record error
         when *in99 = *on;
      /END-FREE
     C                   MOVE      'OES0115'     MSGID
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
     C                   MOVEL     ERRMSG        ZMSAGE

      //If file error
      /FREE
         when *in66 = *on;
           IF FILESTS = 1218;
      /END-FREE
     C                   MOVE      'Y3U9999'     MSGID
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
     C                   MOVEL     ERRMSG        ZMSAGE
      /FREE
           ELSE;
      /END-FREE
     C                   MOVE      'OEM0004'     MSGID
     C                   CALL      RTNMTX
     C                   PARM                    MSGID             7
     C                   PARM                    ERRMSG          132
     C                   MOVEL     ERRMSG        ZMSAGE
      /FREE
           ENDIF;

           //If no errors
         other;

           //Retrieve Salesman's name
           CHAIN(E) PERSON SLMEN;
           if not %found(slmen);
             pname = *all'-';
           endif;

           //Retrieve Distributor's name
           CHAIN(E) DSDCDE DISTS;
           if not %found(dists);
             dname = *all'-';
           endif;

           //Retrieve Customer Group's name
           CHAIN(E) XWBNCD CUSGRP;
           if not %found(cusgrp);
             xwkhtx = *all'-';
           endif;

           exsr mvdbsc;

         endsl;

       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR *INZSR;
         //*********************************************************************
         //Subroutine: Initialisation routines
         //*********************************************************************
         //Initialise message subfile
      /END-FREE
     C                   MOVE      '1'           *IN82
     C                   MOVEL     'WWCUSTS '    ZZPGM
      //-Set date
     C                   MOVE      *DATE         ZZDATE
     C                   MOVE      *YEAR         ZYR
     C                   MOVE      '-'           FILLR1
     C                   MOVE      *MONTH        ZMTH
     C                   MOVE      '-'           FILLR2
     C                   MOVE      *DAY          ZDAY
      /FREE
       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR SRPROM;
         //*********************************************************************
         //Subroutine: prompts for F04
         //*********************************************************************
         SELECT;
         WHEN SFIELD = 'ZPERSON';
      /END-FREE
     C                   CALL      'SLMENSEL'
     C                   PARM                    ZPERSON
     C                   PARM                    PNAME
      /FREE
         WHEN SFIELD = 'ZWBNCD';
      /END-FREE
     C                   CALL      'CUSGRSEL'
     C                   PARM                    ZWBNCD
     C                   PARM                    ZWKHTX
      /FREE
         WHEN SFIELD = 'ZDSDCDE';
      /END-FREE
     C                   CALL      'DISTSSEL'
     C                   PARM                    ZDSDCDE
     C                   PARM                    DNAME
      /FREE
         ENDSL;
       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR OFFIND;
         //*********************************************************************
         //Subroutine: Set error indicators to OFF
         //*********************************************************************
      /END-FREE
     C                   MOVE      *OFF          *IN99
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *OFF          *IN32
     C                   MOVE      *OFF          *IN33
     C                   MOVE      *OFF          *IN34
     C                   MOVE      *OFF          *IN35
     C                   MOVE      *OFF          *IN36
     C                   MOVE      *OFF          *IN37
     C                   MOVE      *BLANKS       ZMSAGE
      /FREE
       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR ZORDER;
         //*********************************************************************
         //Subroutine: Customer Orders
         //*********************************************************************
         //    XWBCCD        CHAIN     CONHDRL1                           77
         //    *IN77         IFEQ      '0'
      /END-FREE
     C                   CALL      'WWCONHDR'
     C                   PARM                    XWBCCD
      //                  ELSE
      //                  MOVE      '1'           *IN99
      //                  MOVE      'YYG0012'     MSGID
      //                  CALL      RTNMTX
      //                  PARM                    MSGID             7
      //                  PARM                    ERRMSG          132
      // Display error message
      //                  MOVEL     ERRMSG        ZMSAGE
      //                  ENDIF
      /FREE
       ENDSR;
       //*********************************************************************

       //*********************************************************************
       BEGSR ZHISTO;
         //*********************************************************************
         //Subroutine: Transaction history
         //*********************************************************************
         //    XWBCCD        CHAIN     TRNHSTL3                           77
         //    *IN77         IFEQ      '0'
      /END-FREE
     C                   CALL      'WWTRNHST'
     C                   PARM                    XWBCCD
      //                  ELSE
      //                  MOVE      '1'           *IN99
      //                  MOVE      'YYG0012'     MSGID
      //                  CALL      RTNMTX
      //                  PARM                    MSGID             7
      //                  PARM                    ERRMSG          132
      // Display error message
      //                  MOVEL     ERRMSG        ZMSAGE
      //                  ENDIF
      /FREE
       ENDSR;
       //*********************************************************************
       BEGSR MVDBSC;
      /END-FREE
     C                   MOVEL     XWBCCD        ZWBCCD
     C                   MOVEL     XWG4TX        ZWG4TX
     C                   MOVEL     XWB2CD        ZWB2CD
     C                   MOVEL     XWB3CD        ZWB3CD
     C                   MOVEL     XWHITX        ZWHITX
     C                   MOVEL     XWE0NB        ZWE0NB
     C                   MOVEL     XWJUN0        ZWJUN0
     C                   MOVEL     XWDVCD        ZWDVCD
     C                   MOVEL     XWBNCD        ZWBNCD
     C                   MOVEL     PERSON        ZPERSON
     C                   MOVEL     DSDCDE        ZDSDCDE
     C                   MOVEL     XWBTCD        ZWBTCD
     C                   MOVEL     XWGIVA        ZWGIVA
     C                   MOVEL     XWAOCD        ZWAOCD
     C                   MOVEL     XWBBCD        ZWBBCD
     C                   MOVEL     XWG4T0        ZWG4T0
     C                   MOVEL     XWC7ST        ZWC7ST
     C                   MOVEL     XWDAST        ZWDAST
     C                   MOVEL     XWBPD0        ZWBPD0
     C                   MOVEL     XWBAD0        ZWBAD0
     C                   MOVEL     XWKHTX        ZWKHTX
      /FREE
       ENDSR;
       //*********************************************************************
       BEGSR MVSCDB;
      /END-FREE
     C                   MOVEL     ZWBCCD        XWBCCD
     C                   MOVEL     ZWG4TX        XWG4TX
     C                   MOVEL     ZWB2CD        XWB2CD
     C                   MOVEL     ZWB3CD        XWB3CD
     C                   MOVEL     ZWHITX        XWHITX
     C                   MOVEL     ZWE0NB        XWE0NB
     C                   MOVEL     ZWJUN0        XWJUN0
     C                   MOVEL     ZWDVCD        XWDVCD
     C                   MOVEL     ZWBNCD        XWBNCD
     C                   MOVEL     ZPERSON       PERSON
     C                   MOVEL     ZDSDCDE       DSDCDE
     C                   MOVEL     ZWBTCD        XWBTCD
     C                   MOVEL     ZWGIVA        XWGIVA
     C                   MOVEL     ZWAOCD        XWAOCD
     C                   MOVEL     ZWBBCD        XWBBCD
     C                   MOVEL     ZWG4T0        XWG4T0
     C                   MOVEL     ZWC7ST        XWC7ST
     C                   MOVEL     ZWDAST        XWDAST
     C                   MOVEL     ZWBPD0        XWBPD0
     C                   MOVEL     ZWBAD0        XWBAD0
     C                   MOVEL     ZWKHTX        XWKHTX
      /FREE
       ENDSR;
       //*********************************************************************
      /END-FREE
````
