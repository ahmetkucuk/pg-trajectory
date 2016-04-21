DROP FUNCTION IF EXISTS tg_record_at_interpolated( trajectory, TIMESTAMP);
CREATE OR REPLACE FUNCTION tg_record_at_interpolated(tr trajectory, t TIMESTAMP)
  RETURNS GEOMETRY AS
$BODY$

DECLARE
  tgp tg_pair;
  geom1 GEOMETRY;
  geom2 GEOMETRY;

BEGIN

  if tr.s_time < t AND tr.e_time > t THEN
    RETURN -1;
  END IF;

  FOREACH tgp IN ARRAY tr.tr_data
  LOOP
    IF tgp.t < t THEN
      geom2 := tgp.t;
      RETURN st_interpolatepoint(st_makeline(geom1, geom2), 0.5);
    END IF;
      geom1 := tgp.g;
  END LOOP;

  RETURN NULL;

END

$BODY$
LANGUAGE 'plpgsql';
