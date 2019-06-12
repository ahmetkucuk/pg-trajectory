DROP TYPE IF EXISTS tg_pair CASCADE;
CREATE TYPE tg_pair AS ( -- timestamp-geometry pair type
    t timestamp,
    g geometry
);


DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS (
    s_time TIMESTAMP,
    e_time TIMESTAMP,
    geom_type TEXT, 
    bbox GEOMETRY,
    --sampling_interval INTERVAL,
    tr_data tg_pair[]);

DROP FUNCTION IF EXISTS _trajectory(tg_pair[]) CASCADE;
CREATE OR REPLACE FUNCTION _trajectory(tg_pair[]) RETURNS trajectory AS
$BODY$
DECLARE
  t trajectory;
BEGIN
    t.geom_type = tg_type($1);
    IF t.geom_type = 'Invalid' THEN
      RAISE EXCEPTION 'Mixed geometry type is not allowed';
      --RETURN t;
    END IF;
    t.bbox = tg_mbr($1);
    t.e_time = tg_end_time($1);
    t.s_time = tg_start_time($1);
    t.tr_data = array_sort($1);
    IF array_length($1, 1) > 1 THEN
        t.sampling_interval = (t.e_time - t.s_time) / (array_length($1, 1) - 1);
    ELSE
        t.sampling_interval = INTERVAL '-1 seconds';
    END IF;
    RETURN t;
END
$BODY$
LANGUAGE 'plpgsql';


DROP FUNCTION IF EXISTS _trajectory_2(tg_pair[]) CASCADE;
CREATE OR REPLACE FUNCTION _trajectory_2(tg_pair[]) RETURNS VOID AS
$BODY$
DECLARE
    geom_type TEXT;
    s_time TIMESTAMP;
    e_time TIMESTAMP;
    tr_data tg_pair[];
    sampling_interval INTERVAL;
    bbox GEOMETRY;
BEGIN

    geom_type = tg_type($1);
    IF geom_type = 'Invalid'THEN
      RAISE EXCEPTION 'Mixed geometry type is not allowed';
      --RETURN t;
    END IF;
    bbox = tg_mbr($1);
    e_time = tg_end_time($1);
    s_time = tg_start_time($1);
    tr_data = array_sort($1);
    --sampling_interval = INTERVAL '-1 seconds'; --get_sampling_interval(t);
    --RAISE NOTICE '%', tableName;
    sampling_interval = (e_time - s_time) / (array_length($1, 1) - 1); --INTERVAL '-1 seconds'; --get_sampling_interval(t);
    INSERT INTO trajectory_table (s_time,e_time,geom_type,bbox,sampling_interval,tr_data) VALUES (s_time, e_time, geom_type, bbox, sampling_interval, tr_data);
END
$BODY$
LANGUAGE 'plpgsql';

