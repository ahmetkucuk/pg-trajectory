DROP FUNCTION IF EXISTS head( tg_pairs[] );

--Since array indexing mechanism in plpgsql is a mystery,
-- we shouldn't use static number to get first element
CREATE OR REPLACE FUNCTION head(tg_pairs tg_pair[])
  RETURNS tg_pair AS
$BODY$
DECLARE
  tg tg_pair;
BEGIN

  if coalesce(array_length(tg_pairs, 1), 0) <= 1 THEN
    RETURN tg;
  END IF;

  FOREACH tg IN ARRAY tg_pairs LOOP
    RETURN tg;
  END LOOP;
END
$BODY$
LANGUAGE 'plpgsql';