# ORDAUDIT2.CMD Member Guide

## Overview
Custom command definition `ORDAUDIT2` publishes a custom command interface for launching legacy programs.

## Dependency Map
- **Incoming:** User profiles or CL/RPG programs that run the `ORDAUDIT2` command.
- **Outgoing:**
  - Defines command processing program and parameters for callers.

## Source
````cl
             CMD        PROMPT('Order Audit Batch - step 2')
````
