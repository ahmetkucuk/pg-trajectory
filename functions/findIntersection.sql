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
    result trajectory;
BEGIN

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