--findEndTime.sql
DROP FUNCTION IF EXISTS findEndTime(tg_pair[]);
CREATE OR REPLACE FUNCTION findEndTime(tr_data tg_pair[]) RETURNS timestamp AS
$BODY$
DECLARE
    tgp tg_pair;
    endTime timestamp;
BEGIN

      IF tr_data ISNULL THEN
        endTime := to_timestamp(-1)::TIMESTAMP;
        RETURN endTime;
    END IF;
    --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
    endTime := tr_data[1].t;

    FOREACH tgp IN ARRAY tr_data
    LOOP
        --RAISE NOTICE 'loop timestamp --> %', tgp.t;
    	IF endTime < tgp.t THEN
	    endTime := tgp.t;
	END IF;
    END LOOP;
    RETURN endTime;
END
$BODY$
LANGUAGE 'plpgsql' ;

--findMbr.sql
DROP FUNCTION IF EXISTS findMbr(tg_pair[]) CASCADE;

--findMBR:: finds mbr of a particular trajectory specified by the tr_id
--@param tr_id:: an integer specifying the trajectory identifier
CREATE OR REPLACE FUNCTION findMbr(tr_data tg_pair[]) RETURNS GEOMETRY AS
$BODY$
DECLARE
    tgp tg_pair;
    mbr GEOMETRY;
BEGIN

    IF tr_data ISNULL THEN
        return mbr;
    END IF;
    FOREACH tgp IN ARRAY tr_data
    LOOP
        --RAISE NOTICE '%', tgp.t;
        --RAISE NOTICE '%', ST_astext(tgp.g);
        mbr := st_collect(tgp.g, mbr);
        --RAISE NOTICE 'collection==> %', ST_astext(mbr);

    END LOOP;
    mbr := st_envelope(mbr);
    --RAISE NOTICE 'mbr %', ST_astext(mbr);
    RETURN mbr;
END
$BODY$
LANGUAGE 'plpgsql' ;

--findStartTime.sql
DROP FUNCTION IF EXISTS findStartTime(tg_pair[]);
CREATE OR REPLACE FUNCTION findStartTime(tr_data tg_pair[]) RETURNS TIMESTAMP AS
$BODY$
DECLARE
    tgp tg_pair;
    startTime TIMESTAMP;
BEGIN

      IF tr_data ISNULL THEN
        startTime := to_timestamp(-1)::TIMESTAMP;
        RETURN startTime;
    END IF;
    --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
    startTime = tr_data[1].t;

    FOREACH tgp IN ARRAY tr_data
    LOOP
        --RAISE NOTICE 'loop timestamp --> %', tgp.t;
    	IF startTime > tgp.t THEN
	      startTime = tgp.t;
	    END IF;
    END LOOP;
    RETURN startTime;
END
$BODY$
LANGUAGE 'plpgsql' ;

--getTrajectoryType.sql
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

