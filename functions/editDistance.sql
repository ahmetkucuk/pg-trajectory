DROP FUNCTION IF EXISTS edit_distance( trajectory, trajectory );
CREATE OR REPLACE FUNCTION edit_distance(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$
DECLARE
  intersection_area FLOAT;
  union_area        FLOAT;
  geom1 GEOMETRY;
  geom2 GEOMETRY;
  subcost DOUBLE PRECISION;
BEGIN
   IF NOT ((tr1.geom_type) = 'Point' AND (tr2.geom_type) = 'Point') THEN
    RETURN -1;
  END IF;

  IF array_length((tr1.tr_data), 1) = 0 OR array_length((tr2.tr_data), 1) = 0 THEN
    RETURN 0;
  END IF;

  geom1 = (tr1.tr_data)[0].g;
  geom2 = (tr2.tr_data)[0].g;

  subcost = st_distance(geom1, geom2);

  RAISE NOTICE 'SubCost: %', st_astext(geom2);
  RAISE NOTICE 'SubCost: %', st_astext(geom1);

  RAISE NOTICE 'SubCost: %', subcost;

  RETURN LEAST(LEAST(edit_distance(drop_head(tr1),drop_head(tr2)) + subcost, edit_distance(drop_head(tr1),tr2) + 1), edit_distance(tr1,drop_head(tr2)) + 1);

END
$BODY$
LANGUAGE 'plpgsql';

SELECT edit_distance(t1.tr, t2.tr), (t1.tr).geom_type, (t2.tr).geom_type from trajectory_table t1, trajectory_table t2;