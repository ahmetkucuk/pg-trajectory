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