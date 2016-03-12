DROP FUNCTION IF EXISTS t_jaccard_star(trajectory, trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_jaccard_star(tr1 trajectory, tr2 trajectory, tr3 trajectory) RETURNS float AS
$BODY$
DECLARE
  intersection_area float;
  union_area float;
  t1 trajectory;
  t2 trajectory;
  t3 trajectory;
BEGIN
  intersection_area = t_area(t_intersection(t_intersection(tr1, tr2),tr3));

  if intersection_area = 0 THEN
    return 0;
  END IF;
  --t_ts_union -> union in time and space
  --t_time_union union in time
  --if tr1 and tr2 intersect both in time and space get time stamp of tr3 where tr1 and tr2 intersects
  t1 = t_time_union(t_ts_union(tr1, tr2), tr3);
  t2 = t_time_union(t_ts_union(tr1, tr3), tr2);
  t3 = t_time_union(t_ts_union(tr2, tr3), tr1);

  union_area = t_area(t_union(t_union(t1, t2), t3));
  RAISE NOTICE '%', union_area;
  if union_area = 0 THEN
    return 0;
  END IF;
  RETURN intersection_area / union_area;
END
$BODY$
LANGUAGE 'plpgsql' ;