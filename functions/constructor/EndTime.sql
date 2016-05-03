DROP FUNCTION IF EXISTS tg_end_time(tg_pair[]);
CREATE OR REPLACE FUNCTION tg_end_time(tr_data tg_pair[]) RETURNS timestamp AS
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