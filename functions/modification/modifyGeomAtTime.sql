DROP FUNCTION IF EXISTS t_update_geom_at( timestamp WITH TIME ZONE, GEOMETRY, trajectory );
CREATE OR REPLACE FUNCTION t_update_geom_at(ti timestamp WITH TIME ZONE, ge GEOMETRY, tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
 j INTEGER;
 flag BOOLEAN;
 len INTEGER;
 temp_tgp tg_pair;
 temp_tr_data tg_pair[] := '{}';

BEGIN
 --temp_tr_data[1].t = ti;
 --temp_tr_data[1].g =ge;
 temp_tgp.t = ti;
 temp_tgp.g = ge;
 temp_tr_data[1] = temp_tgp;
 --check whether same geometry
 IF tr.geom_type <> getTrajectoryType(temp_tr_data) THEN
   RAISE EXCEPTION 'Different type of geometry is not allowed'; 
 END IF;
 
 len = ARRAY_LENGTH(tr.tr_data, 1);
 flag = FALSE;
 FOR j IN 1..len LOOP
  IF tr.tr_data[j].t = ti THEN
    tr.tr_data[j] = temp_tgp;
    flag = TRUE;
    EXIT;
  END IF;
 END LOOP;

 IF flag = FALSE THEN
   RAISE EXCEPTION 'Valid Timestamp must be given for modifying trajectory';
 END IF;

 RETURN _trajectory(tr.tr_data);
 
END
$BODY$
LANGUAGE 'plpgsql';
