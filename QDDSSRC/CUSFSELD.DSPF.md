# CUSFSELD.DSPF Member Guide

## Overview
DDS display file `CUSFSELD` lays out interactive screen formats for programs that drive the `CUSFSELD` display file.

## Dependency Map
- **Incoming:** Programs that open the `CUSFSELD` DSPF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A*---------------------------------------------------------------
     A*COPYRIGHT DATABOROUGH LTD 2005
     A*---------------------------------------------------------------
     A                                      CA03(03 'Exit')
     A                                      CA12(12 'Cancel')
     A*---------------------------------------------------------------
     A*Subfile Format
     A*---------------------------------------------------------------
     A          R ZZSFL                     SFL
     A            DSSEL          1A  I  2  2VALUES(' ' '1' 'X')
     A            DSCUSNO        5Y 0O  2  4
     A            DSCNAME       20A  O  2 10
     A*---------------------------------------------------------------
     A*Subfile Control Format
     A*---------------------------------------------------------------
     A          R ZZCTL                     SFLCTL(ZZSFL)
     A                                      SFLSIZ(11)
     A                                      SFLPAG(10)
     A  31                                  SFLDSP
     A                                      SFLDSPCTL
     A  30                                  SFLDLT
     A  31                                  SFLEND
     A                                      BLINK
     A                                      KEEP
     A                                      OVERLAY
     A*
     A                                      WINDOW(*DFT 12 30)
     A                                      WDWBORDER((*COLOR GRN))
     A                                  1  2'Please select:'
     A                                      DSPATR(HI)
     A*---------------------------------------------------------------
     A*Retain Screen
     A*---------------------------------------------------------------
     A          R RETAIN                    ASSUME
     A                                  1 68' '
     A*---------------------------------------------------------------
````
