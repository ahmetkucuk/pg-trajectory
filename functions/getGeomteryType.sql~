DROP FUNCTION IF EXISTS getTrajectoryType(tg_pair[]);
CREATE OR REPLACE FUNCTION getTrajectoryType(tr_data tg_pair[]) RETURNS Text AS
$BODY$
DECLARE
  tgp tg_pair;
  --flag BOOLEAN;
  type_of_first TEXT;

BEGIN
    type_of_first = ST_GeometryType(tr_data[1].g);

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
