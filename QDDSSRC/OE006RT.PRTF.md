# OE006RT.PRTF Member Guide

## Overview
DDS printer file `OE006RT` describes printer output formats used by reporting routines.

## Dependency Map
- **Incoming:** Programs that open the `OE006RT` PRTF member.
- **Outgoing:**
  - DDS keywords link to database fields, display formats, or message files as declared below.

## Source
````dds
     A*  Invoice
     A          R @@HD01                    SKIPB(1)
     A                                    68'I N V O I C E'
     A                                      SPACEA(3)
     A                                     2'Order Date:'
     A                                    15DATE EDTCDE(Y)
     A                                      SPACEA(1)
     A                                     2'Order No:'
     A            OHORDN         5S 0     15
     A                                      SPACEA(1)
     A                                    25'Customer'
     A            CSNAME        34A       35
     A                                      SPACEA(1)
     A                                    25'Address'
     A            CSADD1        34A       35
     A                                      SPACEA(1)
     A            CSADD2        34A       35
     A                                      SPACEA(1)
     A            CSADD3        34A       35
     A                                      SPACEA(1)
     A            CSPSCD         8A       35
     A                                      SPACEA(3)
     A                                     2'Line'
     A                                     9'Product'
     A                                    20'Description'
     A                                    55'Quantity'
     A                                    65'Unit Price'
     A                                    77'Cost'
     A          R @@DT01
     A                                      SPACEB(1)
     A            OLLNNO         5S 0      2EDTCDE(Z)
     A            OLPROD         5S 0      9
     A            PRDESC        30A       20
     A            OLQTY          5S 0     55EDTCDE(1)
     A            RTUNIT         7S 2     65EDTCDE(1)
     A            RTCOST         7S 2     77EDTCDE(1)
     A          R @@END
     A                                      SPACEB(1)
     A                                    65'Total Cost:'
     A            TOTAL          7S 2     77EDTCDE(1)
     A                                     1'Terms: 1. Days to pay:'
     A                                      SPACEB(3)
     A            TTDAYS         3S       24EDTCDE(Z)
     A                                     1'Carrier:'
     A                                      SPACEB(3)
````
