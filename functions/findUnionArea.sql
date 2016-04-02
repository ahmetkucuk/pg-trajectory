DROP FUNCTION IF EXISTS t_union_area( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_union_area(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$
DECLARE
  tgp            tg_pair;
  tgp2           tg_pair;
  g   GEOMETRY;
  area  FLOAT := 0;
BEGIN

  IF tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL
  THEN
    RETURN 0;
  END IF;

  --For Jaccard calculation

  FOREACH tgp IN ARRAY tr1.tr_data
  LOOP
    g := t_record_at(tr2, tgp.t);
    IF g IS NOT NULL
    THEN
      area := area + st_area(ST_Union(tgp.g, g));
    END IF;
    IF g IS NULL
    THEN
      area := area + st_area(tgp.g);
    END IF;
  END LOOP;

  FOREACH tgp IN ARRAY tr2.tr_data
  LOOP
    g := t_record_at(tr1, tgp.t);
    IF g IS NULL
    THEN

      RAISE NOTICE 'loop timestamp --> %', area;
      area := area + st_area(tgp.g);
    END IF;
  END LOOP;
  RETURN area;
END
$BODY$
LANGUAGE 'plpgsql';