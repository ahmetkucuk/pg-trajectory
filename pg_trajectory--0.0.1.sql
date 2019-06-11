DROP TYPE IF EXISTS tg_pair CASCADE;
CREATE TYPE tg_pair AS ( -- timestamp-geometry pair type
    t timestamp,
    g geometry
);


DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS (
    s_time TIMESTAMP,
    e_time TIMESTAMP,
    geom_type TEXT, 
    bbox GEOMETRY,
    --sampling_interval INTERVAL,
    tr_data tg_pair[]);

DROP FUNCTION IF EXISTS _trajectory(tg_pair[]) CASCADE;
CREATE OR REPLACE FUNCTION _trajectory(tg_pair[]) RETURNS trajectory AS
$BODY$
DECLARE
  t trajectory;
BEGIN
    /*t.geom_type = t_type($1);
    IF t.geom_type = 'Invalid' THEN
      RAISE EXCEPTION 'Mixed geometry type is not allowed';
      --RETURN t;
    END IF;*/
    t.bbox = tg_mbr($1);
    t.e_time = tg_end_time($1);
    t.s_time = tg_start_time($1);
    t.tr_data = array_sort($1);
    /*IF array_length($1, 1) > 1 THEN
        t.sampling_interval = (t.e_time - t.s_time) / (array_length($1, 1) - 1);
    ELSE
        t.sampling_interval = INTERVAL '-1 seconds';
    END IF;*/
    RETURN t;
END
$BODY$
LANGUAGE 'plpgsql';


DROP FUNCTION IF EXISTS _trajectory_2(tg_pair[]) CASCADE;
CREATE OR REPLACE FUNCTION _trajectory_2(tg_pair[]) RETURNS VOID AS
$BODY$
DECLARE
    geom_type TEXT;
    s_time TIMESTAMP;
    e_time TIMESTAMP;
    tr_data tg_pair[];
    sampling_interval INTERVAL;
    bbox GEOMETRY;
BEGIN

    /*geom_type = t_type($1);
    IF geom_type = 'Invalid'THEN
      RAISE EXCEPTION 'Mixed geometry type is not allowed';
      --RETURN t;
    END IF;*/
    bbox = tg_mbr($1);
    e_time = tg_end_time($1);
    s_time = tg_start_time($1);
    tr_data = array_sort($1);
    --sampling_interval = INTERVAL '-1 seconds'; --get_sampling_interval(t);
    --RAISE NOTICE '%', tableName;
    sampling_interval = (e_time - s_time) / (array_length($1, 1) - 1); --INTERVAL '-1 seconds'; --get_sampling_interval(t);
    INSERT INTO trajectory_table (s_time,e_time,geom_type,bbox,sampling_interval,tr_data) VALUES (s_time, e_time, geom_type, bbox, sampling_interval, tr_data);
END
$BODY$
LANGUAGE 'plpgsql';

DROP FUNCTION IF EXISTS t_add_head( tg_pair, trajectory );
CREATE OR REPLACE FUNCTION t_add_head(tgp tg_pair, tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
 j INTEGER;
 len INTEGER;
 new_tr_data tg_pair[] := '{}';

BEGIN
 new_tr_data[1] = tgp;
 len = ARRAY_LENGTH(tr.tr_data, 1);

 --don't add at head if time of tg pair is after the first tg pair of trajectory
 IF tgp.t > tr.tr_data[1].t THEN
    RAISE EXCEPTION 'New tg pair must precede the first tg pair';
 END IF;

 --check whether same geometry
 IF tr.geom_type <> getTrajectoryType(new_tr_data) THEN
   RAISE EXCEPTION 'Different type of geometry can not be added at head'; 
 END IF;
 
 --If sampling interval of input trajectory = -1, that means that trajectory has only 1 tg pair. We can add our new tg pair in the head.
 --Sampling interval of the input trajectory must be equal to the timestamp differene of new tg pair and 1st tg pair of tr_data
 IF tr.sampling_interval <> INTERVAL '-1 seconds' AND tr.sampling_interval <> (tr.tr_data[1].t - new_tr_data[1].t) THEN
   RAISE EXCEPTION 'Sampling interval of the input trajectory must be equal to the timestamp differene of new tg pair and 
                    1st tg pair of the input trajectory';
 END IF;
 
 FOR j in 2..len+1 LOOP
   new_tr_data[j] = tr.tr_data[j-1];
 END LOOP;

 RETURN _trajectory(new_tr_data);
 
END
$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS t_drop_tail( trajectory );
CREATE OR REPLACE FUNCTION t_drop_tail(tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
 j INT;
 len INT;
 new_tr_data tg_pair[] := '{}';

BEGIN
 len = ARRAY_LENGTH(tr.tr_data, 1);
 IF len <= 1 THEN
   RETURN _trajectory(new_tr_data);
 END IF;

 FOR j IN 1..len-1 LOOP
  new_tr_data[j] = tr.tr_data[j];
 END LOOP;

 RETURN _trajectory(new_tr_data);
END
$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS t_add_tail( tg_pair, trajectory );
CREATE OR REPLACE FUNCTION t_add_tail(tgp tg_pair, tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
 j INTEGER;
 len INTEGER;
 temp_tr_data tg_pair[] := '{}';

BEGIN

 len = ARRAY_LENGTH(tr.tr_data, 1);

 --check if new tg pair appears before the last tg pair
 IF tgp.t < tr.tr_data[len].t THEN
    RAISE EXCEPTION 'New tg pair must follow the last tg pair';
 END IF;

 temp_tr_data[1] = tgp;
 --check whether same geometry
 IF tr.geom_type <> getTrajectoryType(temp_tr_data) THEN
   RAISE EXCEPTION 'Different type of geometry can not be added at head'; 
 END IF;
 
 --If sampling interval of input trajectory = -1, that means that trajectory has only 1 tg pair. We can add our new tg pair in the head.
 --Sampling interval of the input trajectory must be equal to the timestamp differene of new tg pair and 1st tg pair of tr_data
 IF tr.sampling_interval <> INTERVAL '-1 seconds' AND tr.sampling_interval <> (tgp.t - tr.tr_data[len].t) THEN
   RAISE EXCEPTION 'Sampling interval of the input trajectory must be equal 
                    to the timestamp difference of last tg pair of the input trajectory  and the new tg pair';
 END IF;

 tr.tr_data[len+1] = tgp;

 RETURN _trajectory(tr.tr_data);
 
END
$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS t_drop_head( trajectory );
CREATE OR REPLACE FUNCTION t_drop_head(tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
  new_tr_data tg_pair[] := '{}';
  newIndex int;
  tg tg_pair;
  isFirst BOOL;
BEGIN

  newIndex = 1;
  if coalesce(array_length((tr.tr_data), 1), 0) <= 1 THEN
    RETURN _trajectory(new_tr_data);
  END IF;

  isFirst = true;

  FOREACH tg IN ARRAY tr.tr_data LOOP
    IF NOT isFirst THEN
      --new_tr_data := array_append(new_tr_data, tg);
      new_tr_data[newIndex] = tg;
      newIndex = newIndex + 1;
    END IF;
    isFirst = false;
END LOOP;

  RETURN _trajectory(new_tr_data);
END
$BODY$
LANGUAGE 'plpgsql';DROP FUNCTION IF EXISTS t_update_geom_at( timestamp WITH TIME ZONE, GEOMETRY, trajectory );
CREATE OR REPLACE FUNCTION t_update_geom_at(ti timestamp WITH TIME ZONE, ge GEOMETRY, tr trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
 j INTEGER;
 flag BOOLEAN;
 len INTEGER;
 temp_tgp tg_pair;
 temp_tr_data tg_pair[] := '{}';

BEGIN
 --temp_tr_data[1].t = ti;
 --temp_tr_data[1].g =ge;
 temp_tgp.t = ti;
 temp_tgp.g = ge;
 temp_tr_data[1] = temp_tgp;
 --check whether same geometry
 IF tr.geom_type <> getTrajectoryType(temp_tr_data) THEN
   RAISE EXCEPTION 'Different type of geometry is not allowed'; 
 END IF;
 
 len = ARRAY_LENGTH(tr.tr_data, 1);
 flag = FALSE;
 FOR j IN 1..len LOOP
  IF tr.tr_data[j].t = ti THEN
    tr.tr_data[j] = temp_tgp;
    flag = TRUE;
    EXIT;
  END IF;
 END LOOP;

 IF flag = FALSE THEN
   RAISE EXCEPTION 'Valid Timestamp must be given for modifying trajectory';
 END IF;

 RETURN _trajectory(tr.tr_data);
 
END
$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS tg_edit_distance_recursive( trajectory, trajectory, NUMERIC, BOOL );
CREATE OR REPLACE FUNCTION tg_edit_distance_recursive(tr1 trajectory, tr2 trajectory, e NUMERIC, zNormilized BOOL)
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
DROP FUNCTION IF EXISTS edit_polygon_distance( GEOMETRY, GEOMETRY );
CREATE OR REPLACE FUNCTION edit_polygon_distance(g1 GEOMETRY, g2 GEOMETRY)
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
  area_of_convexhull := st_area(st_convexhull(convex_hull));

  --RAISE NOTICE 'union: % convex: %', area_of_union, area_of_convexhull;

  RETURN (1 - (area_of_union/area_of_convexhull));

END

$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS edit_match( GEOMETRY, GEOMETRY, NUMERIC );
CREATE OR REPLACE FUNCTION edit_match(g1 GEOMETRY, g2 GEOMETRY, e NUMERIC)
  RETURNS BOOL AS
$BODY$

DECLARE

BEGIN
  IF ST_GeometryType(g1) = 'ST_Point' THEN
    IF edit_point_distance(g1, g2) < e THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
    ELSE
    IF edit_polygon_distance(g1, g2) < e THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END IF;
  RETURN FALSE;

END

$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS edit_point_distance( GEOMETRY, GEOMETRY );
CREATE OR REPLACE FUNCTION edit_point_distance(p1 GEOMETRY, p2 GEOMETRY)
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
DROP FUNCTION IF EXISTS zNormalize(tg_pair[], INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION zNormalize(tr_data tg_pair[], beginIndex INTEGER, endIndex INTEGER) RETURNS Geometry[] AS
$BODY$
DECLARE
 j INTEGER;
 count_of_geoms INTEGER;
 sum_of_vals_x FLOAT;
 sum_of_vals_y FLOAT;
 x_vals FLOAT[];
 y_vals FLOAT[];
 mean_x FLOAT;
 mean_y FLOAT;
 variance_x FLOAT;
 variance_y FLOAT;
 sd_x FLOAT;
 sd_y FLOAT;
 z_x FLOAT;
 z_y FLOAT;
 temp_tr_geom Geometry;
 new_point Geometry;
 z_normalized_geom_array Geometry[];  

BEGIN
   --read values
   count_of_geoms = 0;
   FOR j IN beginIndex..endIndex LOOP
      count_of_geoms = count_of_geoms + 1; 
      temp_tr_geom = tr_data[j].g;
      x_vals[count_of_geoms] = ST_X(temp_tr_geom);
      y_vals[count_of_geoms] = ST_Y(temp_tr_geom);
      --RAISE NOTICE 'x % -->',count_of_geoms;
      --RAISE NOTICE '%', x_vals[count_of_geoms];
      --RAISE NOTICE 'y % -->',count_of_geoms;
      --RAISE NOTICE '%', y_vals[count_of_geoms];
   END LOOP;
   --get mean_x and mean_y
   sum_of_vals_x = 0;
   sum_of_vals_y = 0;
   FOR j IN 1..count_of_geoms LOOP
      sum_of_vals_x = sum_of_vals_x + x_vals[j];
      sum_of_vals_y = sum_of_vals_y + y_vals[j];
   END LOOP;
   mean_x = sum_of_vals_x/count_of_geoms;
   mean_y = sum_of_vals_y/count_of_geoms;
   --RAISE NOTICE 'mean_x: %', mean_x;
   --RAISE NOTICE 'mean_y: %', mean_y;
   --get sd_x and sd_y
   sum_of_vals_x = 0;
   sum_of_vals_y = 0;
   FOR j IN 1..count_of_geoms LOOP
      sum_of_vals_x = sum_of_vals_x + (x_vals[j] - mean_x)^2.0;
      sum_of_vals_y = sum_of_vals_y + (y_vals[j] - mean_y)^2.0;
   END LOOP;
   variance_x = sum_of_vals_x/count_of_geoms;
   variance_y = sum_of_vals_y/count_of_geoms;
   sd_x = |/variance_x;
   sd_y = |/variance_y;
   --RAISE NOTICE 'sd_x: %', sd_x;
   --RAISE NOTICE 'sd_y: %', sd_y;
   --z normalize
   FOR j IN 1..count_of_geoms LOOP
      z_x = (x_vals[j] - mean_x)/sd_x;
      z_y = (y_vals[j] - mean_y)/sd_y;
      new_point = ST_MakePoint(z_x::double precision, z_y::double precision);
      z_normalized_geom_array[j] = new_point;
      --RAISE NOTICE ' zx --> %', ST_X(z_nomalized_geom_array[j]);
      --RAISE NOTICE ' zy --> %', ST_Y(z_nomalized_geom_array[j]);
   END LOOP; 
   -- intensional mistake
   --RAISE NOTICE '%',ST_AsText(z_normalized_geom_array[j]);
   RETURN z_normalized_geom_array;
      
END
$BODY$
LANGUAGE 'plpgsql' ;
DROP FUNCTION IF EXISTS t_euclidean_distance(trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_euclidean_distance(tr1 trajectory, tr2 trajectory) RETURNS FLOAT AS
$BODY$
DECLARE
len1 INTEGER;
len2 INTEGER;
z1 Geometry[];
z2 Geometry[];
j INTEGER;
k INTEGER;
sum_distance FLOAT;
point_1 Geometry;
point_2 Geometry;
point_1_x FLOAT;
point_1_y FLOAT;
point_2_x FLOAT;
point_2_y FLOAT;
sliding_boundary INTEGER;
Euclidean_distance FLOAT;
zQ Geometry[];
zS Geometry[];
min_ED FLOAT;
temp_tgp tg_pair;

BEGIN
 IF tr1.geom_type = 'Point' AND tr2.geom_type = 'Point' THEN
  len1 = findTimeLength(tr1);
  len2 = findTimeLength(tr2);
  IF len1 = len2 THEN
  --no sliding required; both trajectory need to be z normalized in full length
  z1 = zNormalize(tr1.tr_data, 1, len1);
  z2 = zNormalize(tr2.tr_data, 1, len2); 
  sum_distance = 0;
  FOR j IN 1..len1 LOOP
   --read both points from z1 and z2
   point_1 = z1[j];
   point_1_x = ST_X(point_1);
   point_1_y = ST_Y(point_1);
   point_2 = z2[j];
   point_2_x = ST_X(point_2);
   point_2_y = ST_Y(point_2);
   sum_distance = sum_distance + (point_1_x - point_2_x)^2.0 + (point_1_y - point_2_y)^2.0;
  END LOOP;
  Euclidean_distance = |/sum_distance;
  RETURN Euclidean_distance;

  ELSIF len1 < len2 THEN
   --tr1 is the query and tr2 is the series. We have to slide tr1 along tr2. Get EDs at each setting. Finally get the minimum ED.
   zQ = zNormalize(tr1.tr_data, 1, len1);
   min_ED = 1000000; -- infinity
   sliding_boundary = len2 - len1 + 1;
   FOR j IN 1..sliding_boundary LOOP
    zS = zNormalize(tr2.tr_data, j, j+len1-1);
    sum_distance = 0;
    FOR k IN 1..len1 LOOP
     point_1 = zQ[k];
     point_1_x = ST_X(point_1);
     point_1_y = ST_Y(point_1);
     point_2 = zS[k];
     point_2_x = ST_X(point_2);
     point_2_y = ST_Y(point_2);
     sum_distance = sum_distance + (point_1_x - point_2_x)^2.0 + (point_1_y - point_2_y)^2.0;
    END LOOP;
    Euclidean_distance = |/sum_distance;
    --RAISE NOTICE 'current --> %', Euclidean_distance;
    --PERFORM pg_sleep(5);
    IF Euclidean_distance < min_ED THEN
       min_ED = Euclidean_distance;
    END IF;
   END LOOP;
   RETURN min_ED;

  ELSIF len2 < len1 THEN
  --tr2 is the query and tr1 is the series. We have to slide tr2 along tr1. Get EDs at each setting. Finally get the minimum ED.
   zQ = zNormalize(tr2.tr_data, 1, len2);
   min_ED = 1000000; -- infinity
   sliding_boundary = len1 - len2 + 1;
   FOR j IN 1..sliding_boundary LOOP
    zS = zNormalize(tr1.tr_data, j, j+len2-1);
    sum_distance = 0;
    FOR k IN 1..len2 LOOP
     point_1 = zQ[k];
     point_1_x = ST_X(point_1);
     point_1_y = ST_Y(point_1);
     point_2 = zS[k];
     point_2_x = ST_X(point_2);
     point_2_y = ST_Y(point_2);
     sum_distance = sum_distance + (point_1_x - point_2_x)^2.0 + (point_1_y - point_2_y)^2.0;
    END LOOP;
    Euclidean_distance = |/sum_distance;
    --RAISE NOTICE 'current --> %', Euclidean_distance;
    --PERFORM pg_sleep(5);
    IF Euclidean_distance < min_ED THEN
       min_ED = Euclidean_distance;
    END IF;
   END LOOP;
   RETURN min_ED;

  END IF; --len compare
 ELSIF tr1.geom_type = 'Polygon' AND tr2.geom_type = 'Polygon' THEN
  --Transforming both region trajectories into point trajectories by taking centroid of each polygon
  len1 = ARRAY_LENGTH(tr1.tr_data, 1);
  FOR j IN 1..len1 LOOP
   temp_tgp.t = tr1.tr_data[j].t;
   temp_tgp.g = ST_Centroid(tr1.tr_data[j].g);
   tr1.tr_data[j] = temp_tgp;
  END LOOP;
  tr1 = _trajectory(tr1.tr_data);

  len2 = ARRAY_LENGTH(tr2.tr_data, 1);
  FOR j IN 1..len2 LOOP
   temp_tgp.t = tr2.tr_data[j].t;
   temp_tgp.g = ST_Centroid(tr2.tr_data[j].g);
   tr2.tr_data[j] = temp_tgp;
  END LOOP;
  tr2 = _trajectory(tr2.tr_data);

  RETURN EuclideanDistance(tr1, tr2);

 ELSE 
  RAISE EXCEPTION 'Both trajectories must be of same type';
 END IF;
END
$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS t_record_at_interpolated( trajectory, TIMESTAMP);
CREATE OR REPLACE FUNCTION t_record_at_interpolated(tr trajectory, t TIMESTAMP)
  RETURNS GEOMETRY AS
$BODY$

DECLARE
  tgp tg_pair;
  geom1 GEOMETRY;
  geom2 GEOMETRY;

BEGIN

  if tr.s_time < t AND tr.e_time > t THEN
    RETURN -1;
  END IF;

  FOREACH tgp IN ARRAY tr.tr_data
  LOOP
    IF tgp.t < t THEN
      geom2 := tgp.t;
      RETURN st_interpolatepoint(st_makeline(geom1, geom2), 0.5);
    END IF;
      geom1 := tgp.g;
  END LOOP;

  RETURN NULL;

END

$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS t_m_distance( trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_m_distance(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT[] AS
$BODY$
DECLARE
  result FLOAT[] = '{}';
  g GEOMETRY;
  tgp tg_pair;
BEGIN

  IF tr1.geom_type != st_geometrytype(st_makepoint(0,0)) OR tr2.geom_type != st_geometrytype(st_makepoint(0,0)) THEN
    RETURN result;
  END IF;

  FOREACH tgp IN ARRAY tr1.tr_data
  LOOP

    g := t_record_at(tr1, tgp.t);

    IF g IS NULL
    THEN
      result := result || tg_point_distance(tgp.g, g);
    END IF;
  END LOOP;
  RETURN result;

END
$BODY$
LANGUAGE 'plpgsql';DROP FUNCTION IF EXISTS t_distance( trajectory );
CREATE OR REPLACE FUNCTION t_distance(tr trajectory)
  RETURNS FLOAT AS
$BODY$

DECLARE
  length 	    FLOAT;
  tgp tg_pair;
  prev  tg_pair;

BEGIN

  if tr ISNULL OR tr.geom_type != st_geometrytype(st_makepoint(0,0)) OR tr.tr_data ISNULL THEN
    RETURN -1;
  END IF;

  length = 0;

  prev := head(tr.tr_data);
  FOREACH tgp IN ARRAY tr.tr_data
  LOOP
      length =  length + tg_point_distance(prev, tgp);
  END LOOP;

  RETURN length;

END

$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS t_sampling_interval( trajectory );
CREATE OR REPLACE FUNCTION t_sampling_interval(tr trajectory)
  RETURNS INTERVAL AS
$BODY$
DECLARE
 stepSize INTERVAL;

BEGIN
 IF array_length(tr.tr_data, 1) > 1 THEN
    stepSize = (tr.e_time - tr.s_time) / (array_length(tr.tr_data, 1) - 1);
 ELSE
    stepSize = INTERVAL '-1 seconds';
 END IF;

 RETURN stepSize;
END
$BODY$
LANGUAGE 'plpgsql';
DROP FUNCTION IF EXISTS tg_start_time(tg_pair[]);
CREATE OR REPLACE FUNCTION tg_start_time(tr_data tg_pair[]) RETURNS TIMESTAMP AS
$BODY$
DECLARE
    tgp tg_pair;
    startTime TIMESTAMP;
BEGIN

  IF tr_data ISNULL THEN
        startTime := to_timestamp(-1)::TIMESTAMP;
        RETURN startTime;
  END IF;
    --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
  startTime = tr_data[1].t;

  FOREACH tgp IN ARRAY tr_data
  LOOP
      --RAISE NOTICE 'loop timestamp --> %', tgp.t;
    IF startTime > tgp.t THEN
      startTime = tgp.t;
    END IF;
  END LOOP;
  RETURN startTime;
END
$BODY$
LANGUAGE 'plpgsql' ;DROP FUNCTION IF EXISTS tg_mbr(tg_pair[]) CASCADE;

--findMBR:: finds mbr of a particular trajectory specified by the tr_id
--@param tr_id:: an integer specifying the trajectory identifier
CREATE OR REPLACE FUNCTION tg_mbr(tr_data tg_pair[]) RETURNS GEOMETRY AS
$BODY$
DECLARE
    tgp tg_pair;
    mbr GEOMETRY;
BEGIN

    IF tr_data ISNULL THEN
        return mbr;
    END IF;
    FOREACH tgp IN ARRAY tr_data
    LOOP
        --RAISE NOTICE '%', tgp.t;
        --RAISE NOTICE '%', ST_astext(tgp.g);
        mbr := st_collect(tgp.g, mbr);
        --RAISE NOTICE 'collection==> %', ST_astext(mbr);

    END LOOP;
    mbr := st_envelope(mbr);
    --RAISE NOTICE 'mbr %', ST_astext(mbr);
    RETURN mbr;
END
$BODY$
LANGUAGE 'plpgsql' ;
DROP FUNCTION IF EXISTS tg_end_time(tg_pair[]);
CREATE OR REPLACE FUNCTION tg_end_time(tr_data tg_pair[]) RETURNS timestamp AS
$BODY$
DECLARE
    tgp tg_pair;
    endTime timestamp;
BEGIN

      IF tr_data ISNULL THEN
        endTime := to_timestamp(-1)::TIMESTAMP;
        RETURN endTime;
    END IF;
    --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
    endTime := tr_data[1].t;

    FOREACH tgp IN ARRAY tr_data
    LOOP
        --RAISE NOTICE 'loop timestamp --> %', tgp.t;
    	IF endTime < tgp.t THEN
	    endTime := tgp.t;
	END IF;
    END LOOP;
    RETURN endTime;
END
$BODY$
LANGUAGE 'plpgsql' ;DROP FUNCTION IF EXISTS tg_type(tg_pair[]);
CREATE OR REPLACE FUNCTION tg_type(tr_data tg_pair[]) RETURNS Text AS
$BODY$
DECLARE
  tgp tg_pair;
  --flag BOOLEAN;
  type_of_first TEXT;
  number_of_Different int;

BEGIN

  --Simpler way to do this
  --
  number_of_Different := (SELECT COUNT(*) FROM (SELECT DISTINCT ST_GeometryType((unnest(tr_data)).g)) AS X);

  IF number_of_Different = 1 THEN
    RETURN (SELECT ST_GeometryType((unnest(tr_data)).g) LIMIT 1);
  END IF;

  RETURN 'Invalid';
END
$BODY$
LANGUAGE 'plpgsql';
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

      --RAISE NOTICE 'loop timestamp --> %', area;
      area := area + st_area(tgp.g);
    END IF;
  END LOOP;
  RETURN area;
END
$BODY$
LANGUAGE 'plpgsql';DROP FUNCTION IF EXISTS t_intersection_area( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_intersection_area(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$
DECLARE
  tgp1                tg_pair;
  tgp2                tg_pair;
  area                FLOAT;
  tgpairs1            tg_pair [];
  tgpairs2            tg_pair [];
  endTime             TIMESTAMP;
BEGIN

  IF tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL
  THEN
    RETURN 0;
  END IF;

  IF tr1.e_time < tr2.s_time OR tr1.s_time > tr2.e_time
  THEN
    RETURN 0;
  END IF;

  IF NOT st_intersects(tr1.bbox, tr2.bbox)
  THEN
    RETURN 0;
  END IF;

  area = 0;
  FOREACH tgp1 IN ARRAY tr1.tr_data
  LOOP
    FOREACH tgp2 IN ARRAY tr2.tr_data
    LOOP
      IF tgp1.t = tgp2.t
      THEN
        area := area + st_area(st_intersection(tgp1.g, tgp2.g));
      END IF;
    END LOOP;
  END LOOP;
  RETURN area;
END
$BODY$
LANGUAGE 'plpgsql';DROP FUNCTION IF EXISTS t_omax( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_omax(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$

DECLARE
  intersection_area FLOAT;
  area1	            FLOAT;
  area2		    FLOAT;
  max_area          FLOAT;

BEGIN
  intersection_area = t_intersection_area(tr1, tr2);
  
  IF intersection_area = 0
  THEN
    RETURN 0;
  END IF;

  area1 = t_area(tr1);
  area2 = t_area(tr2);
  IF area1 >= area2
  THEN
     max_area = area1;
  ELSE
     max_area = area2;
  END IF;


  RETURN intersection_area / max_area;

END

$BODY$
LANGUAGE 'plpgsql';
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
LANGUAGE 'plpgsql';DROP FUNCTION IF EXISTS t_jaccard_star( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_jaccard_star(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$
DECLARE
  intersection_area FLOAT;
  union_area        FLOAT;
BEGIN
  intersection_area := t_intersection_area(tr1, tr2);
  IF intersection_area = 0
  THEN
    RETURN 0;
  END IF;

  union_area := t_ts_union_area(tr1, tr2);
  --RAISE NOTICE 'intersection_area %', intersection_area;
  --RAISE NOTICE 'union_area %', union_area;
  IF union_area = 0
  THEN
    RETURN 0;
  END IF;

  RETURN intersection_area / union_area;
END
$BODY$
LANGUAGE 'plpgsql';DROP FUNCTION IF EXISTS t_jaccard( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_jaccard(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$
DECLARE
  intersection_area FLOAT;
  union_area        FLOAT;
BEGIN
  intersection_area := t_intersection_area(tr1, tr2);
  IF intersection_area = 0.0
  THEN
    RETURN 0;
  END IF;

  union_area := t_union_area(tr1, tr2);
  IF union_area = 0.0
  THEN
    RETURN 0;
  END IF;

  RETURN intersection_area / union_area;
END
$BODY$
LANGUAGE 'plpgsql';DROP FUNCTION IF EXISTS tg_head( tg_pairs[] );

--Since array indexing mechanism in plpgsql is a mystery,
-- we shouldn't use static number to get first element
CREATE OR REPLACE FUNCTION tg_head(tg_pairs tg_pair[])
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
LANGUAGE 'plpgsql';-- by Craig Ringer
DROP FUNCTION IF EXISTS array_sort(ANYARRAY);
CREATE OR REPLACE FUNCTION array_sort (ANYARRAY)
RETURNS ANYARRAY
AS $$
SELECT array_agg(x ORDER BY x) FROM unnest($1) x;
$$
LANGUAGE 'sql';DROP FUNCTION IF EXISTS t_area(trajectory);
CREATE OR REPLACE FUNCTION t_area(tr trajectory) RETURNS float AS
$BODY$
DECLARE
    area float;
    tgp tg_pair;
BEGIN
  area = 0;
  if tr ISNULL OR tr.tr_data ISNULL THEN
    return 0;
  END IF;

  FOREACH tgp IN ARRAY tr.tr_data
    LOOP
      RAISE NOTICE 'loop timestamp --> %', ST_Area(tgp.g);
      area = area + ST_Area(tgp.g);
  END LOOP;
  RETURN area;
END
$BODY$
LANGUAGE 'plpgsql' ;DROP FUNCTION IF EXISTS t_union( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_union(tr1 trajectory, tr2 trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
  tgp            tg_pair;
  tgp2           tg_pair;
  temp_pair      tg_pair;
  g              GEOMETRY;
  union_pairs    tg_pair [] = '{}';
  union_tr       trajectory;
BEGIN

  union_tr.tr_data = union_pairs;
  IF tr1 ISNULL OR tr2 ISNULL OR (tr1.tr_data ISNULL AND tr2.tr_data ISNULL)
  THEN
    RETURN union_tr;
  END IF;

  IF tr1.tr_data ISNULL
  THEN
    union_tr.tr_data = tr2.tr_data;
    RETURN _trajectory(union_pairs);
  END IF;

  IF tr2.tr_data ISNULL
  THEN
    union_tr.tr_data = tr1.tr_data;
    RETURN _trajectory(union_pairs);
  END IF;

  --For Jaccard calculation

  FOREACH tgp IN ARRAY tr1.tr_data
  LOOP
    g = t_record_at(tr2, tgp.t);
    IF g IS NOT NULL
    THEN
      --RAISE NOTICE 'loop timestamp --> %', tgp;
      temp_pair.t = tgp.t;
      temp_pair.g = ST_Union(tgp.g, g);
    END IF;
    IF g IS NULL
    THEN
      union_pairs := union_pairs || tgp;
    END IF;
  END LOOP;

  FOREACH tgp IN ARRAY tr2.tr_data
  LOOP
    g = t_record_at(tr1, tgp.t);
    IF g IS NULL
    THEN
      temp_pair.t = tgp.t;
      temp_pair.g = tgp.g;
      union_pairs := union_pairs || temp_pair;
    END IF;
  END LOOP;
  union_tr = _trajectory(union_pairs);
  RETURN union_tr;
END
$BODY$
LANGUAGE 'plpgsql';DROP FUNCTION IF EXISTS t_record_at(trajectory, TIMESTAMP);
CREATE OR REPLACE FUNCTION t_record_at(tr trajectory, t TIMESTAMP) RETURNS Geometry AS
$BODY$
DECLARE
  tgp1 tg_pair;

BEGIN

  --PERFORM ASSERT IS NOT NULL tr;

    FOREACH tgp1 IN ARRAY tr.tr_data
    LOOP
      IF tgp1.t = t THEN
        RETURN tgp1.g;
      END IF;
    END LOOP;

    IF tr.geom_type = ST_GeometryType(ST_MakePoint(0,0)) THEN
      RETURN tg_record_at_interpolated(tr, t);
    END IF;


    RETURN NULL;
END
$BODY$
LANGUAGE 'plpgsql' ;DROP FUNCTION IF EXISTS t_length( trajectory );
CREATE OR REPLACE FUNCTION t_length(tr trajectory)
  RETURNS INTEGER AS
$BODY$

DECLARE
  time_count 	    INTEGER;
  tgp	            tg_pair;

BEGIN

  if tr.tr_data ISNULL THEN
    RETURN 0;
  END IF;

  time_count = 0;

  FOREACH tgp IN ARRAY tr.tr_data
  LOOP
      time_count = time_count + 1;
  END LOOP;


  RETURN time_count;

END

$BODY$
LANGUAGE 'plpgsql';
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
LANGUAGE 'plpgsql';DROP FUNCTION IF EXISTS t_duration(trajectory);
CREATE OR REPLACE FUNCTION t_duration(tr trajectory) RETURNS INTERVAL AS
$BODY$
DECLARE
BEGIN
  if tr ISNULL THEN
    return '-1'::INTERVAL;
  END IF;

  RETURN tr.e_time - tr.s_time;
END
$BODY$
LANGUAGE 'plpgsql' ;DROP FUNCTION IF EXISTS t_intersection( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_intersection(tr1 trajectory, tr2 trajectory)
  RETURNS trajectory AS
$BODY$
DECLARE
  tgp1                tg_pair;
  tgp2                tg_pair;
  temp_pair           tg_pair;
  intersecting_pairs  tg_pair [] = '{}';
  endTime             TIMESTAMP;
  result              trajectory;
BEGIN

  result.tr_data = intersecting_pairs;
  IF tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL
  THEN
    RETURN result;
  END IF;

  IF tr1.e_time < tr2.s_time OR tr1.s_time > tr2.e_time
  THEN
    RETURN result;
  END IF;

  IF NOT st_intersects(tr1.bbox, tr2.bbox)
  THEN
    RETURN result;
  END IF;
  --For Jaccard calculation
  --indexOfIntersection = 1;
  --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
  FOREACH tgp1 IN ARRAY tr1.tr_data
  LOOP
    FOREACH tgp2 IN ARRAY tr2.tr_data
    LOOP
      IF tgp1.t = tgp2.t
      THEN
        temp_pair.t := tgp1.t;
        temp_pair.g := st_intersection(tgp1.g, tgp2.g);
        intersecting_pairs := intersecting_pairs || temp_pair;
      END IF;
    END LOOP;
  END LOOP;
  result := _trajectory(intersecting_pairs);
  RETURN result;
END
$BODY$
LANGUAGE 'plpgsql';