     Fcusts     uf   e           k disk
     Fcusfl3    uf   e           k disk
     Fconhdrl1  uf a e           k disk
     Duwbccd           s                   like(xwbccd)
     Duwidx1           s              5s 0
      /Free
        //‚Update CUSTS table
        xwbccd = 'ACC7';
        Chain(e) xwbccd custs;
        if %found(custs);
          person = 'MT2';
          update(e) custsr;
        endif;
        //‚Update CUSF table
        cusno = 50;
        setll(e) cusno cusfl3;
        reade(e) cusno cusfl3;
        dow not %eof(cusfl3);
          usernm = 'User 2';
          update(e) rcusf;
          reade(e) cusno cusfl3;
        enddo;

        //‚Update CONHDR Table
        setll(e) xwbccd conhdrl1;
        reade(e) xwbccd conhdrl1;
        dow not %eof(conhdrl1);
          person = 'MT2';
          update(e) conhdrr;
          reade(e) xwbccd conhdrl1;
        enddo;

        //‚Delete XWBCCD = 'ACC10' records from CONHDR
        xwbccd = 'ACC10';
        setll(e) xwbccd conhdrl1;
        reade(e) xwbccd conhdrl1;
        dow not %eof(conhdrl1);
          delete(e) conhdrr;
          reade(e) xwbccd conhdrl1;
        enddo;


        //‚Delete XWBCCD = 'ACC10' records from CONHDR
        clear conhdrr;
        xwbccd = 'ACC10';
        for uwidx1 = 901 to 905;
          xwordn = uwidx1;
          xwdldt = %date();
          xwstat = 'A';
          person = 'NW2';
          write(e) conhdrr;
        endfor;

        *inlr = *on;
      /End-free
