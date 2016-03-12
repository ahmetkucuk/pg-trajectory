CREATE OR REPLACE FUNCTION public.t_jaccard(tr1 trajectory, tr2 trajectory)
  RETURNS float8
AS
$BODY$
  DECLARE
  intersection_area float;
  union_area float;
BEGIN
    intersection_area = t_area(t_intersection(tr1, tr2));
  if intersection_area = 0 THEN
    return 0;
  END IF;

  union_area = t_area(t_union(tr1, tr2));
  if union_area = 0 THEN
    return 0;
  END IF;

  RETURN intersection_area / union_area;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
CREATE OR REPLACE FUNCTION public.t_jaccard(tr1 trajectory, tr2 trajectory, tr3 trajectory)
  RETURNS float8
AS
$BODY$
  DECLARE
BEGIN
  RETURN t_area(t_intersection(t_intersection(tr1, tr2), tr3)) / t_area(t_union(t_union(tr1, tr2), tr3));
END
$BODY$
LANGUAGE plpgsql VOLATILE;