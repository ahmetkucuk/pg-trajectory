--head.sql
DROP FUNCTION IF EXISTS head( tg_pairs[] );

--Since array indexing mechanism in plpgsql is a mystery,
-- we shouldn't use static number to get first element
CREATE OR REPLACE FUNCTION head(tg_pairs tg_pair[])
  RETURNS tg_pair AS
$BODY$
DECLARE
  tg tg_pair;
BEGIN

  if tg_pairs ISNULL THEN
    RETURN tg;
  END IF;

  FOREACH tg IN ARRAY tg_pairs LOOP
    RETURN tg;
  END LOOP;
END
$BODY$
LANGUAGE 'plpgsql';

--pointDistance.sql
DROP FUNCTION IF EXISTS tg_point_distance( GEOMETRY, GEOMETRY );
CREATE OR REPLACE FUNCTION tg_point_distance(p1 GEOMETRY, p2 GEOMETRY)
  RETURNS FLOAT AS
$BODY$

DECLARE
  x1	            FLOAT;
  x2	            FLOAT;
  y1	            FLOAT;
  y2	            FLOAT;

BEGIN

  x1 = ST_X(p1);
  x2 = ST_X(p2);
  y1 = ST_Y(p1);
  y2 = ST_Y(p2);


  RETURN |/((x1 - x2)^2.0 + (y1 - y2)^2.0);

END

$BODY$
LANGUAGE 'plpgsql';

--polygonDistance.sql
DROP FUNCTION IF EXISTS tg_polygon_distance( GEOMETRY, GEOMETRY );
CREATE OR REPLACE FUNCTION tg_polygon_distance(g1 GEOMETRY, g2 GEOMETRY)
  RETURNS FLOAT AS
$BODY$

DECLARE

  area_of_convexhull FLOAT;
  area_of_union FLOAT;
  convex_hull geometry;

BEGIN

  g1 := st_convexhull(g1);
  g2 := st_convexhull(g2);
  area_of_union := st_area(st_union(g1, g2));

  convex_hull := st_collect(g1, convex_hull);
  convex_hull := st_collect(g2, convex_hull);
  area_of_convexhull := st_area(convex_hull);

--  RAISE NOTICE 'abc diff: %', area_of_union;

  RETURN (1 - (area_of_union/area_of_convexhull));

END

$BODY$
LANGUAGE 'plpgsql';

--editDistance.sql
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

--SELECT tg_edit_distance(t1.tr, t2.tr, '1'::NUMERIC, TRUE), (t1.tr).geom_type, (t2.tr).geom_type from trajectory_table t1, trajectory_table t2 LIMIT 1;
--select findtimelength(t1.tr) from trajectory_table t1;

--editDistance2.sql
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

--SELECT tg_edit_distance_2(t1.tr, t2.tr, '1'::NUMERIC, TRUE), (t1.tr).geom_type, (t2.tr).geom_type from trajectory_table t1, trajectory_table t2 WHERE (t1.tr).geom_type = 'Point' AND (t2.tr).geom_type = 'Point';

--select array_fill(20, ARRAY[2, 2]);
--0,2,3,
--2,0,1,
--3,1,0

-- editDistanceMatch.sql
DROP FUNCTION IF EXISTS tg_ed_match( GEOMETRY, GEOMETRY, NUMERIC );
CREATE OR REPLACE FUNCTION tg_ed_match(g1 GEOMETRY, g2 GEOMETRY, e NUMERIC)
  RETURNS BOOL AS
$BODY$

DECLARE

BEGIN
  IF ST_GeometryType(g1) = 'ST_Point' THEN
    IF tg_point_distance(g1, g2) < e THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END IF;

  IF ST_GeometryType(g1) = 'ST_Polygon' THEN
    IF tg_polygon_distance(g1, g2) < e THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END IF;

  RETURN FALSE;

END

$BODY$
LANGUAGE 'plpgsql';


