DROP TYPE IF EXISTS geo_tuple CASCADE;
CREATE TYPE geo_tuple AS (geo_time TIMESTAMP, geo GEOMETRY);

DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS (id int, geos geo_tuple[]);

DROP FUNCTION IF EXISTS t_geos(trajectory, trajectory);

CREATE OR REPLACE FUNCTION t_geos(trajectory)
  RETURNS TABLE(geos geo_tuple[]) AS
  $$ SELECT $1.geos $$
    LANGUAGE SQL;

CREATE OR REPLACE FUNCTION t_geo_time_intersect(trajectory, trajectory)
  RETURNS TABLE(geo_time1 TIMESTAMP, geo1 GEOMETRY, geo_time2 TIMESTAMP, geo2 GEOMETRY) AS
  $$ SELECT * from unnest(t_geos($1)) t1, unnest(t_geos($1)) t2 WHERE t1.geo_time = t2.geo_time $$
    LANGUAGE SQL;


DROP FUNCTION IF EXISTS t_union(trajectory, trajectory);

CREATE OR REPLACE FUNCTION t_union(trajectory, trajectory)

  RETURNS TABLE(union_of_trajectories trajectory) AS
    $BODY$
    BEGIN

    END;
    $BODY$
LANGUAGE plpgsql;
