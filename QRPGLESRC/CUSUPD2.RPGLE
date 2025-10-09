     Fcusts     uf   e           k disk
      *
     c                   move      *blank        xwbccd
     c                   movel     'ACC10'       xwbccd
EANP8C     xwbccd        chain     custs                              30
EANP8C     *in30         ifeq      *off
     c                   movel     'MT2'         person
     c                   update    custsr
     c                   end
     C                   seton                                        lr
     C                   return
