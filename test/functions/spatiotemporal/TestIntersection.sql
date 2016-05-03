DROP FUNCTION IF EXISTS test_t_intersection();
CREATE OR REPLACE FUNCTION test_t_intersection()
  RETURNS BOOL AS
$BODY$
DECLARE
  t1 trajectory;
  t2 trajectory;
  actual_union trajectory;
BEGIN

  t1 := _trajectory(
  ARRAY[
    ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
    ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
    ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
    ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair
  ]::tg_pair[]);

  t2 := _trajectory(
  ARRAY[
    ROW( to_timestamp(10), ST_GeomFromText('POLYGON((20 0, 20 1, 21 1, 21 0, 20 0))') )::tg_pair,
    ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
    ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair
  ]::tg_pair[]);

  --CASE #1
  IF t_equals(t_union(t1, t2), actual_union) THEN
    RAISE EXCEPTION 'Intersection method failed: CASE 1';
  END IF;

  --CASE #2
  IF t_equals(t_union(t2, t2), actual_union) THEN
    RAISE EXCEPTION 'Intersection method failed: CASE 1';
  END IF;

  RETURN TRUE;
END
$BODY$
LANGUAGE 'plpgsql';

SELECT test_t_intersection();