# TRNHSTCMD.CMD Member Guide

## Overview
Custom command definition `TRNHSTCMD` publishes a custom command interface for launching legacy programs.

## Dependency Map
- **Incoming:** User profiles or CL/RPG programs that run the `TRNHSTCMD` command.
- **Outgoing:**
  - Defines command processing program and parameters for callers.

## Source
````cl
             CMD        PROMPT('COMMAND TO CALL WWTRNHST PGM')

             PARM       KWD(PARM1) TYPE(*CHAR) LEN(11) +
                          PROMPT('CUSTOMER')
````
