# GETDCODS.RPGLE Member Guide

## Overview
ILE RPG program `GETDCODS` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `GETDCODS`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg

     H Nomain
     H Option(*NoDebugIO : *SrcStmt)
     H Copyright('(C) COPYRIGHT DATABOROUGH LIMITED, 2010.')

     FCUSFL3    IF   E           K DISK    UsrOpn
     FCUSFL5    IF   E           K DISK    UsrOpn
     F                                     Rename(RCUSF:@REDRE2)

     D GetDistributorCode...
     D                 PR                  ExtProc('getDistributorCode')
     D XCUSNO                         5P 0 Const
     D XDCODE                         2A

      //--------------------------------------------------------------------------------------------
     P GetDistributorCode...
     P                 B                   Export

     D GetDistributorCode...
     D                 PI
     D XCUSNO                         5P 0 Const
     D XDCODE                         2A

      //   Key data structures:
     D Key_CUSFL3    E DS                  ExtName(CUSFL3:*Key) Qualified
     D Key_CUSFL5    E DS                  ExtName(CUSFL5:*Key) Qualified

      /Free

        //   Open files:
        If not %Open(CUSFL3);
          Open(e) CUSFL3;
        EndIf;

        If not %Open(CUSFL5);
          Open(e) CUSFL5;
        EndIf;

        Key_CUSFL3.CUSNO = XCUSNO;

        Chain(e) %Kds(Key_CUSFL3) CUSFL3;

        If %Found(CUSFL3) and DSDCDE <> *Blanks;
          Key_CUSFL5.DSDCDE = DSDCDE;
          Key_CUSFL5.STATUS = 'A';

          Chain(e) %Kds(Key_CUSFL5:2) CUSFL5;
          If %Found(CUSFL5);
            XDCODE = DSDCDE;
            Else;
              XDCODE = *BLANKS;
          EndIf;
        EndIf;

        //   Close files:
        If %Open(CUSFL3);
          Close(e) CUSFL3;
        EndIf;

        If %Open(CUSFL5);
          Close(e) CUSFL5;
        EndIf;

        Return;

      /End-Free
     P GetDistributorCode...
     P                 E
````
