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
