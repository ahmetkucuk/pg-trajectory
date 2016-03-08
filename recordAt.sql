DROP FUNCTION IF EXISTS t_record_at(trajectory, TIMESTAMP WITH TIME ZONE);
CREATE OR REPLACE FUNCTION t_record_at(tr trajectory, t TIMESTAMP WITH TIME ZONE) RETURNS Geometry AS
$BODY$
DECLARE
  tgp1 tg_pair;
BEGIN

    FOREACH tgp1 IN ARRAY tr.tr_data
    LOOP
      IF tgp1.t = t THEN
        RETURN tgp1.g;
      END IF;
    END LOOP;
    RETURN NULL;
END
$BODY$
LANGUAGE 'plpgsql' ;