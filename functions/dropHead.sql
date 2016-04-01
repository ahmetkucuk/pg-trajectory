DROP FUNCTION IF EXISTS drop_head( trajectory );
CREATE OR REPLACE FUNCTION drop_head(tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
  new_tr_data tg_pair[] := '{}';
  newIndex int;
BEGIN

  newIndex = 1;
  if coalesce(array_length((tr.tr_data), 1), 0) <= 1 THEN
    RETURN _trajectory(new_tr_data);
  END IF;


  For i in 2..array_length((tr.tr_data), 1) LOOP
    new_tr_data := array_append(new_tr_data, (tr.tr_data)[(i - 1)]);
    newIndex = newIndex + 1;
  END LOOP;

  RETURN _trajectory(new_tr_data);
END
$BODY$
LANGUAGE 'plpgsql';