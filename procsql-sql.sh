#!/bin/bash
sqlplus -s amir/amir@localhost << EOF

whenever sqlerror exit sql.sqlcode;
set echo off 
set heading off

@procsql.sql

exit;
EOF
