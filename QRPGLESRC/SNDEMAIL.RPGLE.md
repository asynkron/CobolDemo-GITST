# SNDEMAIL.RPGLE Member Guide

## Overview
ILE RPG program `SNDEMAIL` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `SNDEMAIL`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     H*COPYRIGHT REMAIN SOFTWARE 2015
     H*--------------------------------------------------------------------
     H debug(*yes) copyright('Remain Software. 2005') datedit(*dmy)

     D**********************************************************************
     D*D e f i n i t i o n s
     D**********************************************************************
     D address         s            240a
     D message         s           2048a
     D server          s            156a

     C**********************************************************************
     C*M a i n l i n e   C o d e
     C**********************************************************************
     C*Get server address
     C                   call      'getserver'
     C                   parm                    server
     C*Send e-mail
     C                   GOTO      endpgm
     C                   call      'javaxmail'
     C                   parm                    address
     C                   parm                    message
     C                   parm                    server
     C     endpgm        tag
     C                   return
     C**********************************************************************

     C**********************************************************************
     C*N o n - E x e c u t a b l e   C o d e
     C**********************************************************************
     C     *entry        plist
     C                   parm                    address
     C                   parm                    message
````
