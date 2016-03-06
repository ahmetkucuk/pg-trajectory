DROP TYPE IF EXISTS geo_tuple CASCADE;
CREATE TYPE geo_tuple AS (geo_time TIMESTAMP, geo GEOMETRY);

CREATE OR REPLACE FUNCTION t_geo_to_tuple(geo_tuple)
  RETURNS TABLE(geo_time TIMESTAMP, geo GEOMETRY) AS
  $$ SELECT ROW($1.geo_time, $1.geo) $$
    LANGUAGE SQL;

DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS (id int, geos geo_tuple[]);

DROP FUNCTION IF EXISTS t_geos(trajectory, trajectory);

CREATE OR REPLACE FUNCTION t_geos(trajectory)
  RETURNS TABLE(geos geo_tuple[]) AS
  $$ SELECT $1.geos $$
    LANGUAGE SQL;

DROP FUNCTION IF EXISTS t_geo_time_intersect(trajectory,trajectory) CASCADE;
CREATE OR REPLACE FUNCTION t_geo_time_intersect(trajectory, trajectory)
  RETURNS SETOF text AS
    $BODY$
    DECLARE
        g1 text;
        tt text;
        temp_tuple geo_tuple;
    BEGIN
      FOR g1 IN SELECT * from unnest(t_geos($1))
      LOOP
        -- can do some processing here
        RAISE NOTICE 'here';
        tt = 'abc';
        temp_tuple = g1[1];
        RETURN NEXT tt;
        --RETURN NEXT; -- return current row of SELECT
      END LOOP;
      RETURN;
      --SELECT t1.geo_time geo_time, t1.geo geo1, t2.geo geo2 from unnest(t_geos($1)) t1, unnest(t_geos($2)) t2 WHERE t1.geo_time = t2.geo_time;
    END
    $BODY$
LANGUAGE plpgsql;


