DROP TYPE IF EXISTS tg_pair CASCADE;
CREATE TYPE tg_pair AS ( -- timestamp-geometry pair type
    t timestamp WITHOUT TIME ZONE,
    g geometry
);


DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS (
    s_time TIMESTAMP WITHOUT TIME ZONE,
    e_time TIMESTAMP WITHOUT TIME ZONE,
    geom_type TEXT, 
    bbox GEOMETRY,
    tr_data tg_pair[]);

DROP FUNCTION IF EXISTS _trajectory(tg_pair[]) CASCADE;
CREATE OR REPLACE FUNCTION _trajectory(tg_pair[]) RETURNS trajectory AS
$BODY$
DECLARE
  t trajectory;
BEGIN
    
    t.geom_type = getTrajectoryType($1);
    IF t.geom_type = 'Invalid'THEN
      --RAISE NOTICE 'Mixed geometry type is not allowed';
      RETURN t;
    END IF;
    t.bbox = findMbr($1);
    t.e_time = findendtime($1);
    t.s_time = findstarttime($1);
    t.tr_data = array_sort($1);
    RETURN t;
END
$BODY$
LANGUAGE 'plpgsql';
