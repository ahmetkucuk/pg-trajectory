--findIntersectionarea.sql
DROP FUNCTION IF EXISTS t_intersection_area( trajectory, trajectory );
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
  --For Jaccard calculation
  --indexOfIntersection = 1;
  --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
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
LANGUAGE 'plpgsql';

--findSpatioTemporalUnionArea.sql
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
LANGUAGE 'plpgsql';

--findUnionArea.sql
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

      RAISE NOTICE 'loop timestamp --> %', area;
      area := area + st_area(tgp.g);
    END IF;
  END LOOP;
  RETURN area;
END
$BODY$
LANGUAGE 'plpgsql';

--jaccard.sql
DROP FUNCTION IF EXISTS t_jaccard( trajectory, trajectory );
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
LANGUAGE 'plpgsql';

--j*.sql
DROP FUNCTION IF EXISTS t_jaccard_star( trajectory, trajectory );
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
  RAISE NOTICE 'intersection_area %', intersection_area;
  RAISE NOTICE 'union_area %', union_area;
  IF union_area = 0
  THEN
    RETURN 0;
  END IF;

  RETURN intersection_area / union_area;
END
$BODY$
LANGUAGE 'plpgsql';

--j*3.sql
DROP FUNCTION IF EXISTS t_jaccard_star(trajectory, trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_jaccard_star(tr1 trajectory, tr2 trajectory, tr3 trajectory) RETURNS float AS
$BODY$
DECLARE
  intersection_area float;
  union_area float;
  t1 trajectory;
  t2 trajectory;
  t3 trajectory;
BEGIN
  intersection_area = t_area(t_intersection(t_intersection(tr1, tr2),tr3));

  if intersection_area = 0 THEN
    return 0;
  END IF;
  --t_ts_union -> union in time and space
  --t_time_union union in time
  --if tr1 and tr2 intersect both in time and space get time stamp of tr3 where tr1 and tr2 intersects
  t1 = t_time_union(t_ts_union(tr1, tr2), tr3);
  t2 = t_time_union(t_ts_union(tr1, tr3), tr2);
  t3 = t_time_union(t_ts_union(tr2, tr3), tr1);

  union_area = t_area(t_union(t_union(t1, t2), t3));
  if union_area = 0 THEN
    return 0;
  END IF;
  RETURN intersection_area / union_area;
END
$BODY$
LANGUAGE 'plpgsql' ;

--jaccardThree.sql
DROP FUNCTION IF EXISTS t_jaccard( trajectory, trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_jaccard(tr1 trajectory, tr2 trajectory, tr3 trajectory)
  RETURNS FLOAT8
AS
$BODY$
DECLARE
  intersection_area FLOAT;
  union_area        FLOAT;
BEGIN
  intersection_area = t_area(t_intersection(t_intersection(tr1, tr2), tr3));
  IF intersection_area = 0
  THEN
    RETURN 0;
  END IF;

  union_area = t_area(t_union(t_union(tr1, tr2), tr3));
  IF union_area = 0
  THEN
    RETURN 0;
  END IF;
  RETURN  intersection_area / union_area;
END
$BODY$
LANGUAGE plpgsql VOLATILE;

--omax.sql
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
