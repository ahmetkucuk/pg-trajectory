DROP TABLE IF EXISTS trajectory_table CASCADE;
CREATE TABLE trajectory_table (tr trajectory);

insert into trajectory_table (tr)
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
insert into trajectory_table(tr) VALUES( (_trajectory(35,
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[])));

insert into trajectory_table(tr) VALUES( (_trajectory(210,ARRAY[
  ROW( to_timestamp(90), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(3200), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(100), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[])));

select count(*) from trajectory_table;

select t_jaccard(t1.tr, t2.tr, t3.tr) from trajectory_table t1, trajectory_table t2, trajectory_table t3;





select unnest((trajectory_table.tr).tr_data) from trajectory_table WHERE (trajectory_table.tr).id = 6004236;