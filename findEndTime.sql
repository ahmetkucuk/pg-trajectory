DROP FUNCTION IF EXISTS findEndTime(integer);
CREATE OR REPLACE FUNCTION findEndTime(tr_id integer) RETURNS timestamp AS
$BODY$
DECLARE
    tgp tg_pair;
    tgpairs tg_pair[];
    endTime timestamp;
BEGIN

    select tr_data into tgpairs
    from test_tr
    where id = tr_id;
    if not found then
	raise exception 'trajectory id % not found', 2;
    end if;
    --TODO check null condition here

    --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
    endTime := tgpairs[1].t;

    FOREACH tgp IN ARRAY tgpairs
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