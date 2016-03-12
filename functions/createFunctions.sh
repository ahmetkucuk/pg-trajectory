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

psql -U $DATABASE_USER -d $DATABASE_NAME -a -f recordAt.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f area.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f findMbr.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f findStartTime.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f findEndTime.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f findIntersection.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f findTimeSpaceUnion.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f findTimeUnion.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f findUnion.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f jaccard.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f jaccardStar.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f jaccardThree.sql
psql -U $DATABASE_USER -d $DATABASE_NAME -a -f jaccardStarThree.sql