DROP FUNCTION IF EXISTS t_record_at(trajectory, TIMESTAMP);
CREATE OR REPLACE FUNCTION t_record_at(tr trajectory, t TIMESTAMP) RETURNS Geometry AS
$BODY$
DECLARE
  tgp1 tg_pair;
BEGIN

  PERFORM ASSERT IS NOT NULL tr;

    FOREACH tgp1 IN ARRAY tr.tr_data
    LOOP
      IF tgp1.t = t THEN
        RETURN tgp1.g;
      END IF;
    END LOOP;

    IF tr.geom_type = 'Point' THEN
      RETURN tg_record_at_interpolated(tr, t);
    END IF;


    RETURN NULL;
END
$BODY$
LANGUAGE 'plpgsql' ;