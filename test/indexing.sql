SELECT count(*) from indexed_trajectory_table;
SELECT count(*) from trajectory_table;

DROP INDEX temporal_index;

CREATE INDEX temporal_index ON indexed_trajectory_table USING btree ( tsrange(s_time, e_time, '[]'));
CREATE INDEX temporal_index_s ON indexed_trajectory_table (s_time);
CREATE INDEX temporal_index_e ON indexed_trajectory_table (e_time);
CREATE INDEX spatial_index ON indexed_trajectory_table USING GIST (bbox);

VACUUM indexed_trajectory_table;

SELECT count(*) FROM indexed_trajectory_table t1, indexed_trajectory_table t2 WHERE st_intersects(t1.bbox, t2.bbox);

SELECT count(*) FROM trajectory_table t1, trajectory_table t2 WHERE st_intersects(t1.bbox, t2.bbox);

SELECT DISTINCT (t1.s_time) FROM indexed_trajectory_table t1 ORDER BY t1.s_time LIMIT 20000;
SELECT max(t1.s_time) FROM indexed_trajectory_table t1;
SELECT count(t1.s_time) FROM indexed_trajectory_table t1 WHERE t1.s_time > '1970-01-01 14:14:02'::Timestamp;
SELECT count(*) FROM trajectory_table t1, trajectory_table t2 WHERE t1.s_time > '1970-01-01 02:14:02'::Timestamp AND t1.e_time < '1970-01-01 03:14:02'::Timestamp AND st_intersects(t1.bbox, t2.bbox);

SELECT count(*) FROM indexed_trajectory_table t1, indexed_trajectory_table t2 WHERE t1.s_time > '1970-01-01 02:14:02'::Timestamp AND t1.e_time < '1970-01-01 03:14:02'::Timestamp AND st_intersects(t1.bbox, t2.bbox);

SELECT count(*) FROM trajectory_table t1 WHERE t1.s_time > t2.e_time AND t1.e_time < t2.s_time;

DELETE FROM trajectory_table t1 WHERE st_isempty(t1.bbox);


