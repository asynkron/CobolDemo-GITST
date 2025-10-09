# ORGMNT.RPG Member Guide

## Overview
RPG III program `ORGMNT` provides legacy RPG logic maintained in the original fixed-format style.

## Dependency Map
- **Incoming:** Menu options or batch jobs invoking `ORGMNT`.
- **Outgoing:**
  - Calls programs/procedures: C

## Source
````rpg
      *================================================================
     M* Maintenance   :
      *================================================================
     FORGMNTD CF  E                    WORKSTN
     F                                        ##RR  KSFILE ZSFLRCD
     F                                              KINFDS INFDS#
     FORGS    UF  E           K        DISK                      A
      *
      /EJECT
      * Data structures:
     IPGMDS     ESDSY2PGDSPK
      * Program data structure
     IJBDTTM      DS
      * Job date/time
     I                                        1   70ZZJDT
     I                                        1   10ZZJCC
     I                                        2   30ZZJYY
     I                                        4   50ZZJMM
     I                                        6   70ZZJDD
     I                                        8  130ZZJTM
     I                                        8   90ZZJHH
     I                                       10  110ZZJNN
     I                                       12  130ZZJSS
      * ABO DEFINE LARGE STRING FOR CL CMD
     IYARTCM      DS                            512
     I                                        1   1 DUMMY1
     IINFDS#    E DSY2I#DSP
      * Display file information data structure
      *
     IINFDS1    E DSY2I1DSP
      * File information data structure
      *
     IY1DBRC    E DSORGS
      * UPD : Quality Attributes        Update index
      * Current/previous master file format fields for change control
      *
      * Message data for message Y2U0009.
     IMD0009      DS
     I                                        1  10 MDPGM
     I                                       11  20 MDACP
     I                                       21  30 MDFMT
     I                                       31  34 MDACT
     I                                       35  40 MDLBL
      /EJECT
      *****************************************************************
      * Initialize
     C                     EXSR ZZINIT
      *
     C                     DO   *HIVAL
      * Initialise and load subfile page
     C                     EXSR BAIZSF
     C                     MOVEL'N'       W0RSF   1
      * Display screen until reload requested
     C           W0RSF     DOWEQ'N'
      * Display screen
     C                     EXSR CAEXFM
      * Process response
      * Cancel & exit program
     C   01                CAS            ZXEXPG
      * HOME: Request subfile reload
     C   05                CAS            FBRQRL
      * Display next SFL page
     C   27
     COR 08                CAS            BBLDSF
      * Process screen input
     C                     CAS            DAPR##
     C                     END
      *
     C                     END
     C                     END
      *****************************************************************
      /EJECT
     CSR         BAIZSF    BEGSR
      *================================================================
      * Initialise & load subfile page
      *================================================================
      * Clear subfile
     C                     SETON                     80
     C                     WRITEZSFLCTL
     C**                   EXFMTZSFLCTL
     C                     SETOF                     80
      * Reset no of records in subfile
     C                     Z-ADD*ZERO     ##RRMX  50 81     SETOF 81
      *................................................................
      * If CHANGE mode, then position file:
     C           W0PMD     IFNE 'ADD'
     C           *LIKE     DEFN Z2ORG     WZORG
     C                     MOVELZ2ORG     WZORG                        de
     C           KPOS      KLIST
     C                     KFLD           ORG                          de
      * Setup key
     C                     Z-ADDZ2ORG     ORG
      * 82=EOF
     C           KPOS      SETLLRORGS                82    *
      * 82=EOF
     C  N82                READ RORGS                  9182*
     C                     ELSE
     C                     SETOF                     82    *
     C                     END
      * Load subfile page
     C                     EXSR BBLDSF
      *................................................................
      * If no records found, display error message
     C   82      ##RR      IFEQ *ZERO                      IF
      * Send message '*No data to display'
     C                     MOVEL'Y2U0008' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     END
      *
      *================================================================
     CSR         BAEXIT    ENDSR
      /EJECT
     CSR         BBLDSF    BEGSR
      *================================================================
      * Load subfile page (write empty page if add mode)
      *================================================================
     C                     SETOF                     84    No SFLNXTCHG
      * Re-establish fields in read-ahead record
     C   27
     COR 08      W0PMD     IFNE 'ADD'
     C  N82                READPRORGS                    90*
     C  N82                READ RORGS                    90*
     C                     END
      *
      * Setof record error indicators
     C                     MOVE *ALL'0'   WKIND0  6
     C                     MOVE *ALL'1'   WKIND1  6
      * Start at previous highest record in SFL
     C                     Z-ADD##RRMX    ##RR    50
     C                     Z-ADD*ZERO     ##RROK  50
      * Set required pages based on *Set Cursor or *Subfile Pages
     C           W0RR0     IFGT 0
     C           W0RR0     DIV  ##SFPG    ##SPG   30
     C                     MVR            ##SLIN  30
     C***                  MVR            #@SLIT  30
     C           ##SLIN    IFGT 0
     C                     ADD  1         ##SPG
     C                     END
     C           W0SPG     IFGT ##SPG
     C                     Z-ADDW0SPG     ##SPG
     C                     END
     C                     ELSE
     C                     Z-ADDW0SPG     ##SPG
     C                     END
      * Compute lines required based on pages
     C           ##SPG     MULT ##SFPG    ##SFLN  90
     C           ##SFLN    IFGT 999
     C                     Z-ADD999       ##SFLN
     C                     END
      *................................................................
      * Load next subfile page
     C  N82      ##RROK    DOWLT##SFLN                     DO
     C                     ADD  1         ##RR
     C                     MOVEAWKIND0    *IN,32
     C                     SETOF                     87    *
      * Clear subfile fields
     C                     EXSR MAIZ#1
      * If CHANGE mode, load subfile fields
     C           W0PMD     IFNE 'ADD'
     C                     EXSR MBFL#1
      * Validate subfile record and calculate derived fields
     C                     EXSR DFV2RC
     C                     END
      * Output to subfile
     C                     ADD  1         ##RROK     81    *
      * If SFLRCD invalid, note that errors present
     C   98N99             SETON                     99    *
      * Set screen conditioning indicators
     C                     EXSR GADSA1
     C                     WRITEZSFLRCD
     C           W0PMD     IFNE 'ADD'
      * 82=EOF
     C                     READ RORGS                    82*
     C                     END
     C  N82                END
      *................................................................
      * Save highest SFL record load can continue at end point
     C           ##RR      IFGT ##RRMX
      * Calculate top line
     C           ##RROK    DIV  ##SFPG    ##SPG
     C                     MVR            ##SLIN
     C           ##SLIN    IFGT 0
     C           ##RR      SUB  ##SLIN    ZZSFRC
     C                     ELSE
     C           ##RR      SUB  ##SFPG    ZZSFRC
     C                     END
     C                     ADD  1         ZZSFRC
     C                     Z-ADD##RR      ##RRMX
     C                     END
      *================================================================
     CSR         BBEXIT    ENDSR
      /EJECT
     CSR         CAEXFM    BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                     EXSR GBDSA2
      * Update screen time
     C                     TIME           ZZTME
     C           W0HLP     DOUEQ'N'
     C                     MOVEL'N'       W0HLP   1
     C                     MOVE *IN04     YPMT04  1
     C                     MOVE *IN25     HELP25  1
     C                     MOVE *ALL'0'   ##OFF  30
     C                     MOVEA##OFF     *IN,1
     C                     MOVE YPMT04    *IN04
     C***                  MOVE YPMT05    *IN05
     C                     MOVE HELP25    *IN25
      * PUTOVR unless conditioned fields change
     C                     SETON                     86
     C           *IN89     IFNE CAIN89
     C           *IN81     ORNE CAIN81
     C                     SETOF                     86
     C                     END
     C                     MOVE *IN89     CAIN89  1
     C                     MOVE *IN81     CAIN81  1
      * Set cursor by *SET CURSOR data
     C           YSETCS    IFEQ 'Y'
     C                     EXSR Y0SET
     C                     END
     C                     WRITEZMSGCTL
     C                     WRITEZCMDTXT1
     C                     EXFMTZSFLCTL
      * Maintain subfile position where possible
     C           @#SFRC    IFGT *ZERO
     C                     Z-ADD@#SFRC    ZZSFRC
     C                     END
      * Test cursor
     C                     EXSR Y8TST
      * Check if prompt requested
     C                     EXSR ZDVPMT
      * Clear set cursor DDS indicator
     C           WCSRLC    IFEQ 'OFF'
     C                     SETOF                     94    *
     C                     END
     C                     MOVE *BLANK    WCSRLC
     C***                  MOVE *BLANK    WCSRLS
      * If help requested, display help text
     C   25                EXSR ZHHPKY
     C                     END
      * Update job time
     C                     TIME           ZZJTM
      * Clear messages from program message queue
     C                     CALL 'XBCCLMSG'
      * Reset first message only flag
     C                     MOVEL'Y'       ZAFSMS  1      99*
     C           YSETCS    IFEQ 'Y'
     C                     EXSR Y9CLR
     C                     END
      *================================================================
     CSR         CAEXIT    ENDSR
      /EJECT
     CSR         DAPR##    BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
     C           W0PMD     IFNE 'ADD'
      * Change of position specified
     C           YPMTFD    IFEQ *BLANKS
     C           WZORG     CASNEZ2ORG     FBRQRL           Attribute Code
     C                     END
     C                     END
     C                     END
      * Quit if reload requested
     C           W0RSF     CABEQ'Y'       DAEXIT
      *
     C   81                DO
      * No data entered as yet
     C                     MOVEL'N'       WKIPIN  1
      * Confirm/update is not deferred
     C                     MOVEL'N'       W0DCF   1
      * Process subfile records
     C                     EXSR DBPRSF
      * If error, exit
     C           *IN99     CABEQ'1'       DAEXIT
     C           YPMTFD    CABNE*BLANKS   DAEXIT
      * Defer confirm/update requested
     C           W0DCF     CABEQ'Y'       DAEXIT
      * If data entered
     C           WKIPIN    IFEQ 'Y'
      * Prompt for confirmation
     C                     EXSR DHPRCF
      * Exit if not confirmed
     C           *IN99     IFEQ '1'
     C                     SETOF                     99
     C                     GOTO DAEXIT
     C                     END
      * Update DBF from subfile
     C                     EXSR EAPRSF
      * If error during update, exit:
     C           *IN99     CABEQ'1'       DAEXIT
     C                     END                             WKIPIN
     C                     END
      * Switch between *ADD/*CHANGE modes
     C   09                EXSR FACHMD
      *================================================================
     CSR         DAEXIT    ENDSR
      /EJECT
     CSR         DBPRSF    BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Read first changed slf record
     C           YAFSCH    IFNE *ZERO
     C           YAFSCH    CHAINZSFLRCD              92    *
     C                     ELSE
     C                     READCZSFLRCD                  92*
     C                     END
     C           *IN92     DOWEQ'0'
     C                     EXSR DCPRSR
     C                     SETOF                     87    *
      * Set screen conditioning indicators
     C                     EXSR GADSA1
     C                     UPDATZSFLRCD
     C                     READCZSFLRCD                  92*
     C                     END
      *================================================================
     CSR         DBEXIT    ENDSR
      /EJECT
     CSR         DCPRSR    BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Set off error indicators
     C                     MOVEAWKIND0    *IN,32
      * No errors
     C                     SETOF                     98
      * No SFLNXTCHG
     C                     SETOF                     84
      * Data entered
     C                     MOVEL'Y'       WKIPIN
      * SFLNXTCHG
     C                     SETON                     84
      * If delete request, bypass validation
     C           Z1SEL     IFEQ '4'
     C                     GOTO DCEXIT
     C                     END
      * Validate subfile record
     C                     EXSR DEV1RC
      * If SFLRCD invalid, note the fact
     C   98N99             Z-ADD##RR      ZZSFRC     99    *
      *================================================================
     CSR         DCEXIT    ENDSR
      /EJECT
     CSR         DEV1RC    BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * Validate subfile record relations
     C                     EXSR DFV2RC
      * Organisation no. required
     C           Z1ORG     IFEQ *ZERO
      * Send message 'Organisation no. required.'
     C                     SETON                     9833  *
     C                     MOVEL'Y2U2001' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     END                             FI
      * Organisation name required
     C           Z1NAME    IFEQ *BLANK                     IF
     C           YPMTFD    ANDEQ*BLANKS
      * Send message 'Organisation name required.'
     C                     SETON                     9834  *
     C                     MOVEL'Y2U2002' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     END                             FI
      * Create name required
     C           Z1CRTN    IFEQ *BLANK                     IF
     C           YPMTFD    ANDEQ*BLANKS
      * Send message 'Create name required.'
     C                     SETON                     9835  *
     C                     MOVEL'Y2U2003' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     END                             FI
      * Create date required
     C           Z1CRTD    IFEQ *ZERO                      IF
     C           YPMTFD    ANDEQ*BLANKS
      * Send message 'Create date required.'
     C                     SETON                     9836  *
     C                     MOVEL'Y2U2004' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     END                             FI
      * Cannot specify update name if no update date
     C           Z1UPDD    IFEQ *ZEROS                     IF
     C           Z1UPDN    ANDNE*BLANKS
      * Send message 'Cannot specify update name if no update date.'
     C                     SETON                     9837  *
     C                     MOVEL'Y2U2006' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     END                             FI
      * Cannot specify update date if no update name
     C           Z1UPDN    IFEQ *BLANK                     IF
     C           Z1UPDD    ANDNE*ZEROS
      * Send message 'Cannot specify update date if no update name.'
     C                     SETON                     9838  *
     C                     MOVEL'Y2U2005' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     END                             FI
      *================================================================
     CSR         DEEXIT    ENDSR
      /EJECT
     CSR         DFV2RC    BEGSR
      *================================================================
      * Validate subfile record relations
      *================================================================
      *================================================================
     CSR         DFEXIT    ENDSR
      /EJECT
     CSR         DHPRCF    BEGSR
      *================================================================
      * Prompt for confirmation
      *================================================================
      * Set screen conditioning indicators
     C                     EXSR GBDSA2
      * Update screen time
     C                     TIME           ZZTME
      * Force PUTOVR
     C                     SETON                     86
     C                     MOVEL*BLANK    ZZCFCD
     C                     MOVEL'Y'       ZZCFCD
      * Save CMD keys
     C                     MOVEA*IN       WN30   30
     C                     SETOF                     29    *
      *
     C           W0HLP     DOUEQ'N'
     C           *IN29     ANDEQ'0'
     C                     WRITEZMSGCTL
     C                     WRITEZCMDTXT1
     C                     WRITEZSFLCTL
     C                     EXFMTZCONFIRM
     C           *IN29     IFEQ '1'
     C                     SETON                     99
     C                     GOTO DHEXIT
     C                     END
      * Clear set cursor DDS indicator
     C           WCSRLC    IFEQ 'OFF'
     C                     SETOF                     94    *
     C                     END
     C                     MOVE *BLANK    WCSRLC
      * If help requested, display help text
     C   25                EXSR ZHHPKY
      * Validate *CONFIRM
     C                     MOVEL*BLANK    W0RTN
     C                     MOVELVZCFCD    W0NSRQ  1        *CONFIRM
      * Name search required?
     C           W0NSRQ    IFEQ '?'
     C           'VZCFCD'  OREQ YPMTFD
     C                     CALL 'Y2VLLSR'              90  *
     C                     PARM           W0RTN   7
     C                     PARM 1001713   Y2LSNO  70
     C           VZCFCD    PARM VZCFCD    W0EXVL 20        *CONFIRM
      * Defer confirm
     C                     MOVEL'Y'       W0DCF   1
     C           W0NSRQ    IFNE '?'
     C                     MOVEL'*DONE'   YPMTFD
     C                     END
     C                     END
      *
     C                     SETOF                     90
     C   90                SETON                     29    *
     C  N90                SETOF                     29    *
     C                     END
      * Restore CMD keys
     C                     MOVEAWN30      *IN
      * Update job time
     C                     TIME           ZZJTM
     C           ZZCFCD    IFEQ 'Y'
      * Clear messages from program message queue
     C                     CALL 'XBCCLMSG'
      * Reset first message only flag
     C                     MOVEL'Y'       ZAFSMS  1      99*
     C                     END
     C           ZZCFCD    COMP 'Y'                  9999  *
     C                     SETOF                     99
      * Not confirmed
      *================================================================
     CSR         DHEXIT    ENDSR
      /EJECT
     CSR         EAPRSF    BEGSR
      *================================================================
      * Update DBF from subfile
      *================================================================
      * Initialise subfile reload flag
     C           W0PMD     IFEQ 'ADD'
     C                     MOVEL'Y'       W0RSF
     C                     ELSE
     C                     MOVEL'N'       W0RSF
     C                     END
      * Process all modified subfile records
     C                     READCZSFLRCD                  92*
     C           *IN92     DOWEQ'0'
      * Process modified subfile record
     C                     EXSR EBPRSR
     C                     MOVEL*BLANK    Z1SEL
      * Set screen conditioning indicators
     C                     EXSR GADSA1
     C                     UPDATZSFLRCD
     C                     READCZSFLRCD                  92*
     C                     END
      * If any errors, cancel reload
     C           *IN99     IFEQ '1'
     C                     MOVEL'N'       W0RSF   1
     C                     END
      *================================================================
     CSR         EAEXIT    ENDSR
      /EJECT
     CSR         EBPRSR    BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Set off error indicators
     C                     MOVEAWKIND0    *IN,32
     C                     SETOF                     98
      *
     C           W0PMD     IFEQ 'ADD'
      * Process add request
     C           Z1SEL     IFNE '4'
     C                     EXSR ECADRQ
     C                     END
     C                     ELSE
     C           Z1SEL     IFEQ '4'
      * Process delete request
     C                     EXSR EDDLRQ
     C                     ELSE
      * Process change request
     C                     EXSR EECHRQ
     C                     END
     C                     END
      * If error occurred on update, note the fact
     C           *IN98     IFEQ '1'
     C           *IN99     IFEQ '0'
     C                     Z-ADD##RR      ZZSFRC     99    *
     C                     END
     C                     END
      *================================================================
     CSR         EBEXIT    ENDSR
      /EJECT
     CSR         ECADRQ    BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
     C                     EXSR SACRRC
     C           W0RTN     IFNE *BLANK
      * Write error detected
      * Screen errors
     C                     MOVEAWKIND1    *IN,32
      * Format error
     C                     SETON                     98    *
      * Enable entry
     C                     SETOF                     87    *
      * SFLNXTCHG
     C                     SETON                     84    *
     C                     ELSE
      * DBF write successful
      * disable entry
     C                     SETON                     87    *
      * No SFLNXTCHG
     C                     SETOF                     84    *
     C                     END
      *================================================================
     CSR         ECEXIT    ENDSR
      /EJECT
     CSR         EDDLRQ    BEGSR
      *================================================================
      * Process delete request
      *================================================================
     C                     EXSR SBDLRC
     C           W0RTN     IFNE *BLANK
      * Delete unsuccessful
      * Screen errors
     C                     MOVEAWKIND1    *IN,32
      * Format error
     C                     SETON                     98    *
      * Enable entry
     C                     SETOF                     87    *
      * SFLNXTCHG
     C                     SETON                     84    *
      * If record altered, reset subfile record
     C           W0RTN     CASEQ'Y2U0007' MBFL#1           IF
     C                     END
     C                     ELSE
      * DBF delete successful
      * Blank out record and protect from entry
     C                     EXSR MAIZ#1
      * disable entry
     C                     SETON                     87    *
      * No SFLNXTCHG
     C                     SETOF                     84    *
      * Reload subfile
     C                     MOVEL'Y'       W0RSF   1
     C                     END
      *================================================================
     CSR         EDEXIT    ENDSR
      /EJECT
     CSR         EECHRQ    BEGSR
      *================================================================
      * Process update request
      *================================================================
     C                     EXSR SCCHRC
     C           W0RTN     IFNE *BLANK
      * Data update error
      * Screen errors
     C                     MOVEAWKIND1    *IN,32
      * Format error
     C                     SETON                     98    *
      * Enable entry
     C                     SETOF                     87    *
      * SFLNXTCHG
     C                     SETON                     84    *
      * Reset subfile record if changed record
     C           W0RTN     CASEQ'Y2U0007' MBFL#1           IF
     C                     END
     C                     ELSE
      * DBF update successful
      * Enable entry
     C                     SETOF                     87    *
      * No SFLNXTCHG
     C                     SETOF                     84    *
     C                     END
      *================================================================
     CSR         EEEXIT    ENDSR
      /EJECT
     CSR         FACHMD    BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C           W0PMD     IFNE 'ADD'
     C                     MOVEL'ADD'     W0PMD
     C                     ELSE
     C                     MOVEL'CHG'     W0PMD
     C                     END
     C                     EXSR FBRQRL
      *================================================================
     CSR         FAEXIT    ENDSR
      /EJECT
     CSR         FBRQRL    BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                     MOVEL'Y'       W0RSF
      *================================================================
     CSR         FBEXIT    ENDSR
      /EJECT
     CSR         GADSA1    BEGSR
      *================================================================
      * Set display attributes for Subfile record
      *================================================================
     C           W0PMD     COMP 'ADD'                    89*
      * Protect keys if change mode or updated record
     C                     SETON                     88    *
     C   89N87             SETOF                     88    *
     C                     MOVEL*IN87     *IN78
     C           W0PMD     IFEQ 'ADD'                      *IF
     C                     MOVEL'1'       *IN78
     C                     END                             *FI
      *================================================================
     CSR         GAEXIT    ENDSR
      /EJECT
     CSR         GBDSA2    BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C           W0PMD     COMP 'ADD'                    89*
     C                     MOVEL'0'       *IN79
     C           W0PMD     IFEQ 'ADD'                      *IF
     C                     MOVEL'1'       *IN79
     C                     END                             *FI
      *================================================================
     CSR         GBEXIT    ENDSR
      /EJECT
     CSR         MAIZ#1    BEGSR
      *================================================================
      * Initialise subfile record
      *================================================================
      * Previous values
     C                     MOVEL*BLANK    Z1DBRC
     C                     MOVEL*BLANK    Z1SEL            *SFLSEL
     C                     Z-ADD*ZERO     Z1ORG                        de
     C                     MOVEL*BLANK    Z1NAME
     C                     MOVEL*BLANK    Z1CRTN                       pti
     C                     MOVEL*ZERO     Z1CRTD                       les
     C                     MOVEL*BLANK    Z1UPDN                       es
     C                     MOVEL*ZERO     Z1UPDD                       les
      *================================================================
     CSR         MAEXIT    ENDSR
      /EJECT
     CSR         MBFL#1    BEGSR
      *================================================================
      * Move RORGS fields to subfile
      *================================================================
     C                     Z-ADDORG       Z1ORG                        de
     C                     MOVELONAME     Z1NAME
     C                     MOVELCRTNAM    Z1CRTN                       pti
     C                     Z-ADDCRTDAT    Z1CRTD                       les
     C                     MOVELUPDNAM    Z1UPDN                       es
     C                     Z-ADDUPDDAT    Z1UPDD                       es
      * Hold current record image for change detection
     C                     MOVELY1DBRC    Z1DBRC
      *================================================================
     CSR         MBEXIT    ENDSR
      /EJECT
     CSR         MEIZ#2    BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                     Z-ADD*ZERO     Z2ORG                        de
      *================================================================
     CSR         MEEXIT    ENDSR
      /EJECT
     CSR         SACRRC    BEGSR
      *================================================================
      * Create record
      *================================================================
     C                     MOVEL*BLANK    W0RTN   7
      * Move all fields to RORGS
     C                     Z-ADDZ1ORG     ORG                          de
     C                     MOVELZ1NAME    ONAME
     C                     MOVELZ1CRTN    CRTNAM                       pti
     C                     Z-ADDZ1CRTD    CRTDAT                       les
     C                     MOVELZ1UPDN    UPDNAM                       es
     C                     MOVELZ1UPDD    UPDDAT                       es
      *
     C           KLCRSA    KLIST
     C                     KFLD           ORG                          de
      * Check for duplicate primary key
     C           KLCRSA    SETLLRORGS                    90*
     C           *IN90     IFEQ '1'
     C                     MOVEL'Y2U0003' W0RTN   7
      * Send message 'Record already exists.'
     C                     MOVEL'Y2U0003' ZAMSID
     C                     EXSR ZASNMS
     C                     GOTO SAEXIT
     C                     ENDIF
      *
     C                     WRITERORGS                  91  *
      *
     C           *IN91     IFEQ '1'
      * Write error detected
     C                     MOVEL'Y2U0004' W0RTN   7
     C                     ELSE
     C                     ENDIF
      *================================================================
     CSR         SAEXIT    ENDSR
      /EJECT
     CSR         SBDLRC    BEGSR
      *================================================================
      * Delete record
      *================================================================
     C                     MOVEL*BLANK    W0RTN   7
      * Move key fields to
     C                     Z-ADDZ1ORG     ORG                          de
      *
     C           KLDLSB    KLIST
     C                     KFLD           ORG                          de
     C           KLDLSB    CHAINRORGS                9091  *
     C           *IN90     IFEQ '1'
      * Record already deleted
     C                     MOVEL'Y2U0009' W0RTN   7
     C                     MOVELZZPGM     MDPGM
     C                     MOVEL'ORGS    'MDACP
     C                     MOVEL'RORGS   'MDFMT
     C                     MOVEL'*DLT'    MDACT
      * Record not found label: LBL001.
     C                     MOVEL'LBL001'  MDLBL
      * Send message '*Record no longer on file'
     C                     MOVEL'Y2U0009' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     MOVELMD0009    ZAMSDA           Message data
     C                     EXSR ZASNMS
     C                     MOVEL*BLANKS   MD0009
     C                     GOTO SBEXIT
     C                     ENDIF
      *
     C           *IN91     IFEQ '1'
      * Record locked
     C                     MOVEL'Y2U0004' W0RTN   7
      * Send message '*Database operation error'
     C                     MOVEL'Y2U0004' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     GOTO SBEXIT
     C                     ENDIF
      *
      * Check for changed record
     C           Z1DBRC    IFNE Y1DBRC                     IF
     C                     MOVEL'Y2U0007' W0RTN   7
      * Send message '*Update not accepted'
     C                     MOVEL'Y2U0007' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
      * Release record lock
     C           KLDLSB    SETLLRORGS                9091  *
     C                     GOTO SBEXIT
     C                     ENDIF                           FI Z1DBRC
      *................................................................
     C                     DELETRORGS                  91  *
     C           *IN91     IFEQ '1'
      * Delete error detected
     C                     MOVEL'Y2U0004' W0RTN   7
     C                     ENDIF
      *================================================================
     CSR         SBEXIT    ENDSR
      /EJECT
     CSR         SCCHRC    BEGSR
      *================================================================
      * Change record
      *================================================================
     C                     MOVEL*BLANK    W0RTN   7
      * Move key fields to
     C                     Z-ADDZ1ORG     ORG                          de
      *
     C           KLCHSC    KLIST
     C                     KFLD           ORG                          de
     C           KLCHSC    CHAINRORGS                9091  *
      *
     C           *IN90     IFEQ '1'
      * Record not found
     C                     MOVEL'Y2U0009' W0RTN   7
     C                     MOVELZZPGM     MDPGM
     C                     MOVEL'ORGS    'MDACP
     C                     MOVEL'RORGS   'MDFMT
     C                     MOVEL'*CHG'    MDACT
      * Record not found label: LBL002.
     C                     MOVEL'LBL002'  MDLBL
      * Send message '*Record no longer on file'
     C                     MOVEL'Y2U0009' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     MOVELMD0009    ZAMSDA           Message data
     C                     EXSR ZASNMS
     C                     MOVEL*BLANKS   MD0009
     C                     GOTO SCEXIT
     C                     ENDIF
      *
     C           *IN91     IFEQ '1'
      * Record locked
     C                     MOVEL'Y2U0004' W0RTN   7
      * Send message '*Database operation error'
     C                     MOVEL'Y2U0004' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     GOTO SCEXIT
     C                     ENDIF
      *
      * Check for changed record
     C           Z1DBRC    IFNE Y1DBRC                     IF
     C                     MOVEL'Y2U0007' W0RTN   7
      * Send message '*Update not accepted'
     C                     MOVEL'Y2U0007' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
      * Release record lock
     C                     UNLCKORGS                   91  *
     C                     GOTO SCEXIT
     C                     ENDIF                           FI Z1DBRC
      * Move non-key fields to
     C                     MOVELZ1NAME    ONAME
     C                     MOVELZ1CRTN    CRTNAM                       pti
     C                     Z-ADDZ1CRTD    CRTDAT                       les
     C                     MOVELZ1UPDN    UPDNAM                       es
     C                     Z-ADDZ1UPDD    UPDDAT                       les
      *
     C                     UPDATRORGS                  91  *
     C           *IN91     IFEQ '1'
      * Change error detected
     C                     MOVEL'Y2U0004' W0RTN   7
     C                     ELSE
      *
      * Update saved record image
     C                     MOVELY1DBRC    Z1DBRC
      * DBF change successful
     C                     ENDIF
      *================================================================
     CSR         SCEXIT    ENDSR
      /EJECT
     CSR         Y0SET     BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
      *================================================================
     CSR         Y0EXIT    ENDSR
      /EJECT
     CSR         Y8TST     BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                     Z-ADD@#RWCL    ZINPOS  50
     C           ZINPOS    DIV  256       W0CRW
     C                     MVR            W0CCL
      *================================================================
     CSR         Y8EXIT    ENDSR
      /EJECT
     CSR         Y9CLR     BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
      *================================================================
     CSR         Y9EXIT    ENDSR
      /EJECT
     CSR         ZASNMS    BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
      * Send if first error message or not an error message
     C           ZAMSTP    IFNE *BLANK
     C           ZAFSMS    ORNE 'N'
     C           ZAMSTP    IFEQ *BLANK
      * Signal first error message sent
     C                     MOVEL'N'       ZAFSMS
     C                     END
     C           ZAPGMQ    IFEQ *BLANK
     C                     MOVELZZPGM     ZAPGMQ
     C                     END
      * If no message file specified, use default
     C           ZAMSGF    IFEQ *BLANK
     C                     MOVELZADFMF    ZAMSGF
     C                     END
     C                     CALL 'XBCSNMSG'
     C                     PARM           ZAPGMQ 10        Program queue
     C                     PARM           ZAPGRL  5        Rel queue
     C                     PARM           ZAMSID  7        Message ID
     C                     PARM           ZAMSGF 10        Message file
     C                     PARM           ZAMSDA132        Message data
     C                     PARM           ZAMSTP  7        Message type
     C                     END
      * Clear all fields for default mechanism next time
     C                     MOVEL*BLANK    ZAPGMQ
     C                     MOVEL*BLANK    ZAPGRL
     C                     MOVEL*BLANK    ZAMSID
     C                     MOVEL*BLANK    ZAMSGF
     C                     MOVEL*BLANK    ZAMSDA
     C                     MOVEL*BLANK    ZAMSTP
      *================================================================
     CSR         ZAEXIT    ENDSR
      /EJECT
     CSR         ZDVPMT    BEGSR
      *================================================================
      * Process prompt request
      *================================================================
      *
      * Initialise prompt workfields
     C                     MOVEL*BLANK    YPMTFD 10
     C                     Z-ADD*ZERO     YAFSCH  40
     C                     Z-ADD*ZERO     YPMRRN  40
      *
     C           *IN04     IFEQ '1'
      *
      * Extract cursor row and column
     C           @#RWCL    DIV  256       ZHCSRW  50
     C                     MVR            ZHCSCL  50
      *
      * Save cursor position for redisplay
     C                     Z-ADDZHCSRW    ZZCSRW  30       Row
     C                     Z-ADDZHCSCL    ZZCSCL  30       Column
      *
      * Save sfl rrn at top of page
     C                     Z-ADD@#SFRC    Y#SFRC  40
      *
      * Initialise sfl workfields
     C                     Z-ADD012       ZHSTRW  40
     C                     Z-ADD021       ZHNDRW  40
     C                     Z-ADD001       ZHRLEN  40
     C                     Z-ADD*ZERO     ZHF4RW  40
     C                     Z-ADD*ZERO     ZHWK1#  40
      *
      * Resolve prompt row number on sfl
     C           ZHCSRW    IFGE ZHSTRW
     C           ZHCSRW    ANDLEZHNDRW
     C           ZHCSRW    SUB  ZHSTRW    ZHWK1#
     C           ZHWK1#    DIV  ZHRLEN    ZHWK1#
     C           ZHWK1#    ADD  Y#SFRC    YPMRRN
     C                     Z-ADDZHWK1#    YZSFDL  40
     C           ZHWK1#    MULT ZHRLEN    ZHWK1#
     C           ZHCSRW    SUB  ZHWK1#    ZHF4RW
      *
     C           YPMRRN    IFGT *ZERO
      * Chain to sfl record
     C           YPMRRN    CHAINZSFLRCD              92    *
     C           *IN92     IFEQ '0'
      * Set screen conditioning indicators
     C                     EXSR GADSA1
     C                     ELSE
     C                     Z-ADD*ZERO     YPMRRN
     C                     END
     C                     END
     C                     END
      *
     C           ZHF4RW    IFEQ 012
     C           ZHCSCL    ANDEQ004
     C                     MOVEL'Z1ORG '  YPMTFD
     C                     END
      *
     C           YPMTFD    IFEQ *BLANK
      * Error if user defined prompting is not specified.
     C           W0PMT     IFEQ 'N'
     C                     MOVEL'*NONE'   YPMTFD
     C                     MOVEL'Y'       W0HLP   1
     C                     MOVEL'Y'       ZAFSMS
      * Send error message.
     C                     MOVEL'Y2U0101' ZAMSID
     C                     MOVEL'OEMSGF  'ZAMSGF
     C                     EXSR ZASNMS
     C                     END
     C                     END
      *
      * Save first changed  rrn
     C           ZHCSRW    IFGE ZHSTRW
     C           ZHCSRW    ANDLEZHNDRW
     C           YPMTFD    ANDNE'*NONE'
      *
     C           ##RR      IFNE *ZERO
     C                     READCZSFLRCD                  92*
     C           *IN92     IFEQ '0'
     C                     Z-ADD##RR      YAFSCH
     C                     SETON                     84    *
     C                     UPDATZSFLRCD
     C                     END
     C                     END
      *
      * Calculate rrn for prompt slf record
     C           ZHCSRW    SUB  ZHSTRW    ZHWK1#
     C           ZHWK1#    DIV  ZHRLEN    ZHWK1#
     C           ZHWK1#    ADD  Y#SFRC    YPMRRN
      *
      * Chain to sfl record
     C           YPMRRN    CHAINZSFLRCD              92    *
     C           *IN92     IFEQ '0'
     C                     SETON                     84    *
     C                     UPDATZSFLRCD
     C                     ELSE
     C                     Z-ADD*ZERO     YPMRRN
     C                     END
      *
      * Test first changed rrn/prompt rrn
     C           YAFSCH    IFEQ *ZERO
     C                     Z-ADDYPMRRN    YAFSCH
     C                     END
      *
      * If prompt rrn < first changed rrn
     C           YPMRRN    IFNE *ZERO
     C           YPMRRN    ANDLTYAFSCH
     C                     Z-ADDYPMRRN    YAFSCH
     C                     END
      *
     C                     END
      *
     C                     END
      *================================================================
     CSR         ZDEXIT    ENDSR
      /EJECT
     CSR         ZHHPKY    BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                     MOVEL'Y'       W0HLP   1
      *
      * Extract cursor row and column
     C           @#RWCL    DIV  256       ZHCSRW  50       Row
     C                     MVR            ZHCSCL  50       Column
      *
      * Save cursor position for redisplay
     C                     Z-ADDZHCSRW    ZZCSRW  30       Row
     C                     Z-ADDZHCSCL    ZZCSCL  30       Column
      *
      *
     C                     CALL 'YDDSHPR'
     C                     PARM 'BIAQEFRH'W0HPMB 10        Help text sourc
     C                     PARM *BLANK    YYHPFL 10        Help text file
     C                     PARM *BLANK    YYHPLB 10        Help text libra
     C                     PARM           W0RTN   7
     C                     PARM '*CSRLOC' YYHLVN 10        Help label
     C                     PARM '*NORMAL' YYUSOP 10        Options
     C                     PARM ZHCSRW    YYRW    50       Row
     C                     PARM ZHCSCL    YYCL    50       Column
     C                     PARM *ZERO     YYLGCT  50       # of grps
     C                     PARM *BLANK    YYLGVN 10        Label grps
      *
      * Clear set cursor DDS indicator
     C  N94                MOVEL'OFF'     WCSRLC
     C  N94                SETON                     94    *
      *================================================================
     CSR         ZHEXIT    ENDSR
      /EJECT
     CSR         ZXEXPG    BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
     C                     EXSR ZYEXPG
      *================================================================
     CSR         ZXEXIT    ENDSR
      /EJECT
     CSR         ZYEXPG    BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Terminate program
     C                     SETON                     LR
      *
      * Exit program
     C                     RETRN
      *
      *================================================================
     CSR         ZYEXIT    ENDSR
      /EJECT
     CSR         ZZINIT    BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C           W0ICL     IFEQ *BLANK
     C                     MOVEL'Y'       W0ICL   1        *Initial call
     C                     ELSE
     C                     MOVEL'N'       W0ICL
     C                     END
     C                     MOVE *BLANK    W0RTN   7
     C                     MOVEL*BLANK    W0RSL   1
     C                     MOVEL*BLANK    W0RSF   1
     C                     MOVEL*ZEROS    W0RTW   90
     C                     MOVEL'400'     W0ENV   3
      * Setup job date/time
      *
     C                     Z-ADDUDATE     ZZJDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C           ZZJYY     IFLT 40
     C                     Z-ADD1         ZZJCC
     C                     ELSE
     C                     Z-ADD0         ZZJCC
     C                     END
     C                     TIME           ZZJTM
      * Update screen time
     C                     TIME           ZZTME   60
      * Obtain default message file
     C           *NAMVAR   DEFN Y2MGFLA   ZADFMF 10
     C                     IN   ZADFMF
      * Flag no *SET CURSOR in the program
     C                     MOVE 'N'       YSETCS  1
     C                     MOVE *BLANK    WCSRLC  3
      * Signal first error message outstanding
     C                     MOVEL'Y'       ZAFSMS  1
      * Define *Synon program work fields
     C                     MOVEL*BLANKS   W0CFL  10        *Cursor field
     C                     Z-ADD*ZEROS    W0CRW   50       *Cursor row
     C                     Z-ADD*ZEROS    W0CCL   50       *Cursor column
      * Move main file information to JOB context
     C                     MOVE @1FFL     ZZFFL  10        Main file name
     C                     MOVE @1FLB     ZZFLB  10        Main file lib
     C                     MOVE @1FMB     ZZFMB  10        Main file mbr
     C                     MOVE ZZFFL     @1FFL  10
     C                     MOVE ZZFLB     @1FLB  10
     C                     MOVE ZZFMB     @1FMB  10
     C                     CALL 'Y2QLVNR'
     C                     PARM           ZZFFL  10
     C                     PARM           ZZFLB  10
     C                     PARM           ZZFQL  21        LIBRARY/FILE
     C                     MOVEL'N'       W0PMT   1
      * *DTAARA = *COMPANY N
     C           *NAMVAR   DEFN YYCOTXA   ZZCMP
     C                     IN   *NAMVAR
      *................................................................
      *
     C                     Z-ADD10        ##SFPG  30       SFLPAG
     C                     Z-ADD1         ZZSFRC
      * Maximum record number
     C                     Z-ADD*ZERO     ##RRMX
      * Scan limit
     C                     Z-ADD500       W0SLM   50
      * Subfile pages
     C                     Z-ADD1         W0SPG   30
      * Processed Subfile record
     C                     Z-ADD0         W0RR0   40
      *................................................................
      * Set to *CHANGE mode
     C                     MOVEL'CHG'     W0PMD   3
     C                     MOVEL*BLANK    W0GRP   1
      * Initialise subfile control
     C                     EXSR MEIZ#2
      *================================================================
     CSR         ZZEXIT    ENDSR
````
