DROP FUNCTION IF EXISTS t_jaccard_star( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_jaccard_star(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$
DECLARE
  intersection_area FLOAT;
  union_area        FLOAT;
BEGIN
  intersection_area := t_intersection_area(tr1, tr2);
  IF intersection_area = 0
  THEN
    RETURN 0;
  END IF;

  union_area := t_ts_union_area(tr1, tr2);
  RAISE NOTICE 'intersection_area %', intersection_area;
  RAISE NOTICE 'union_area %', union_area;
  IF union_area = 0
  THEN
    RETURN 0;
  END IF;

  RETURN intersection_area / union_area;
END
$BODY$
LANGUAGE 'plpgsql';