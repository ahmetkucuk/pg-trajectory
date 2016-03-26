DROP FUNCTION IF EXISTS findTimeLength( trajectory );
CREATE OR REPLACE FUNCTION findTimeLength(tr trajectory)
  RETURNS INTEGER AS
$BODY$

DECLARE
  time_count 	    INTEGER;
  tgp	            tg_pair;

BEGIN
  time_count = 0;
  
  FOREACH tgp IN ARRAY tr.tr_data
  LOOP
      time_count = time_count + 1;
  END LOOP;


  RETURN time_count;

END

$BODY$
LANGUAGE 'plpgsql';
