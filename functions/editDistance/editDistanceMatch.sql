DROP FUNCTION IF EXISTS tg_ed_match( GEOMETRY, GEOMETRY, NUMERIC );
CREATE OR REPLACE FUNCTION tg_ed_match(g1 GEOMETRY, g2 GEOMETRY, e NUMERIC)
  RETURNS BOOL AS
$BODY$

DECLARE
  area_of_convexhull FLOAT;
  area_of_union FLOAT;
  mbr geometry;

BEGIN
  IF ST_GeometryType(g1) = 'ST_Point' THEN
    IF tg_point_distance(g1, g2) < e THEN
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  END IF;

  IF ST_GeometryType(g1) = 'ST_Polygon' THEN
    g1 := st_convexhull(g1);
    g2 := st_convexhull(g2);
    area_of_union := st_area(st_union(g1, g2));

    mbr := st_collect(g1, mbr);
    mbr := st_collect(g2, mbr);
    area_of_convexhull := st_area(mbr);
    IF (area_of_union/area_of_convexhull) < e THEN
      RETURN TRUE;
    END IF;
    RETURN FALSE;
  END IF;

  RETURN FALSE;

END

$BODY$
LANGUAGE 'plpgsql';
