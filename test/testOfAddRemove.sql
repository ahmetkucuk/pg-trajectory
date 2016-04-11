SELECT * FROM trajectory_table ORDER BY id;


ALTER TABLE trajectory_table ALTER COLUMN id TYPE serial;

ALTER TABLE trajectory_table DROP COLUMN id;

ALTER TABLE trajectory_table ADD COLUMN id BIGSERIAL;

SELECT id FROM trajectory_table;

SELECT t1.id, findTimeLength(t1.tr) AS original_tr_length, findTimeLength(drop_head(t1.tr)) AS dropped_Head_time_length, findTimeLength(remove_tail(t1.tr)) AS removed_Tail_time_length
FROM trajectory_table t1
ORDER BY t1.id;


SELECT t.id AS ID, (t.tr).geom_type AS geomType, ARRAY_LENGTH((t.tr).tr_data, 1) AS No_of_Samples,(t.tr).s_time AS start_time, (t.tr).e_time AS end_time, (t.tr).sampling_interval AS sampling_interval 
FROM trajectory_table t ORDER BY t.id;

UPDATE trajectory_table t 
SET tr = drop_head(tr)
WHERE id = 2;


UPDATE trajectory_table t 
SET tr = remove_tail(tr)
WHERE id = 1;

UPDATE trajectory_table t
SET tr = add_at_head(( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair, tr)
WHERE id = 2;
--example of wrong 
UPDATE trajectory_table t
SET tr = add_at_head(( to_timestamp(10), ST_GeomFromText('POINT(5 6)') )::tg_pair, tr)
WHERE id = 2;
--single sample trajectory
insert into trajectory_table(tr) VALUES( (_trajectory(
ARRAY[
  ROW( to_timestamp(30), ST_GeomFromText('POINT(7 8)') )::tg_pair
]::tg_pair[])));

UPDATE trajectory_table t
SET tr = add_at_head(( to_timestamp(20), ST_GeomFromText('POINT(5 6)') )::tg_pair, tr)
WHERE id = 9;
--now check sampling interval

UPDATE trajectory_table t
SET tr = add_at_tail(( to_timestamp(40), ST_GeomFromText('POINT(9 10)') )::tg_pair, tr)
WHERE id = 9;

--wrong entry
UPDATE trajectory_table t
SET tr = add_at_tail(( to_timestamp(45), ST_GeomFromText('POINT(9 10)') )::tg_pair, tr)
WHERE id = 6;

--different geom types not allowed
insert into trajectory_table(tr) VALUES( (_trajectory(
ARRAY[
  ROW( to_timestamp(25), ST_GeomFromText('POINT(7 8)') )::tg_pair,
  ROW( to_timestamp(35), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair
]::tg_pair[])));

DELETE FROM trajectory_table WHERE id > 5;

UPDATE trajectory_table t
SET tr = modify_at_time( to_timestamp(30), ST_GeomFromText('POINT(500 600)'), tr)
WHERE id = 9;

SELECT unnest((t.tr).tr_data)
FROM trajectory_table t 
WHERE id = 9;

SELECT t1.id AS traj_1_ID, t2.id AS traj_2_ID, EuclideanDistance(t1.tr, t2.tr) AS EuclideanDistance
FROM trajectory_table t1, trajectory_table t2
WHERE (t1.tr).geom_type = 'Point' AND (t2.tr).geom_type = 'Point'
ORDER BY t1.id, t2.id;

SELECT zNormalize((t.tr).tr_data,2,3) FROM trajectory_table t WHERE t.id = 2;

DELETE FROM trajectory_table WHERE id = 1;

insert into trajectory_table(id, tr) VALUES(1, _trajectory(
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POINT(5 6)') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POINT(6 7)') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POINT(7 8)') )::tg_pair
]::tg_pair[]));

insert into trajectory_table(id, tr) VALUES(2, _trajectory(
ARRAY[
  ROW( to_timestamp(50), ST_GeomFromText('POINT(11.7 34.9)') )::tg_pair,
  ROW( to_timestamp(60), ST_GeomFromText('POINT(23.8 -89.0)') )::tg_pair,
  ROW( to_timestamp(70), ST_GeomFromText('POINT(79.1 2.9)') )::tg_pair,
  ROW( to_timestamp(80), ST_GeomFromText('POINT(21.2 23.5)') )::tg_pair,
  ROW( to_timestamp(80), ST_GeomFromText('POINT(121.2 423.5)') )::tg_pair
]::tg_pair[]));

UPDATE trajectory_table t 
SET tr = drop_head(tr)
WHERE id = 1;

UPDATE trajectory_table t
SET tr = add_at_head(( to_timestamp(10), ST_GeomFromText('POINT(5 6)'))::tg_pair, tr)
WHERE id = 1;


UPDATE trajectory_table t
SET tr = add_at_tail(( to_timestamp(40), ST_GeomFromText('POINT(9 10)') )::tg_pair, tr)
WHERE id = 1;
UPDATE trajectory_table t 
SET tr = remove_tail(tr)
WHERE id = 1;
UPDATE trajectory_table t
SET tr = modify_at_time( to_timestamp(30), ST_GeomFromText('POINT(500 600)'), tr)
WHERE id = 1;







