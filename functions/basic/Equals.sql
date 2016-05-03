DROP FUNCTION IF EXISTS t_equals( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_equals(tr1 trajectory, tr2 trajectory)
  RETURNS BOOL AS
$BODY$
DECLARE
  tgp            tg_pair;
  g              GEOMETRY;
BEGIN
  IF tr1 ISNULL AND tr2 ISNULL
  THEN
    RETURN TRUE;
  END IF;

  IF tr1.tr_data ISNULL AND tr2.tr_data ISNULL
  THEN
    RETURN TRUE;
  END IF;

  IF tr1.tr_data ISNULL
  THEN
    RETURN FALSE;
  END IF;

  IF tr2.tr_data ISNULL
  THEN
    RETURN FALSE;
  END IF;

  IF t_length(tr1) <> t_length(tr2) THEN
    RETURN FALSE;
  END IF;

  --For Jaccard calculation
  FOREACH tgp IN ARRAY tr1.tr_data
  LOOP
    g = t_record_at(tr2, tgp.t);

    IF g ISNULL AND tgp IS NOT NULL THEN
      RETURN FALSE;
    END IF;
    IF g IS NOT NULL AND tgp ISNULL THEN
      RETURN FALSE;
    END IF;

    IF NOT st_equals(tgp.g, g) THEN
      --RAISE NOTICE '1: %, 2: %', st_astext(g), st_astext(tgp.g);
      RETURN FALSE;
    END IF;
  END LOOP;
  RETURN TRUE;
END
$BODY$
LANGUAGE 'plpgsql';