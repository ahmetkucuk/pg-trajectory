DROP FUNCTION IF EXISTS t_jaccard( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_jaccard(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$
DECLARE
  intersection_area FLOAT;
  union_area        FLOAT;
BEGIN
  intersection_area = t_area(t_intersection(tr1, tr2));
  IF intersection_area = 0
  THEN
    RETURN 0;
  END IF;

  union_area = t_area(t_union(tr1, tr2));
  IF union_area = 0
  THEN
    RETURN 0;
  END IF;

  RETURN intersection_area / union_area;
END
$BODY$
LANGUAGE 'plpgsql';