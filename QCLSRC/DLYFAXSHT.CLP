PGM          (&SKL &NRDS)
             DCL &SKL *CHAR 6 /* Letter No. */
             DCL &NRDS *DEC (3 0) /* Generate No */

             SBMJOB     CMD(CALL FAXSHT1 (&SKL &NRDS)) +
                          JOB(FAXSHT) JOBD(FAXJOBD) SCDTIME(200000)
          /* MONMSG     MSGID(CPF0000)  */
ENDPGM
