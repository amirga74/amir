#!/bin/bash
./sqlplus -s fail/fil@localhost << EOF
REATE OR REPLACE PROCEDURE number_of_users AS
                total_users NUMBER;
                WHENEVER SQLERROR EXIT SQL.SQLCODE
              BEGIN
              SELECT COUNT(*) into total_users FROM all_users;
              END;
whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off

@procsql.sql

exit;
EOF
