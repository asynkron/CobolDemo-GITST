# ORDAUDIT0.CMD Member Guide

## Overview
Custom command definition `ORDAUDIT0` publishes a custom command interface for launching legacy programs.

## Dependency Map
- **Incoming:** User profiles or CL/RPG programs that run the `ORDAUDIT0` command.
- **Outgoing:**
  - Defines command processing program and parameters for callers.

## Source
````cl
             CMD        PROMPT('Order Audit Batch - step 3')
````
