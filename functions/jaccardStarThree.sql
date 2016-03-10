DROP FUNCTION IF EXISTS t_jaccard_star(trajectory, trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_jaccard_star(tr1 trajectory, tr2 trajectory, tr3 trajectory) RETURNS float AS
$BODY$
DECLARE
  intersection_area float;
  t1 trajectory;
  t2 trajectory;
  t3 trajectory;
BEGIN
  intersection_area = t_area(t_intersection(t_intersection(tr1, tr2),tr3));

  t1 = t_overlap_union(tr1, tr2);
  t2 = t_overlap_union(tr1, tr3);
  t3 = t_overlap_union(tr2, tr3);

  RETURN intersection_area / t_area(t_union(t_union(t1, t2), t3));
END
$BODY$
LANGUAGE 'plpgsql' ;