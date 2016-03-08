DROP FUNCTION IF EXISTS t_area(trajectory);
CREATE OR REPLACE FUNCTION t_area(tr trajectory) RETURNS float AS
$BODY$
DECLARE
    area float;
    tgp tg_pair;
BEGIN
  area = 0;
  FOREACH tgp IN ARRAY tr.tr_data
    LOOP
      RAISE NOTICE 'loop timestamp --> %', area;
      area = area + ST_Area(tgp.g);
  END LOOP;
  RETURN area;
END
$BODY$
LANGUAGE 'plpgsql' ;