DROP FUNCTION IF EXISTS edit_distance( trajectory, trajectory, NUMERIC, BOOL );
CREATE OR REPLACE FUNCTION edit_distance(tr1 trajectory, tr2 trajectory, e NUMERIC, zNormilized BOOL)
  RETURNS FLOAT AS
$BODY$
DECLARE
BEGIN

   IF NOT ((tr1.geom_type) = 'Point' AND (tr2.geom_type) = 'Point') THEN
    RETURN -1;
  END IF;

  if zNormilized THEN
    --Add z Normilized version here
    RETURN edit_distance_helper(tr1, tr2, e);
  END IF;
    RETURN edit_distance_helper(tr1, tr2, e);
END
$BODY$
LANGUAGE 'plpgsql';


DROP FUNCTION IF EXISTS edit_distance_helper( trajectory, trajectory, NUMERIC );
CREATE OR REPLACE FUNCTION edit_distance_helper(tr1 trajectory, tr2 trajectory, e NUMERIC)
  RETURNS FLOAT AS
$BODY$
DECLARE
  geom1 GEOMETRY;
  geom2 GEOMETRY;
  distance DOUBLE PRECISION;
  subcost INT;
  tgp1 tg_pair;
BEGIN
  IF coalesce(array_length((tr1.tr_data), 1), 0) = 0 OR coalesce(array_length((tr2.tr_data), 1), 0) = 0 THEN
    RETURN 0;
  END IF;

  geom1 = (head(tr1.tr_data)).g;
  geom2 = (head(tr2.tr_data)).g;

  distance = st_distance(geom1, geom2);

  subcost = 0;
  if distance > e THEN
    subcost = 1;
  END IF;

  RAISE NOTICE '2: %', st_astext(geom1);

  RETURN LEAST(LEAST(edit_distance_helper(drop_head(tr1),drop_head(tr2), e) + subcost, edit_distance_helper(drop_head(tr1),tr2, e) + 1), edit_distance_helper(tr1,drop_head(tr2), e) + 1);

END
$BODY$
LANGUAGE 'plpgsql';

SELECT edit_distance(t1.tr, t2.tr, '1'::NUMERIC, TRUE), (t1.tr).geom_type, (t2.tr).geom_type from trajectory_table t1, trajectory_table t2;