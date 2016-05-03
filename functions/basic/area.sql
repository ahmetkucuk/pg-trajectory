DROP FUNCTION IF EXISTS t_area(trajectory);
CREATE OR REPLACE FUNCTION t_area(tr trajectory) RETURNS float AS
$BODY$
DECLARE
    area float;
    tgp tg_pair;
BEGIN
  area = 0;
  if tr ISNULL OR tr.tr_data ISNULL THEN
    return 0;
  END IF;

  FOREACH tgp IN ARRAY tr.tr_data
    LOOP
      RAISE NOTICE 'loop timestamp --> %', ST_Area(tgp.g);
      area = area + ST_Area(tgp.g);
  END LOOP;
  RETURN area;
END
$BODY$
LANGUAGE 'plpgsql' ;