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
