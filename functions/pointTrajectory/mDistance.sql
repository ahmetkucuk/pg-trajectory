DROP FUNCTION IF EXISTS t_m_distance( trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_m_distance(tr1 trajectory, tr2 trajectory)
  RETURNS FLOAT[] AS
$BODY$
DECLARE
  result FLOAT[] = '{}';
  g GEOMETRY;
  tgp tg_pair;
BEGIN

  IF tr1.geom_type != 'POLYGON' OR tr1.geom_type != tr2.geom_type THEN
    RETURN result;
  END IF;

  FOREACH tgp IN ARRAY tr1.tr_data
  LOOP

    g := t_record_at(tr1, tgp.t);

    IF g IS NULL
    THEN
      result := result || tg_point_distance(tgp.g, g);
    END IF;
  END LOOP;
  RETURN result;

END
$BODY$
LANGUAGE 'plpgsql';