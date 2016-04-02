DROP FUNCTION IF EXISTS t_ts_union_area( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_ts_union_area(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$
DECLARE
  tgp1            tg_pair;
  tgp2            tg_pair;
  union_pairs    tg_pair [];
  area FLOAT := 0;
BEGIN

  IF tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL
  THEN
    RETURN area;
  END IF;

  IF tr1.e_time < tr2.s_time OR tr1.s_time > tr2.e_time
  THEN
    RETURN area;
  END IF;

  IF NOT st_intersects(tr1.bbox, tr2.bbox)
  THEN
    RETURN area;
  END IF;

  --For Jaccard calculation

  FOREACH tgp1 IN ARRAY tr1.tr_data
  LOOP
    FOREACH tgp2 IN ARRAY tr2.tr_data LOOP
      IF tgp1.t = tgp2.t AND ST_intersects(tgp1.g, tgp2.g)
      THEN
          area :=  area + st_area(ST_Union(tgp1.g, tgp2.g));
      END IF;
    END LOOP;
  END LOOP;

  RETURN area;

END
$BODY$
LANGUAGE 'plpgsql';