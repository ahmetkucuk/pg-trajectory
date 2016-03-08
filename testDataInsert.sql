
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