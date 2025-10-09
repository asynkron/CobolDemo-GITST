# SQL_PRC_02 Member Guide

## Overview
SQL stored procedure source `SQL_PRC_02` encapsulates SQL business logic callable from legacy programs.

## Dependency Map
- **Incoming:** Applications executing the SQL member `SQL_PRC_02`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````sql
  CREATE PROCEDURE XAN4CDEM.SQL_PRC_02(IN VAR1 CHAR(10), IN VAR2 CHAR(10),
                                       IN VAR3 CHAR(10))
    LANGUAGE SQL
      BEGIN
        INSERT INTO XAN4CDEM.DEMODBF (FLD1 , FLD2 , FLD3)
               VALUES( VAR1 , VAR2 , VAR3);
      END
````
