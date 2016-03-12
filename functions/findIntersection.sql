DROP FUNCTION IF EXISTS t_intersection( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_intersection(tr1 trajectory, tr2 trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
  tgp1                tg_pair;
  tgp2                tg_pair;
  temp_pair           tg_pair;
  area                FLOAT;
  tgpairs1            tg_pair [];
  tgpairs2            tg_pair [];
  intersecting_pairs  tg_pair [];
  indexOfIntersection INTEGER;
  endTime             TIMESTAMP;
  startTime           TIMESTAMP;
  result              trajectory;
  stepSize            INTERVAL;
  stepSizeLong        INT8;
  startIndex1         INTEGER;
  startIndex2         INTEGER;
  endIndex1           INTEGER;
  endIndex2           INTEGER;
BEGIN
  IF tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL
  THEN
  --intersection_tr.tr_data = intersecting_pairs;
  --RETURN intersection_tr;
  END IF;

  stepSize = t_sampling_interval(tr1, tr2);
  RAISE NOTICE '%', stepSize;
  IF stepSize = '-1 seconds'::INTERVAL THEN --then it means both of them have only one time-geo pair
    tgp1 := tr1.tr_data [1];
    RAISE NOTICE '%', tgp1;
    tgp2 := tr2.tr_data [1];
    RAISE NOTICE '%', tgp1;
    indexOfIntersection = 0;
    IF tgp1.t = tgp2.t THEN
      temp_pair.t = tgp1.t;
      temp_pair.g := st_intersection(tgp1.g, tgp2.g);
      intersecting_pairs [indexOfIntersection] := temp_pair;
    END IF;
    result.id = 25;
    result.tr_data = intersecting_pairs;
    RETURN result;
  END IF;


  stepSizeLong := EXTRACT(EPOCH FROM stepSize);
  RAISE NOTICE 'long step size -> %', stepSizeLong;


  startTime = GREATEST(tr1.s_time, tr2.s_time);
  endTime = LEAST(tr1.e_time, tr2.e_time);
  IF endTime >= startTime THEN
    RAISE NOTICE 'ss - %', (tr2.s_time - startTime);
    startIndex1 := abs(extract(EPOCH FROM (tr1.s_time - startTime))) / stepSizeLong;
    endIndex1 := abs(extract(EPOCH FROM (tr1.e_time - startTime))) / stepSizeLong;

    startIndex2 := abs(extract(EPOCH FROM (tr2.s_time - startTime))) / stepSizeLong;
    endIndex2 := abs(extract(EPOCH FROM (tr2.e_time - startTime))) / stepSizeLong;

  IF tr1.s_time = tr1.e_time OR tr2.s_time = tr2.e_time THEN
    endIndex1 = startIndex1;
    endIndex2 = startIndex2;
  END IF;

    RAISE NOTICE 'startIndex1 - %', startIndex1;
    RAISE NOTICE 'startIndex2 - %', startIndex2;
    RAISE NOTICE 'endIndex1 - %', endIndex1;
    RAISE NOTICE 'endIndex2 - %', endIndex2;
  END IF;

  RAISE NOTICE 'e1 - s1 = %', (endIndex1 - startIndex1);
  RAISE NOTICE 'e2 - s2 = %', (endIndex2 - startIndex2);
  IF  (endIndex1 - startIndex1) = 0 THEN --then there is only one time-geo pair that starts at start indices
    tgp1 := tr1.tr_data [1];
    RAISE NOTICE '%', tgp1;
    tgp2 := tr2.tr_data [1];
    RAISE NOTICE '%', tgp1;
    indexOfIntersection = 0;
    IF tgp1.t = tgp2.t THEN
      temp_pair.t = tgp1.t;
      temp_pair.g := st_intersection(tgp1.g, tgp2.g);
      intersecting_pairs [indexOfIntersection] := temp_pair;
    END IF;
    result.id = 25;
    result.tr_data = intersecting_pairs;
    RETURN result;
  END IF;

  indexOfIntersection = 0;
  FOR i IN 1..(endIndex1 - startIndex1) LOOP
    --RAISE NOTICE 't1 -- %', (tr1.tr_data [startIndex1 + i]).t;
    --RAISE NOTICE 't2 -- %', (tr2.tr_data [startIndex2 + i]).t;
    tgp1 := tr1.tr_data [startIndex1 + i];
    tgp2 := tr2.tr_data [startIndex2 + i];
    IF tgp1.t = tgp2.t THEN
      temp_pair.t = tgp1.t;
      temp_pair.g := st_intersection(tgp1.g, tgp2.g);
      intersecting_pairs [indexOfIntersection] := temp_pair;
      indexOfIntersection = indexOfIntersection + 1;
    END IF;

  END LOOP;

  result.id = 25;
  result.tr_data = intersecting_pairs;
  RETURN result;
END
$BODY$
LANGUAGE 'plpgsql';

SELECT t_intersection(t1.tr, t2.tr)
FROM trajectory_table t1, trajectory_table t2
WHERE (t2.tr).id = 216 AND (t1.tr).id = 217;
