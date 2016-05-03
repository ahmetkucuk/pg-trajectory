DROP FUNCTION IF EXISTS t_union( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_union(tr1 trajectory, tr2 trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
  tgp            tg_pair;
  tgp2           tg_pair;
  temp_pair      tg_pair;
  g              GEOMETRY;
  union_pairs    tg_pair [] = '{}';
  union_tr       trajectory;
BEGIN

  union_tr.tr_data = union_pairs;
  IF tr1 ISNULL OR tr2 ISNULL OR (tr1.tr_data ISNULL AND tr2.tr_data ISNULL)
  THEN
    RETURN union_tr;
  END IF;

  IF tr1.tr_data ISNULL
  THEN
    union_tr.tr_data = tr2.tr_data;
    RETURN _trajectory(union_pairs);
  END IF;

  IF tr2.tr_data ISNULL
  THEN
    union_tr.tr_data = tr1.tr_data;
    RETURN _trajectory(union_pairs);
  END IF;

  --For Jaccard calculation

  FOREACH tgp IN ARRAY tr1.tr_data
  LOOP
    g = t_record_at(tr2, tgp.t);
    IF g IS NOT NULL
    THEN
      --RAISE NOTICE 'loop timestamp --> %', tgp;
      temp_pair.t = tgp.t;
      temp_pair.g = ST_Union(tgp.g, g);
    END IF;
    IF g IS NULL
    THEN
      union_pairs := union_pairs || tgp;
    END IF;
  END LOOP;

  FOREACH tgp IN ARRAY tr2.tr_data
  LOOP
    g = t_record_at(tr1, tgp.t);
    IF g IS NULL
    THEN
      temp_pair.t = tgp.t;
      temp_pair.g = tgp.g;
      union_pairs := union_pairs || temp_pair;
    END IF;
  END LOOP;
  union_tr = _trajectory(union_pairs);
  RETURN union_tr;
END
$BODY$
LANGUAGE 'plpgsql';