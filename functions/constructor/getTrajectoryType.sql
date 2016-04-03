DROP FUNCTION IF EXISTS getTrajectoryType(tg_pair[]);
CREATE OR REPLACE FUNCTION getTrajectoryType(tr_data tg_pair[]) RETURNS Text AS
$BODY$
DECLARE
  tgp tg_pair;
  --flag BOOLEAN;
  type_of_first TEXT;
  number_of_Different int;

BEGIN

  --Simpler way to do this
  --
  --number_of_Different := (SELECT COUNT(*) FROM (SELECT DISTINCT ST_GeometryType((unnest(tr_data)).g)) AS X);

  --IF number_of_Different = 1 THEN
  --  RETURN (SELECT ST_GeometryType((unnest(tr_data)).g) LIMIT 1);
  --END IF;

  --type_of_first := (SELECT ST_GeometryType((unnest(tr_data)).g) LIMIT 1);
    type_of_first := (SELECT ST_GeometryType((unnest(tr_data)).g) LIMIT 1);

    IF type_of_first = 'ST_Point' THEN
       --flag = TRUE;
       FOREACH tgp IN ARRAY tr_data
       LOOP
         IF ST_GeometryType(tgp.g) <> 'ST_Point' THEN
            RETURN 'Invalid';
         END IF;
       END LOOP;
       RETURN 'Point';
    ELSIF type_of_first = 'ST_Polygon' THEN
       --flag = TRUE;
       FOREACH tgp IN ARRAY tr_data
       LOOP
         IF ST_GeometryType(tgp.g) <> 'ST_Polygon' THEN
            RETURN 'Invalid';
         END IF;
       END LOOP;
       RETURN 'Polygon';
    ELSIF type_of_first = 'ST_LineString' THEN
       --flag = TRUE;
       FOREACH tgp IN ARRAY tr_data
       LOOP
         IF ST_GeometryType(tgp.g) <> 'ST_LineString' THEN
            RETURN 'Invalid';
         END IF;
       END LOOP;
       RETURN 'LineString';
    ELSE
       RETURN 'Invalid';
    END IF;
    
END
$BODY$
LANGUAGE 'plpgsql' ;
