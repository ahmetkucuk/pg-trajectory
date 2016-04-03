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
