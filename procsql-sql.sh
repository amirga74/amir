#!/bin/bash
sqlplus -s amir/amir@localhost << EOF
REATE OR REPLACE PROCEDURE number_of_users AS
                total_users NUMBER;
                WHENEVER SQLERROR EXIT SQL.SQLCODE
              BEGIN
              SELECT COUNT(*) into total_users FROM all_users;
              END;

@procsql.sql

exit;
EOF
