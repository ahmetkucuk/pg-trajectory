DROP FUNCTION IF EXISTS add_at_tail( tg_pair, trajectory );
CREATE OR REPLACE FUNCTION add_at_tail(tgp tg_pair, tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
 j INTEGER;
 len INTEGER;
 temp_tr_data tg_pair[] := '{}';

BEGIN

 len = ARRAY_LENGTH(tr.tr_data, 1);

 --check if new tg pair appears before the last tg pair
 IF tgp.t < tr.tr_data[len].t THEN
    RAISE EXCEPTION 'New tg pair must follow the last tg pair';
 END IF;

 temp_tr_data[1] = tgp;
 --check whether same geometry
 IF tr.geom_type <> getTrajectoryType(temp_tr_data) THEN
   RAISE EXCEPTION 'Different type of geometry can not be added at head'; 
 END IF;
 
 --If sampling interval of input trajectory = -1, that means that trajectory has only 1 tg pair. We can add our new tg pair in the head.
 --Sampling interval of the input trajectory must be equal to the timestamp differene of new tg pair and 1st tg pair of tr_data
 IF tr.sampling_interval <> INTERVAL '-1 seconds' AND tr.sampling_interval <> (tgp.t - tr.tr_data[len].t) THEN
   RAISE EXCEPTION 'Sampling interval of the input trajectory must be equal 
                    to the timestamp difference of last tg pair of the input trajectory  and the new tg pair';
 END IF;

 tr.tr_data[len+1] = tgp;

 RETURN _trajectory(tr.tr_data);
 
END
$BODY$
LANGUAGE 'plpgsql';
