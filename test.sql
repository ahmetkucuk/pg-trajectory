DROP TABLE IF EXISTS t_table CASCADE;
CREATE TABLE t_table (traj trajectory);

DROP TABLE IF EXISTS t_table_test CASCADE;
CREATE TABLE t_table_test (count int);
INSERT INTO t_table_test VALUES(2);

INSERT INTO t_table VALUES((1, ARRAY[ROW('2002-03-11 12:01AM', ST_GeomFromText('POINT(3 4)'))::geo_tuple, ROW('2002-03-11 12:01AM', ST_GeomFromText('POINT(3 4)'))::geo_tuple]));

SELECT * from t_table;

SELECT t_geos(t_table.traj) from t_table;

SELECT t1.geo_time geo_time, t1.geo geo1, t2.geo geo2 FROM unnest((SELECT t_geos(t_table.traj) from t_table)) t1, unnest((SELECT t_geos(t_table.traj) from t_table)) t2;

SELECT t1.geo_time geo_time, t1.geo geo1, t2.geo geo2 from unnest(t_geos(t_table.traj)) t1, unnest(t_geos(t_table.traj)) t2 WHERE t1.geo_time = t2.geo_time;

SELECT t.a, t.b from unnest(t_geos(t_table.traj), t_geos(t_table.traj)) AS t(a, b);

SELECT t_geo_to_tuple(unnest(t_geos(t1.traj))) FROM t_table t1;

SELECT t_geo_time_intersect((SELECT t_table.traj from t_table), (SELECT t_table.traj from t_table));
SELECT t_geo_time_intersect(t1.traj, t2.traj) from t_table t1, t_table t2;

--an example insert statement with three time-geometry pairs
insert into trajectoryTable (id, s_time, e_time, bbox, tr_data)
values(
4,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[
  ROW( to_timestamp(9955598), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(75600), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(601), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair
]::tg_pair[]
);

select calculatejaccardstar(3, 4);