DROP TABLE generic_trajectory_table;

CREATE TABLE generic_trajectory_table(trCol Trajectory);

insert into generic_trajectory_table (trCol)
values(
  _trajectory(
4,
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[]
));

insert into generic_trajectory_table(trCol) VALUES( (_trajectory(35,
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[])));

insert into generic_trajectory_table(trCol) VALUES( (_trajectory(210,ARRAY[
  ROW( to_timestamp(90), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(3200), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(100), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[])));

insert into generic_trajectory_table(trCol) VALUES( (_trajectory(318,
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POINT(1 2)') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POINT(10 11)') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POINT(3 4)') )::tg_pair
]::tg_pair[])));

insert into generic_trajectory_table(trCol) VALUES( (_trajectory(48,
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POINT(5 6)') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POINT(6 7)') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POINT(7 8)') )::tg_pair
]::tg_pair[])));

insert into generic_trajectory_table(trCol) VALUES( (_trajectory(67,
ARRAY[
  ROW( to_timestamp(50), ST_GeomFromText('POINT(11.7 34.9)') )::tg_pair,
  ROW( to_timestamp(60), ST_GeomFromText('POINT(23.8 -89.0)') )::tg_pair,
  ROW( to_timestamp(70), ST_GeomFromText('POINT(79.1 2.9)') )::tg_pair,
  ROW( to_timestamp(80), ST_GeomFromText('POINT(21.2 23.5)') )::tg_pair
]::tg_pair[])));

insert into generic_trajectory_table(trCol) VALUES( (_trajectory(23,
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POINT(5 6)') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POINT(7 8)') )::tg_pair
]::tg_pair[])));


SELECT (t.trCol).id, (t.trCol).geom_type FROM generic_trajectory_table AS t;


DELETE FROM generic_trajectory_table AS t WHERE (t.trCol).geom_type = 'Invalid';

SELECT zNormalize((t.trCol).tr_data,2,3) FROM generic_trajectory_table t WHERE (t.trCol).id = 318;

SELECT (t.trCol).id, (t.trCol).geom_type, findTimeLength(t.trCol) AS Duration 
FROM generic_trajectory_table t 
WHERE (t.trCol).geom_type = 'Point'; 

SELECT (t1.trCol).id AS traj_1_ID, (t2.trCol).id AS traj_2_ID, EuclideanDistance(t1.trCol, t2.trCol) AS EuclideanDistance
FROM generic_trajectory_table t1, generic_trajectory_table t2
WHERE (t1.trCol).id = 48 AND (t2.trCol).id = 67;




