DROP FUNCTION IF EXISTS calculateJaccardStar(integer, integer);
CREATE OR REPLACE FUNCTION calculateJaccardStar(tr_id1 integer, tr_id2 integer) RETURNS float AS
$BODY$
DECLARE
    jaccarStart float;
BEGIN
  RETURN findintersectionoftwo($1,$2) / findUnionOfTwo($1, $2);
END
$BODY$
LANGUAGE 'plpgsql' ;