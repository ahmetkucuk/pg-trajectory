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

psql -U $DATABASE_USER -d $DATABASE_NAME -a -f functions/recordAt.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f functions/area.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f functions/findIntersection.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f functions/findOverlapUnion.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f functions/findUnion.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f functions/jaccard.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f functions/jaccardStar.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f functions/jaccardThree.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f functions/jaccardStarThree.sql