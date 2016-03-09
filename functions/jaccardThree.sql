DROP FUNCTION IF EXISTS t_jaccard(trajectory, trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_jaccard(tr1 trajectory, tr2 trajectory, tr3 trajectory) RETURNS float AS
$BODY$
DECLARE
BEGIN
  RETURN t_area(t_intersection(t_intersection(tr1, tr2), tr3)) / t_area(t_union(t_union(tr1, tr2), tr3));
END
$BODY$
LANGUAGE 'plpgsql' ;