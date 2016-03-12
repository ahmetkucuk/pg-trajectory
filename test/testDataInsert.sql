
DROP TABLE IF EXISTS t_table CASCADE;
CREATE TABLE t_table (tr trajectory);

insert into t_table (tr)
values(
  (
4,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[
  ROW( to_timestamp(9955598), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(75600), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(601), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair
]::tg_pair[]
));


insert into t_table (tr)
values(
  (
5,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[

  ROW( to_timestamp(9955244), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(9955598), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(75600), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(601), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair
]::tg_pair[]
));

insert into t_table (tr)
values(
  (
6,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[

  ROW( to_timestamp(9955532), ST_GeomFromText('POLYGON((0 0, 0 0.5, 0.5 0.5, 0.5 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(9955598), ST_GeomFromText('POLYGON((0 0, 0 0.5, 0.5 0.5, 0.5 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(75600), ST_GeomFromText('POLYGON((0 0, 0 0.5, 0.5 0.5, 0.5 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(601), ST_GeomFromText('POLYGON((0 0, 0 0.5, 0.5 0.5, 0.5 0, 0 0))') )::tg_pair
]::tg_pair[]
));

insert into t_table (tr)
values(
  (
7,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[


  ROW( to_timestamp(12324), ST_GeomFromText('POLYGON((0 0, 0 -1, -1 -1, -1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(321434), ST_GeomFromText('POLYGON((0 0, 0 -1, -1 -1, -1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(122334), ST_GeomFromText('POLYGON((0 0, 0 -1, -1 -1, -1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(43224), ST_GeomFromText('POLYGON((0 0, 0 -1, -1 -1, -1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(75600), ST_GeomFromText('POLYGON((0 0, 0 -1, -1 -1, -1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(601), ST_GeomFromText('POLYGON((0 0, 0 -1, -1 -1, -1 0, 0 0))') )::tg_pair
]::tg_pair[]
));

insert into t_table (tr)
values(
  (
8,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[
  ROW( to_timestamp(9955598), ST_GeomFromText('POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(75600), ST_GeomFromText('POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(601), ST_GeomFromText('POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))') )::tg_pair
]::tg_pair[]
));


DROP TABLE IF EXISTS trajectory_table CASCADE;
CREATE TABLE trajectory_table (tr trajectory);

insert into trajectory_table (tr)
values(
  (
1,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((0 0, 0 1, 1 1, 1 0, 0 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((3 0, 3 1, 4 1, 4 0, 3 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((5 0, 5 1, 6 1, 6 0, 5 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((7 0, 7 1, 8 1, 8 0, 7 0))') )::tg_pair
]::tg_pair[]
));

insert into trajectory_table (tr)
values(
  (
2,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((0 2, 0 3, 1 3, 1 2, 0 2))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((3 2, 3 3, 4 3, 4 2, 3 2))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((5 0, 5 1, 6 1, 6 0, 5 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((7 0, 7 1, 8 1, 8 0, 7 0))') )::tg_pair
]::tg_pair[]
));

insert into trajectory_table (tr)
values(
  (
3,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((0 -2, 0 -3, 1 -3, 1 -2, 0 -2))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((3 -2, 3 -3, 4 -3, 4 -2, 3 -2))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((5 0, 5 1, 6 1, 6 0, 5 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((7 0, 7 1, 8 1, 8 0, 7 0))') )::tg_pair
]::tg_pair[]
));

insert into trajectory_table (tr)
values(
  (
4,
to_timestamp(55399),
to_timestamp(55801),
NULL, --whatever

ARRAY[
  ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
  ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
  ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
  ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
]::tg_pair[]
));