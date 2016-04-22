--findEuclideanDistance.sql
DROP FUNCTION IF EXISTS EuclideanDistance(trajectory, trajectory);
CREATE OR REPLACE FUNCTION EuclideanDistance(tr1 trajectory, tr2 trajectory) RETURNS FLOAT AS
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
 END IF;--point both? 
END
$BODY$
LANGUAGE 'plpgsql';

--zNormalize.sql
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
