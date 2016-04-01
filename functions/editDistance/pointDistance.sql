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
