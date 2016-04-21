DROP FUNCTION IF EXISTS t_ts_union( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_ts_union(tr1 trajectory, tr2 trajectory)
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
  IF tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL
  THEN
    RETURN union_tr;
  END IF;

  IF tr1.e_time < tr2.s_time OR tr1.s_time > tr2.e_time
  THEN
    RETURN union_tr;
  END IF;

  IF NOT st_intersects(tr1.bbox, tr2.bbox)
  THEN
    RETURN union_tr;
  END IF;

  --For Jaccard calculation


  FOREACH tgp IN ARRAY tr1.tr_data
  LOOP
    IF tgp.t > tr2.e_time THEN
      EXIT;
    END IF;

    IF tgp.t < tr2.s_time THEN
      CONTINUE;
    END IF;

    g = t_record_at(tr2, tgp.t);
    IF g IS NOT NULL
    THEN
      IF ST_intersects(tgp.g, g)
      THEN
        temp_pair.t = tgp.t;
        temp_pair.g = ST_Union(tgp.g, g);
        union_pairs := union_pairs || temp_pair;
      END IF;
    END IF;
  END LOOP;

  union_tr = _trajectory(union_pairs);
  RETURN union_tr;

END
$BODY$
LANGUAGE 'plpgsql';