DROP TABLE IF EXISTS trajectory_table CASCADE;
CREATE TABLE trajectory_table of trajectory;
--alter table trajectory_table
--    add COLUMN id bigserial;
CREATE TABLE id_table (id BIGSERIAL, tr trajectory);

CREATE INDEX spatial_index ON id_table USING GIST (tr.bbox);

SELECT _trajectory_2(
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[],
'trajectory_table'::REGCLASS
);

INSERT INTO trajectory_table(s_time,e_time,geom_type,bbox,sampling_interval,tr_data) VALUES (
  (SELECT * from _trajectory_2(
ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[]
) LIMIT 1));

insert into id_table(tr) VALUES( (_trajectory(
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

select count(*) from trajectory_table;

select * from (select t1.id, t2.id, t_jaccard(t1.tr, t2.tr) as jaccard, t_jaccard_star(t1.tr, t2.tr) as jaccard_star from trajectory_table t1, trajectory_table t2 WHERE t1.id <> t2.id) as T WHERE T.jaccard <> 0;

select count(*) from trajectory_table t;

select t1.id, t2.id, t_jaccard(t1.tr, t2.tr) as jaccard, t_jaccard_star(t1.tr, t2.tr) as jaccard_star from trajectory_table t1, trajectory_table t2 WHERE t1.id = 1000025 AND t2.id = 1000047;
