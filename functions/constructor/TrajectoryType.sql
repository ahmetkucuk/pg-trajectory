DROP FUNCTION IF EXISTS tg_type(tg_pair[]);
CREATE OR REPLACE FUNCTION tg_type(tr_data tg_pair[]) RETURNS Text AS
$BODY$
DECLARE
  tgp tg_pair;
  --flag BOOLEAN;
  type_of_first TEXT;
  number_of_Different int;

BEGIN

  --Simpler way to do this
  --
  number_of_Different := (SELECT COUNT(*) FROM (SELECT DISTINCT ST_GeometryType((unnest(tr_data)).g)) AS X);

  IF number_of_Different = 1 THEN
    RETURN (SELECT ST_GeometryType((unnest(tr_data)).g) LIMIT 1);
  END IF;

  RETURN 'Invalid';
END
$BODY$
LANGUAGE 'plpgsql';
