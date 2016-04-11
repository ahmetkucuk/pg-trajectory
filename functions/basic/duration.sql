DROP FUNCTION IF EXISTS tg_duration(trajectory);
CREATE OR REPLACE FUNCTION tg_duration(tr trajectory) RETURNS INTERVAL AS
$BODY$
DECLARE
BEGIN
  if tr ISNULL THEN
    return '-1'::INTERVAL;
  END IF;
  RETURN tr.e_time - tr.s_time;
END
$BODY$
LANGUAGE 'plpgsql' ;