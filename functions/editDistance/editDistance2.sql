DROP FUNCTION IF EXISTS tg_edit_distance_2( trajectory, trajectory, NUMERIC, BOOL );
CREATE OR REPLACE FUNCTION tg_edit_distance_2(tr1 trajectory, tr2 trajectory, e NUMERIC, zNormilized BOOL)
  RETURNS FLOAT AS
$BODY$
DECLARE
  D int[][];
  v int;
  m INT;
  n INT;

  geom1 GEOMETRY;
  geom2 GEOMETRY;
  subcost INT;
  te TEXT;
BEGIN

  IF tr1.geom_type != tr2.geom_type THEN
    RETURN -1;
  END IF;

  if zNormilized THEN
    --Add z Normilized version here
  END IF;

  m := findTimeLength(tr1);
  n := findTimeLength(tr2);

  D := array_fill(0, ARRAY[m, n]);

  FOR i IN 2..m LOOP
    D[i][1] := i;
  END LOOP;

  FOR j IN 2..n LOOP
    D[1][j] := j;
  END LOOP;

  FOR i IN 2..m LOOP
    FOR j IN 2..n LOOP

      geom1 = (tr1.tr_data)[i].g;
      geom2 = (tr2.tr_data)[j].g;


      subcost = 1;
      if tg_ed_match(geom1, geom2, e) THEN
        subcost = 0;
      END IF;

      D[i][j] := LEAST(LEAST(D[i-1][j-1] + subcost, D[i-1][j] + 1), D[i][j-1] + 1);

      --RAISE NOTICE 'i: %, j: %, D %', i, j,  D[i][j];

    END LOOP;
  END LOOP;


  --FOR i IN 1..m LOOP
    --te := '';
    --FOR j IN 1..n LOOP
    --  te := te || ' ' || d[i][j];
    --END LOOP;
    --RAISE NOTICE '%', te;
  --END LOOP;

  RETURN D[m][n];

END
$BODY$
LANGUAGE 'plpgsql';

--SELECT tg_edit_distance_2(t1.tr, t2.tr, '1'::NUMERIC, TRUE), (t1.tr).geom_type, (t2.tr).geom_type from trajectory_table t1, trajectory_table t2 WHERE (t1.tr).geom_type = 'Polygon' AND (t2.tr).geom_type = 'Polygon' LIMIT 1;

SELECT tg_edit_distance_2(t1.tr, t2.tr, '1'::NUMERIC, TRUE), (t1.tr).geom_type, (t2.tr).geom_type from trajectory_table t1, trajectory_table t2 WHERE (t1.tr).geom_type = 'Point' AND (t2.tr).geom_type = 'Point';

--select array_fill(20, ARRAY[2, 2]);
--0,2,3,
--2,0,1,
--3,1,0