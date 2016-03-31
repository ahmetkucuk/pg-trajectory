DROP TABLE IF EXISTS trajectory_table CASCADE;
CREATE TABLE trajectory_table (tr trajectory);

insert into trajectory_table (tr)
values(
  _trajectory(
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[]
));
insert into trajectory_table(tr) VALUES( (_trajectory(
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[])));

insert into trajectory_table(tr) VALUES( (_trajectory(ARRAY[
  ROW( to_timestamp(90), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(3200), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(100), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[])));

insert into trajectory_table(tr) VALUES( (_trajectory(
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POINT(5 6)') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POINT(6 7)') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POINT(7 8)') )::tg_pair
]::tg_pair[])));

insert into trajectory_table(tr) VALUES( (_trajectory(
ARRAY[
  ROW( to_timestamp(50), ST_GeomFromText('POINT(11.7 34.9)') )::tg_pair,
  ROW( to_timestamp(60), ST_GeomFromText('POINT(23.8 -89.0)') )::tg_pair,
  ROW( to_timestamp(70), ST_GeomFromText('POINT(79.1 2.9)') )::tg_pair,
  ROW( to_timestamp(80), ST_GeomFromText('POINT(21.2 23.5)') )::tg_pair
]::tg_pair[])));

select count(*) from trajectory_table;

select t_jaccard(t1.tr, t2.tr, t3.tr) from trajectory_table t1, trajectory_table t2, trajectory_table t3;

select * from trajectory_table t;