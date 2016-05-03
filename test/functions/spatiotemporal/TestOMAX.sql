DROP FUNCTION IF EXISTS test_t_omax();
CREATE OR REPLACE FUNCTION test_t_omax()
  RETURNS BOOL AS
$BODY$
DECLARE
  t1 trajectory;
  t2 trajectory;
BEGIN

  t1 := _trajectory(
  ARRAY[
    ROW( to_timestamp(10), ST_GeomFromText('POLYGON((10 0, 10 1, 11 1, 11 0, 10 0))') )::tg_pair,
    ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
    ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair,
    ROW( to_timestamp(40), ST_GeomFromText('POLYGON((17 0, 17 1, 18 1, 18 0, 17 0))') )::tg_pair,
    ROW( to_timestamp(50), ST_GeomFromText('POLYGON((20 0, 20 1, 24 1, 24 0, 20 0))') )::tg_pair
  ]::tg_pair[]);

  t2 := _trajectory(
  ARRAY[
    ROW( to_timestamp(20), ST_GeomFromText('POLYGON((13 0, 13 1, 14 1, 14 0, 13 0))') )::tg_pair,
    ROW( to_timestamp(30), ST_GeomFromText('POLYGON((15 0, 15 1, 16 1, 16 0, 15 0))') )::tg_pair
  ]::tg_pair[]);

  --CASE #1
  IF NOT t_omax(t1, t2) = 0.25 THEN
    RAISE EXCEPTION 'Union method failed: CASE 1';
  END IF;

  RETURN TRUE;
END
$BODY$
LANGUAGE 'plpgsql';

SELECT test_t_omax();