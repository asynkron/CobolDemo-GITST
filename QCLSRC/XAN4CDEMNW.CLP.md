# XAN4CDEMNW.CLP Member Guide

## Overview
Control Language (CL) program `XAN4CDEMNW` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `XAN4CDEMNW`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
             PGM
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(XAN4CDEMOV/XLAYOUT) +
                          TOFILE(XAN4CDEMXA/XLAYOUT) MBROPT(*ADD)
             CPYF       FROMFILE(XAN4CDEMOV/XPAGE) +
                          TOFILE(XAN4CDEMXA/XPAGE) MBROPT(*ADD)
             CPYF       FROMFILE(XAN4CDEMOV/XMENOPT) +
                          TOFILE(XAN4CDEMXA/XMENOPT) MBROPT(*REPLACE)
             CPYF       FROMFILE(XAN4CDEMOV/XBLOB) +
                          TOFILE(XAN4CDEMXA/XBLOB) MBROPT(*REPLACE)
             ENDPGM
````
