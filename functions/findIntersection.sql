DROP FUNCTION IF EXISTS t_intersection(trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_intersection(tr1 trajectory, tr2 trajectory) RETURNS trajectory AS
$BODY$
DECLARE
    tgp1 tg_pair;
    tgp2 tg_pair;
    temp_pair tg_pair;
    area float;
    tgpairs1 tg_pair[];
    tgpairs2 tg_pair[];
    intersecting_pairs tg_pair[];
    indexOfIntersection integer;
    endTime timestamp;
    startTime timestamp;
    result trajectory;
    stepSize INTERVAL;
BEGIN
    if tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL THEN
      union_tr.tr_data = union_pairs;
      RETURN union_tr;
    END IF;

    stepSize = t_sampling_interval(tr1, tr2);

    startTime = LEAST(tr1.s_time, tr2.s_time);
    endTime = GREATEST(tr1.e_time, tr2.e_time);
    if endTime < startTime THEN
      union_tr.tr_data = union_pairs;
      RETURN union_tr;
    END IF;



    WHILE endTime <= startTime LOOP
            temp_pair.t = tgp1.t;
            temp_pair.g := st_intersection(tgp1.g, tgp2.g);
            intersecting_pairs[indexOfIntersection] := temp_pair;
            indexOfIntersection = indexOfIntersection + 1;
    END LOOP;
    --For Jaccard calculation
    indexOfIntersection = 0;
    --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
    area = 0;
    FOREACH tgp1 IN ARRAY tr1.tr_data
    LOOP
      FOREACH tgp2 IN ARRAY tr2.tr_data
      LOOP
          --RAISE NOTICE 'loop timestamp --> %', area;
          IF tgp1.t = tgp2.t THEN
            temp_pair.t = tgp1.t;
            temp_pair.g := st_intersection(tgp1.g, tgp2.g);
            intersecting_pairs[indexOfIntersection] := temp_pair;
            indexOfIntersection = indexOfIntersection + 1;
          END IF;
      END LOOP;
    END LOOP;
    result.id = 25;
    result.tr_data = intersecting_pairs;
    RETURN result;
END
$BODY$
LANGUAGE 'plpgsql' ;