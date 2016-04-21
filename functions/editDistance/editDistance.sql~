DROP FUNCTION IF EXISTS tg_edit_distance( trajectory, trajectory, NUMERIC, BOOL );
CREATE OR REPLACE FUNCTION tg_edit_distance(tr1 trajectory, tr2 trajectory, e NUMERIC, zNormilized BOOL)
  RETURNS FLOAT AS
$BODY$
DECLARE
BEGIN

  IF tr1.geom_type != tr2.geom_type THEN
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
  distance FLOAT;
  subcost INT;
  tgp1 tg_pair;
  m INT;
  n INT;
BEGIN
  m := findTimeLength(tr1);
  n := findTimeLength(tr2);
  IF m = 0 THEN
    RETURN n;
  END IF;

  IF n = 0 THEN
    RETURN m;
  END IF;

  geom1 = (head(tr1.tr_data)).g;
  geom2 = (head(tr2.tr_data)).g;
  --RAISE NOTICE 'distance %', distance;

  subcost = 1;
  if tg_ed_match(geom1, geom2, e) THEN
    subcost = 0;
  END IF;

  RETURN LEAST(LEAST(edit_distance_helper(drop_head(tr1),drop_head(tr2), e) + subcost, edit_distance_helper(drop_head(tr1),tr2, e) + 1), edit_distance_helper(tr1,drop_head(tr2), e) + 1);

END
$BODY$
LANGUAGE 'plpgsql';

SELECT tg_edit_distance(t1.tr, t2.tr, '1'::NUMERIC, TRUE), (t1.tr).geom_type, (t2.tr).geom_type from trajectory_table t1, trajectory_table t2 LIMIT 1;
select findtimelength(t1.tr) from trajectory_table t1;