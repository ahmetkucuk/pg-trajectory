DROP FUNCTION IF EXISTS add_at_head( tg_pair, trajectory );
CREATE OR REPLACE FUNCTION add_at_head(tgp tg_pair, tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
 j INTEGER;
 len INTEGER;
 new_tr_data tg_pair[] := '{}';

BEGIN
 new_tr_data[1] = tgp;
 len = ARRAY_LENGTH(tr.tr_data, 1);

 --don't add at head if time of tg pair is after the first tg pair of trajectory
 IF tgp.t > tr.tr_data[1].t THEN
    RAISE EXCEPTION 'New tg pair must precede the first tg pair';
 END IF;

 --check whether same geometry
 IF tr.geom_type <> getTrajectoryType(new_tr_data) THEN
   RAISE EXCEPTION 'Different type of geometry can not be added at head'; 
 END IF;
 
 --If sampling interval of input trajectory = -1, that means that trajectory has only 1 tg pair. We can add our new tg pair in the head.
 --Sampling interval of the input trajectory must be equal to the timestamp differene of new tg pair and 1st tg pair of tr_data
 IF tr.sampling_interval <> INTERVAL '-1 seconds' AND tr.sampling_interval <> (tr.tr_data[1].t - new_tr_data[1].t) THEN
   RAISE EXCEPTION 'Sampling interval of the input trajectory must be equal to the timestamp differene of new tg pair and 
                    1st tg pair of the input trajectory';
 END IF;
 
 FOR j in 2..len+1 LOOP
   new_tr_data[j] = tr.tr_data[j-1];
 END LOOP;

 RETURN _trajectory(new_tr_data);
 
END
$BODY$
LANGUAGE 'plpgsql';
