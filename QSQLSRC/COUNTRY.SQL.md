# COUNTRY.SQL Member Guide

## Overview
SQL script `COUNTRY` defines database structures or scripts used during modernization.

## Dependency Map
- **Incoming:** Applications executing the SQL member `COUNTRY`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````sql
CREATE TABLE COUNTRY(
	CODE        CHAR(10),
	NAME        varchar(50) NOT NULL,
	ACTIONDATE  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	USERID      CHAR(25) NOT NULL DEFAULT '',
	PUBLISHED   char(1) not null default 'F',
	PRIMARY KEY (CODE)
);
````
