DROP TYPE IF EXISTS tg_pair CASCADE;
CREATE TYPE tg_pair AS ( -- timestamp-geometry pair type
    t timestamp,
    g geometry
);


DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS (
    id int,
    s_time TIMESTAMP,
    e_time TIMESTAMP,
    bbox GEOMETRY,
    tr_data tg_pair[]);

DROP FUNCTION IF EXISTS _trajectory(int, tg_pair[]) CASCADE;
CREATE OR REPLACE FUNCTION _trajectory(int, tg_pair[]) RETURNS trajectory AS
$BODY$
DECLARE
  t trajectory;
BEGIN
    RAISE NOTICE '%', 'here';
    t.id = $1;
    t.bbox = findMbr($2);
    t.e_time = findendtime($2);
    t.s_time = findstarttime($2);
    t.tr_data = array_sort($2);
    RETURN t;
END
$BODY$
LANGUAGE 'plpgsql';