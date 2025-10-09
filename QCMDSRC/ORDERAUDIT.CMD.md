# ORDERAUDIT.CMD Member Guide

## Overview
Custom command definition `ORDERAUDIT` publishes a custom command interface for launching legacy programs.

## Dependency Map
- **Incoming:** User profiles or CL/RPG programs that run the `ORDERAUDIT` command.
- **Outgoing:**
  - Defines command processing program and parameters for callers.

## Source
````cl
             CMD        PROMPT('Order Audit Batch ')
             PARM       KWD(LIB) TYPE(*NAME) DFT(*LIBL) +
                          SPCVAL((*LIBL ' ')) MIN(0) PROMPT('Data +
                          Library ')
````
