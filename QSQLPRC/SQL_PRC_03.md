# SQL_PRC_03 Member Guide

## Overview
SQL stored procedure source `SQL_PRC_03` encapsulates SQL business logic callable from legacy programs.

## Dependency Map
- **Incoming:** Applications executing the SQL member `SQL_PRC_03`.
- **Outgoing:**
  - Reads tables/views: XAN4CDEM

## Source
````sql
  CREATE PROCEDURE XAN4CDEM.SQL_PRC_03(IN VAR1 CHAR(10))
    LANGUAGE SQL
      BEGIN
        DELETE FROM XAN4CDEM.DEMODBF WHERE FLD1 = VAR1;
      END
````
