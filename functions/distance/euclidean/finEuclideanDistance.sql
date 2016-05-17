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
