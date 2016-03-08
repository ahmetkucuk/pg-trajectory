DROP FUNCTION IF EXISTS t_jaccard(trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_jaccard(tr1 trajectory, tr2 trajectory) RETURNS float AS
$BODY$
DECLARE
BEGIN
  RETURN t_area(t_intersection(tr1, tr2)) / t_area(t_union(tr1, tr2));
END
$BODY$
LANGUAGE 'plpgsql' ;