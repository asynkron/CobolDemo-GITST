# CONCATSTR Member Guide

## Overview
SQL stored procedure source `CONCATSTR` encapsulates SQL business logic callable from legacy programs.

## Dependency Map
- **Incoming:** Applications executing the SQL member `CONCATSTR`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````sql
  CREATE PROCEDURE XAN4CDEM.CONCATSTR (IN VAR1 CHAR(10) , OUT VAR2 VARCHAR(20))
    LANGUAGE SQL
      BEGIN
        SET VAR2 = VAR1 || VAR1;
      END
````
