# SQL_PRC_01 Member Guide

## Overview
SQL stored procedure source `SQL_PRC_01` encapsulates SQL business logic callable from legacy programs.

## Dependency Map
- **Incoming:** Applications executing the SQL member `SQL_PRC_01`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````sql
  CREATE PROCEDURE XAN4CDEM.SQL_PRC_01(IN VAR1 CHAR(10), IN VAR2 CHAR(10))
    LANGUAGE SQL
      BEGIN
        UPDATE XAN4CDEM.DEMODBF SET FLD1 = VAR1 WHERE FLD2 = VAR2 ;
      END
````
