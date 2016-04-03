SELECT * FROM trajectory_table ORDER BY id;

select t1.id, t2.id, t_jaccard(t1.tr, t2.tr) as jaccard, t_jaccard_star(t1.tr, t2.tr) as jaccard_star 
from trajectory_table t1, trajectory_table t2 WHERE t1.id = 1000025 AND t2.id = 1000047;

select * from (select t1.id, t2.id, t_jaccard(t1.tr, t2.tr) as jaccard, t_jaccard_star(t1.tr, t2.tr) as jaccard_star 
from trajectory_table t1, trajectory_table t2 WHERE t1.id <> t2.id) as T WHERE T.jaccard <> 0;

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
WHERE id = 6;
--now check sampling interval

UPDATE trajectory_table t
SET tr = add_at_tail(( to_timestamp(40), ST_GeomFromText('POINT(9 10)') )::tg_pair, tr)
WHERE id = 6;

--wrong entry
UPDATE trajectory_table t
SET tr = add_at_tail(( to_timestamp(45), ST_GeomFromText('POINT(9 10)') )::tg_pair, tr)
WHERE id = 6;

insert into trajectory_table(tr) VALUES( (_trajectory(
ARRAY[
  ROW( to_timestamp(100), ST_GeomFromText('POINT(123 234)') )::tg_pair
]::tg_pair[])));

UPDATE trajectory_table t
SET tr = add_at_tail(( to_timestamp(105), ST_GeomFromText('POINT(234 456)') )::tg_pair, tr)
WHERE id = 7;

UPDATE trajectory_table t
SET tr = add_at_head(( to_timestamp(95), ST_GeomFromText('POINT(98 67)') )::tg_pair, tr)
WHERE id = 7;




