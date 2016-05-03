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