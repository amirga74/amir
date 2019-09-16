#!/bin/bash
./sqlplus -s amir/amir@192.168.150.1/opt/oracle/instantclient_11_2 << EOF
REATE OR REPLACE PROCEDURE number_of_users AS
                total_users NUMBER
              BEGIN
              SELECT COUNT(*) into total_users FROM all_users;
              END;

@procsql.sql

EOF
