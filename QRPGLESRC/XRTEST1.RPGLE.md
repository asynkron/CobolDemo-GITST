# XRTEST1.RPGLE Member Guide

## Overview
ILE RPG program `XRTEST1` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `XRTEST1`.
- **Outgoing:**
  - Calls programs/procedures: begsr

## Source
````rpg
      /free
       exsr zcall;
       *inlr = *on;
      /end-free
     C     zcall         begsr
     C
     C                   eval      p1 ='211'
     C                   call      'XRPGM1'
     C                   parm                    p1               10
     C                   call      'XRPGM2'
     C                   parm      '211'         p2               10
     C                   eval      p2 ='310'
     C                   call      'XRPGM2'
     C                   parm      '101'         p2               10
     C
     C                   endsr
````
