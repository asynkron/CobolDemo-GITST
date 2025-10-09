     FCUSFL3    IF   E           K DISK
     FCUSFL5    IF   E           K DISK
     F                                     RENAME(RCUSF:@REDRE2)
     C     *ENTRY        PLIST
     C                   PARM                    XCUSNO            5 0
     C                   PARM                    XDCODE            2                           00730
     C     XCUSNO        CHAIN     CUSFL3                             81
      *
     C     *IN81         IFNE      *ON
     C     DSDCDE        ANDNE     '  '
      *
     C                   MOVE      'A'           STATUS
     C**                 MOVE      'Y'           STATUS
     C     KL2           CHAIN     CUSFL5                             54
      *
     C                   MOVE      DSDCDE        XDCODE
      *
     C                   END
      *
     C                   SETON                                        LR
      *
     C     KL2           KLIST
     C                   KFLD                    DSDCDE
     C                   KFLD                    STATUS
