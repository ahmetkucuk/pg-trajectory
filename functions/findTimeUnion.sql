DROP FUNCTION IF EXISTS t_time_union(trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_time_union(tr1 trajectory, tr2 trajectory) RETURNS trajectory AS
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


    --For Jaccard calculation

    index_of_union = 0;
    if tr1.tr_data ISNULL OR tr2.tr_data ISNULL THEN

      union_tr.id = 25;
      union_tr.tr_data = union_pairs;
      RETURN union_tr;

    END IF;

    FOREACH tgp IN ARRAY tr1.tr_data
    LOOP
      g = t_record_at(tr2, tgp.t);
      if g IS NOT NULL THEN
            temp_pair.t := tgp.t;
            temp_pair.g := ST_Union(tgp.g, g);
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