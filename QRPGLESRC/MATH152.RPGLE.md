# MATH152.RPGLE Member Guide

## Overview
ILE RPG program `MATH152` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `MATH152`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
      * ----------------------------------------------------------- *
      * Description                                                 *
      * ----------------------------------------------------------- *
      *                                                             *
      * Program ....: TEMPLATE                                      *
      * Function ...: Description here                              *
      * Author .....: Y. Name                                       *
      * Startdate ..: DD-MM-CCCC.                                   *
      * Parameters .: INPUT1   - Description                        *
      *               INPUT2   - Description                        *
      *               OUTPUT   - Description                        *
      *                                                             *
      * This template describes the module or program.              *
      *                                                             *
      * ----------------------------------------------------------- *
      * Maintenance                                                 *
      * ----------------------------------------------------------- *
      * TASKxx - WJO - Initial API and implementation               *
      *                                                             *
      * ----------------------------------------------------------- *
      /EJECT
     h option(*nodebugio)
     h BNDDIR('LOGBND')

      /copy *libl/qrpglesrc,prtlog02

     d $num1           s             15s 2 inz(20)
     d $num2           s             15s 2 inz(2)
     d result          s             15s 2

     c                   eval      result = Add($num1:$num2)
     c     result        dsply

     c                   eval      result = Substract($num1:$num2)
     c     result        dsply

     c                   eval      result = Multiply($num1:$num2)
     c     result        dsply

     c                   eval      result = Divide($num1:$num2)
     c     result        dsply

     c                   eval      *inlr = *on
````
