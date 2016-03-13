DROP FUNCTION IF EXISTS t_union( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_union(tr1 trajectory, tr2 trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
  tgp            tg_pair;
  tgp2           tg_pair;
  temp_pair      tg_pair;
  g              GEOMETRY;
  union_pairs    tg_pair [];
  index_of_union INTEGER;
  union_tr       trajectory;
  stepSize       INTERVAL;
BEGIN

  IF tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL
  THEN
    union_tr.tr_data = union_pairs;
    RETURN union_tr;
  END IF;

  stepSize = t_sampling_interval(tr1, tr2);
  stepSizeLong := EXTRACT(EPOCH FROM stepSize);
  RAISE NOTICE 'long step size -> %', stepSizeLong;

  startTime = LEAST(tr1.s_time, tr2.s_time);
  endTime = GREATEST(tr1.e_time, tr2.e_time);
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



  --For Jaccard calculation

  index_of_union = 0;

  FOREACH tgp IN ARRAY tr1.tr_data
  LOOP
    g = t_record_at(tr2, tgp.t);
    IF g IS NOT NULL
    THEN
      --RAISE NOTICE 'loop timestamp --> %', tgp;
      temp_pair.t := tgp.t;
      temp_pair.g := ST_Union(tgp.g, g);
      union_pairs [index_of_union] := temp_pair;
    END IF;
    IF g IS NULL
    THEN
      union_pairs [index_of_union] := tgp;
    END IF;
    index_of_union = index_of_union + 1;
  END LOOP;

  FOREACH tgp IN ARRAY tr2.tr_data
  LOOP
    g = t_record_at(tr1, tgp.t);
    IF g IS NULL
    THEN
      temp_pair.t := tgp.t;
      temp_pair.g := tgp.g;
      union_pairs [index_of_union] := temp_pair;
      index_of_union = index_of_union + 1;
    END IF;
  END LOOP;

  union_tr.id = 25;
  union_tr.tr_data = union_pairs;
  RETURN union_tr;
END
$BODY$
LANGUAGE 'plpgsql';