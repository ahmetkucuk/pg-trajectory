DROP FUNCTION IF EXISTS tg_head( tg_pairs[] );

--Since array indexing mechanism in plpgsql is a mystery,
-- we shouldn't use static number to get first element
CREATE OR REPLACE FUNCTION tg_head(tg_pairs tg_pair[])
  RETURNS tg_pair AS
$BODY$
DECLARE
  tg tg_pair;
BEGIN

  if tg_pairs ISNULL THEN
    RETURN tg;
  END IF;

  FOREACH tg IN ARRAY tg_pairs LOOP
    RETURN tg;
  END LOOP;
END
$BODY$
LANGUAGE 'plpgsql';