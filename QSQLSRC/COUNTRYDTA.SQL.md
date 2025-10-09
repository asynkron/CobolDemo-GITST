# COUNTRYDTA.SQL Member Guide

## Overview
SQL script `COUNTRYDTA` defines database structures or scripts used during modernization.

## Dependency Map
- **Incoming:** Applications executing the SQL member `COUNTRYDTA`.
- **Outgoing:**
  - No explicit external dependencies captured in the source beyond IBM i runtime conventions.

## Source
````sql
INSERT INTO COUNTRY (CODE, NAME) VALUES('UK', 'United Kingdom') WITH NC
````
