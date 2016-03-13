DROP FUNCTION IF EXISTS findEndTime(tg_pair[]);
CREATE OR REPLACE FUNCTION findEndTime(tr_data tg_pair[]) RETURNS timestamp AS
$BODY$
DECLARE
    tgp tg_pair;
    endTime timestamp WITHOUT TIME ZONE;
BEGIN

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