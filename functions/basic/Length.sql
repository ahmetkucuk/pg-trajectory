DROP FUNCTION IF EXISTS t_length( trajectory );
CREATE OR REPLACE FUNCTION t_length(tr trajectory)
  RETURNS INTEGER AS
$BODY$

DECLARE
  time_count 	    INTEGER;
  tgp	            tg_pair;

BEGIN

  if tr.tr_data ISNULL THEN
    RETURN 0;
  END IF;

  time_count = 0;

  FOREACH tgp IN ARRAY tr.tr_data
  LOOP
      time_count = time_count + 1;
  END LOOP;


  RETURN time_count;

END

$BODY$
LANGUAGE 'plpgsql';
