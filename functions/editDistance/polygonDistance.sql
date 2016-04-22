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
  area_of_convexhull := st_area(st_convexhull(convex_hull));

  --RAISE NOTICE 'union: % convex: %', area_of_union, area_of_convexhull;

  RETURN (1 - (area_of_union/area_of_convexhull));

END

$BODY$
LANGUAGE 'plpgsql';
