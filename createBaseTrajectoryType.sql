DROP TYPE IF EXISTS tg_pair;
CREATE TYPE tg_pair AS ( -- timestamp-geometry pair type
    t timestamp,
    g geometry
);

DROP TYPE IF EXISTS trajectory;
CREATE TYPE trajectory AS ( --trajectory data type
    s_time  timestamp, --start time
    e_time  timestamp, --end time
    bbox    geometry(polygon), --spatial bounding box
    tr_data    tg_pair[] -- timestamp geometry pairs array
);