DROP FUNCTION IF EXISTS t_union(trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_union(tr1 trajectory, tr2 trajectory) RETURNS trajectory AS
$BODY$
DECLARE
    tgp tg_pair;
    tgp2 tg_pair;
    temp_pair tg_pair;
    g GEOMETRY;
    union_pairs tg_pair[];
    index_of_union integer;
    union_tr trajectory;
BEGIN


    if tr1.tr_data ISNULL OR tr2.tr_data ISNULL THEN

      union_tr.id = 25;
      union_tr.tr_data = union_pairs;
      RETURN union_tr;
    END IF;

    if tr2.tr_data IS NULL  THEN

      union_tr.id = 25;
      union_tr.tr_data = union_pairs;
      RETURN union_tr;
    END IF;

    --For Jaccard calculation

    index_of_union = 0;

    FOREACH tgp IN ARRAY tr1.tr_data
    LOOP
      g = t_record_at(tr2, tgp.t);
      if g IS NOT NULL THEN
      --RAISE NOTICE 'loop timestamp --> %', tgp;
            temp_pair.t := tgp.t;
            temp_pair.g := ST_Union(tgp.g, g);
            union_pairs[index_of_union] := temp_pair;
      END IF;
      if g IS NULL THEN
            union_pairs[index_of_union] := tgp;
      END IF;
      index_of_union = index_of_union + 1;
    END LOOP;

    FOREACH tgp IN ARRAY tr2.tr_data
    LOOP
      g = t_record_at(tr1, tgp.t);
      if g IS NULL THEN
            temp_pair.t := tgp.t;
            temp_pair.g := tgp.g;
            union_pairs[index_of_union] := temp_pair;
            index_of_union = index_of_union + 1;
      END IF;
    END LOOP;

    union_tr.id = 25;
    union_tr.tr_data = union_pairs;
    RETURN union_tr;
END
$BODY$
LANGUAGE 'plpgsql' ;