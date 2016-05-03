DROP FUNCTION IF EXISTS t_distance( trajectory );
CREATE OR REPLACE FUNCTION t_distance(tr trajectory)
  RETURNS FLOAT AS
$BODY$

DECLARE
  length 	    FLOAT;
  tgp tg_pair;
  prev  tg_pair;

BEGIN

  if tr ISNULL OR tr.geom_type != st_geometrytype(st_makepoint(0,0)) OR tr.tr_data ISNULL THEN
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
