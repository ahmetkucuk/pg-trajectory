DROP TYPE IF EXISTS tg_pair CASCADE;
CREATE TYPE tg_pair AS ( -- timestamp-geometry pair type
    t timestamp,
    g geometry
);

DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS ( --trajectory data type
    id      integer, --trajectory identifier
    s_time  timestamp, --start time
    e_time  timestamp, --end time
    bbox    geometry(polygon), --spatial bounding box
    tr_data    tg_pair[] -- timestamp geometry pairs array
);

create table trajectoryTable of trajectory; --create the table using trajectory data type we have just created


--an example insert statement with three time-geometry pairs
insert into trajectoryTable (id, s_time, e_time, bbox, tr_data)
values(
1,
to_timestamp(55599),
to_timestamp(55601),
NULL, --whatever

ARRAY[
  ROW( to_timestamp(55599), ST_GeomFromText('POINT(-71.160281 42.258729)') )::tg_pair,
  ROW( to_timestamp(55600), ST_GeomFromText('POINT(-72.160281 45.258729)') )::tg_pair,
  ROW( to_timestamp(55601), ST_GeomFromText('POINT(-77.160281 46.258729)') )::tg_pair
]::tg_pair[]
);