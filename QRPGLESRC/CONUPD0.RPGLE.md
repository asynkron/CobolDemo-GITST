# CONUPD0.RPGLE Member Guide

## Overview
ILE RPG program `CONUPD0` implements interactive or batch processes in RPGLE.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `CONUPD0`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````rpg
     Fcusts     uf   e           k disk
     Fcusfl3    uf   e           k disk
     Fconhdrl1  uf   e           k disk
     Duwbccd           s                   like(xwbccd)
      /Free
        //Update CUSTS table
        xwbccd = 'ACC7';
        Chain(e) xwbccd custs;
        if %found(custs);
          person = 'MT0';
          update(e) custsr;
        endif;
        //Update CUSF table
        cusno = 50;
        setll(e) cusno cusfl3;
        reade(e) cusno cusfl3;
        dow not %eof(cusfl3);
          usernm = 'User 0';
          update(e) rcusf;
          reade(e) cusno cusfl3;
        enddo;

        //Update CONHDR Table
        xwbccd = 'ACC7';
        setll(e) xwbccd conhdrl1;
        reade(e) xwbccd conhdrl1;
        dow not %eof(conhdrl1);
          person = 'MT0';
          update(e) conhdrr;
          reade(e) xwbccd conhdrl1;
        enddo;

        //Delete XWBCCD = 'ACC10' records from CONHDR
        xwbccd = 'ACC10';
        setll(e) xwbccd conhdrl1;
        reade(e) xwbccd conhdrl1;
        dow not %eof(conhdrl1);
          delete(e) conhdrr;
          reade(e) xwbccd conhdrl1;
        enddo;

        *inlr = *on;
      /End-free
````
