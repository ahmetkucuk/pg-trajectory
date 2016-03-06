DROP FUNCTION IF EXISTS getAsTable(integer) CASCADE;
CREATE OR REPLACE FUNCTION findEndTime(tr_id integer) RETURNS TABLE(t TIMESTAMP, g GEOMETRY) AS
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

    FOREACH tgp IN ARRAY tgpairs
    LOOP
        RETURN NEXT (tgp.t, tgp.g);
    END LOOP;
    RETURN;
END
$BODY$
LANGUAGE 'plpgsql' ;