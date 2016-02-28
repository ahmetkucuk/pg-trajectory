DROP TABLE IF EXISTS t_table CASCADE;
CREATE TABLE t_table (traj trajectory);

INSERT INTO t_table VALUES((1, ARRAY[(now(), ST_GeomFromText('POINT(3 4)'))::geo_tuple, (now(), ST_GeomFromText('POINT(3 4)'))::geo_tuple]));

SELECT * from t_table;

SELECT t_geos(t_table.traj) from t_table;

SELECT * FROM unnest((SELECT t_geos(t_table.traj) from t_table)) t1, unnest((SELECT t_geos(t_table.traj) from t_table)) t2
WHERE t1.geo_time = t2.geo_time;