# XAN4CDEMIZ.CLP Member Guide

## Overview
Control Language (CL) program `XAN4CDEMIZ` orchestrates IBM i job control for customer and contract workflows.

## Dependency Map
- **Incoming:** Commands or menus that invoke `XAN4CDEMIZ`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````cl
             PGM
             XREV/XDMODEL XA4LIB(XAN4CDEMXA) LIBRARIES(XAN4CDEM) +
                          FORGNKEYS(*DATABASE) TOLVAL(0) +
                          MATCHVAL(*NONE) OVRLIB(XAN4CDEMOV) +
                          CRTFUN(*GRIDS) APPLIB(*XRFLIB) +
                          MDLOPT(*REPLACE) SITELIB(*XRFLIB) +
                          SITEOPT(*REPLACE) EXCLIND(*NO) LCHDGS(*YES)
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
