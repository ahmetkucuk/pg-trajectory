DROP FUNCTION IF EXISTS t_jaccard_star(trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_jaccard_star(tr1 trajectory, tr2 trajectory) RETURNS float AS
$BODY$
DECLARE
BEGIN
  RETURN t_area(t_intersection(tr1, tr2)) / t_area(t_overlap_union(tr1, tr2));
END
$BODY$
LANGUAGE 'plpgsql' ;