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