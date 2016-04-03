DROP FUNCTION IF EXISTS t_omax( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_omax(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT AS
$BODY$

DECLARE
  intersection_area FLOAT;
  area1	            FLOAT;
  area2		    FLOAT;
  max_area          FLOAT;

BEGIN
  intersection_area = t_area(t_intersection(tr1, tr2));
  
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
