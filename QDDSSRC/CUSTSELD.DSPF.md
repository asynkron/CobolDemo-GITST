# CUSTSELD.DSPF Member Guide

## Overview
DDS display file `CUSTSELD` lays out interactive screen formats for programs that drive the `CUSTSELD` display file.

## Dependency Map
- **Incoming:** Programs that open the `CUSTSELD` DSPF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A*%%TS  SD  20070201  174602  ROYMAN      REL-V5R3M0  5722-WDS
     A*---------------------------------------------------------------
     A*COPYRIGHT DATABOROUGH LTD 2005
     A*---------------------------------------------------------------
     A*%%EC
     A                                      DSPSIZ(24 80 *DS3)
     A                                      CA03(03 'Exit')
     A                                      CA12(12 'Cancel')
     A*---------------------------------------------------------------
     A*Subfile Format
     A*---------------------------------------------------------------
     A          R ZZSFL                     SFL
     A*%%TS  SD  20070201  174241  ROYMAN      REL-V5R3M0  5722-WDS
     A            DSSEL          1A  I  2  2VALUES(' ' '1' 'X')
     A            XWBCCD        11A  O  2  4TEXT('CUSTOMER')
     A            XWG4TX        40A  O  2 16TEXT('NAME')
     A*---------------------------------------------------------------
     A*Subfile Control Format
     A*---------------------------------------------------------------
     A          R ZZCTL                     SFLCTL(ZZSFL)
     A*%%TS  SD  20070201  174241  ROYMAN      REL-V5R3M0  5722-WDS
     A                                      KEEP
     A                                      BLINK
     A                                      OVERLAY
     A  31                                  SFLDSP
     A                                      SFLDSPCTL
     A  30                                  SFLDLT
     A  31                                  SFLEND
     A                                      SFLSIZ(0011)
     A                                      SFLPAG(0010)
     A                                      WINDOW(*DFT 12 56)
     A                                      WDWBORDER((*COLOR GRN))
     A                                  1  2'Please select:'
     A                                      DSPATR(HI)
     A*---------------------------------------------------------------
     A*Retain Screen
     A*---------------------------------------------------------------
     A          R RETAIN                    ASSUME
     A                                  1 68' '
````
