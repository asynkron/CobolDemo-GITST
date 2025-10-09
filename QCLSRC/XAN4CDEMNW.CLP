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
