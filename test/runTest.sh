#!/usr/bin/env bash
if [ -n "$DATABASE_USER" ]; then
    echo "not empty"
else
    export DATABASE_USER="ahmetkucuk"
fi

if [ -n "$DATABASE_NAME" ]; then
    echo "not empty"
else
    export DATABASE_NAME="course_project"
fi
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f test/testDataInsert.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f test/testQueries.sql