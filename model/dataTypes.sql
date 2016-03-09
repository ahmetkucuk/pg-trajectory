DROP TYPE IF EXISTS tg_pair CASCADE;
CREATE TYPE tg_pair AS ( -- timestamp-geometry pair type
    t timestamp,
    g geometry
);

DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS (id int, s_time TIMESTAMP, e_time TIMESTAMP, bbox GEOMETRY, tr_data tg_pair[]);