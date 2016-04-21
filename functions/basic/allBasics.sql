--addTgpatHead
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



--addTgpatTail


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


--area.sql
DROP FUNCTION IF EXISTS t_area(trajectory);
CREATE OR REPLACE FUNCTION t_area(tr trajectory) RETURNS float AS
$BODY$
DECLARE
    area float;
    tgp tg_pair;
BEGIN
  area = 0;
  if tr ISNULL OR tr.tr_data ISNULL THEN
    return 0;
  END IF;
  FOREACH tgp IN ARRAY tr.tr_data
    LOOP
      --RAISE NOTICE 'loop timestamp --> %', area;
      area = area + ST_Area(tgp.g);
  END LOOP;
  RETURN area;
END
$BODY$
LANGUAGE 'plpgsql' ;

--dropHead.sql
DROP FUNCTION IF EXISTS drop_head( trajectory );
CREATE OR REPLACE FUNCTION drop_head(tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
  new_tr_data tg_pair[] := '{}';
  newIndex int;
  tg tg_pair;
  isFirst BOOL;
BEGIN

  newIndex = 1;
  if coalesce(array_length((tr.tr_data), 1), 0) <= 1 THEN
    RETURN _trajectory(new_tr_data);
  END IF;

  isFirst = true;

  FOREACH tg IN ARRAY tr.tr_data LOOP
    IF NOT isFirst THEN
      --new_tr_data := array_append(new_tr_data, tg);
      new_tr_data[newIndex] = tg;
      newIndex = newIndex + 1;
    END IF;
    isFirst = false;
END LOOP;

  RETURN _trajectory(new_tr_data);
END
$BODY$
LANGUAGE 'plpgsql';

--findTimeLength.sql
DROP FUNCTION IF EXISTS findTimeLength( trajectory );
CREATE OR REPLACE FUNCTION findTimeLength(tr trajectory)
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

--modifyGeomAtTime.sql
DROP FUNCTION IF EXISTS modify_at_time( timestamp WITH TIME ZONE, GEOMETRY, trajectory );
CREATE OR REPLACE FUNCTION modify_at_time(ti timestamp WITH TIME ZONE, ge GEOMETRY, tr trajectory)
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

--recordAt.sql
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

--removeTail.sql
DROP FUNCTION IF EXISTS remove_tail( trajectory );
CREATE OR REPLACE FUNCTION remove_tail(tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
 j INT;
 len INT;
 new_tr_data tg_pair[] := '{}';

BEGIN
 len = ARRAY_LENGTH(tr.tr_data, 1);
 IF len <= 1 THEN
   RETURN _trajectory(new_tr_data);
 END IF;

 FOR j IN 1..len-1 LOOP
  new_tr_data[j] = tr.tr_data[j];
 END LOOP;

 RETURN _trajectory(new_tr_data);
END
$BODY$
LANGUAGE 'plpgsql';

--samplingInterval.sql
DROP FUNCTION IF EXISTS get_sampling_interval( trajectory );
CREATE OR REPLACE FUNCTION get_sampling_interval(tr trajectory)
  RETURNS INTERVAL AS
$BODY$
DECLARE
 stepSize INTERVAL;

BEGIN
 IF array_length(tr.tr_data, 1) > 1 THEN
    stepSize = (tr.e_time - tr.s_time) / (array_length(tr.tr_data, 1) - 1);
 ELSE
    stepSize = INTERVAL '-1 seconds';
 END IF;

 RETURN stepSize;
END
$BODY$
LANGUAGE 'plpgsql';

--sort.sql
-- by Craig Ringer
DROP FUNCTION IF EXISTS array_sort(ANYARRAY);
CREATE OR REPLACE FUNCTION array_sort (ANYARRAY)
RETURNS ANYARRAY LANGUAGE SQL
AS $$
SELECT array_agg(x ORDER BY x) FROM unnest($1) x;
$$


