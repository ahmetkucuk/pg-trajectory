DROP FUNCTION IF EXISTS t_edit_distance( trajectory, trajectory, NUMERIC );
CREATE OR REPLACE FUNCTION t_edit_distance(tr1 trajectory, tr2 trajectory, e NUMERIC)
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

  m := t_length(tr1);
  n := t_length(tr2);

  --RAISE NOTICE 'i: %', m;

  D := array_fill(0, ARRAY[m, n]);

  FOR i IN 2..m LOOP
    D[i][1] := n;
  END LOOP;

  FOR j IN 2..n LOOP
    D[1][j] := m;
  END LOOP;

  FOR i IN 2..m LOOP
    FOR j IN 2..n LOOP

      geom1 = (tr1.tr_data)[i].g;
      geom2 = (tr2.tr_data)[j].g;


      subcost = 1;
      if edit_match(geom1, geom2, e) THEN
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
