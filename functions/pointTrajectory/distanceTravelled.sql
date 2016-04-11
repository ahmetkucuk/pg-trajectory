DROP FUNCTION IF EXISTS tg_distance_travelled( trajectory );
CREATE OR REPLACE FUNCTION tg_distance_travelled(tr trajectory)
  RETURNS FLOAT AS
$BODY$

DECLARE
  length 	    FLOAT;
  tgp tg_pair;
  prev  tg_pair;

BEGIN

  if tr ISNULL OR tr.geom_type != 'Point' OR tr.tr_data ISNULL THEN
    RETURN -1;
  END IF;


  length = 0;

  prev := head(tr.tr_data);
  FOREACH tgp IN ARRAY tr.tr_data
  LOOP
      length =  length + tg_point_distance(prev, tgp);
  END LOOP;

  RETURN length;

END

$BODY$
LANGUAGE 'plpgsql';
