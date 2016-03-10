DROP FUNCTION IF EXISTS findStartTime(integer);
--findStartTime::finds the start time of a particular trajectory identified by tr_id
--@param tr_id::integer that represents the trajectory identifier
CREATE OR REPLACE FUNCTION findStartTime(tr_id integer) RETURNS timestamp AS 
$BODY$
DECLARE
    tgp tg_pair;
    tgpairs tg_pair[];
    startTime timestamp;
BEGIN

    select tr_data into tgpairs
    from test_tr
    where id = tr_id;
    if not found then
	raise exception 'trajectory id % not found', tr_id;
    end if;
    --TODO check null condition here

    --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
    startTime := tgpairs[1].t;

    FOREACH tgp IN ARRAY tgpairs
    LOOP
        --RAISE NOTICE 'loop timestamp --> %', tgp.t;
    	IF startTime > tgp.t THEN
	    startTime := tgp.t;
	END IF;
    END LOOP;
    RETURN startTime;
END
$BODY$
LANGUAGE 'plpgsql' ;