DROP FUNCTION IF EXISTS drop_head( trajectory );
CREATE OR REPLACE FUNCTION drop_head(tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
  new_tr_data tg_pair[];
  newIndex int;
BEGIN

  newIndex = 0;
  RAISE NOTICE 'in drop head start %', array_length((tr.tr_data), 1);
  For i in 2..array_length((tr.tr_data), 1) LOOP
    RAISE NOTICE 'in drop head %', i;
    new_tr_data[newIndex] = (tr.tr_data)[i];
    newIndex = newIndex + 1;
  END LOOP;

  RETURN _trajectory(new_tr_data);
END
$BODY$
LANGUAGE 'plpgsql';