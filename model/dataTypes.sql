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
    
    t.geom_type = getTrajectoryType($1);
    IF t.geom_type = 'Invalid'THEN
      RAISE EXCEPTION 'Mixed geometry type is not allowed';
      --RETURN t;
    END IF;
    t.bbox = findMbr($1);
    t.e_time = findendtime($1);
    t.s_time = findstarttime($1);
    t.tr_data = array_sort($1);
    --t.sampling_interval = get_sampling_interval(t);
    RETURN t;
END
$BODY$
LANGUAGE 'plpgsql';


DROP FUNCTION IF EXISTS _trajectory_2(tg_pair[], REGCLASS) CASCADE;
CREATE OR REPLACE FUNCTION _trajectory_2(tg_pair[], tableName REGCLASS) RETURNS VOID AS
$BODY$
DECLARE
    geom_type TEXT;
    s_time TIMESTAMP;
    e_time TIMESTAMP;
    tr_data tg_pair[];
    --sampling_interval INTERVAL;
    bbox GEOMETRY;
BEGIN

    geom_type = getTrajectoryType($1);
    IF geom_type = 'Invalid'THEN
      RAISE EXCEPTION 'Mixed geometry type is not allowed';
      --RETURN t;
    END IF;
    bbox = findMbr($1);
    e_time = findendtime($1);
    s_time = findstarttime($1);
    tr_data = array_sort($1);
    --sampling_interval = INTERVAL '-1 seconds'; --get_sampling_interval(t);
    --RAISE NOTICE '%', tableName;
    INSERT INTO trajectory_table (s_time,e_time,geom_type,bbox,tr_data) VALUES (s_time, e_time, geom_type, bbox, tr_data);
END
$BODY$
LANGUAGE 'plpgsql';

