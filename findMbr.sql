DROP FUNCTION IF EXISTS findMbr(integer); 

--findMBR:: finds mbr of a particular trajectory specified by the tr_id
--@param tr_id:: an integer specifying the trajectory identifier
CREATE OR REPLACE FUNCTION findMbr(tr_id integer) RETURNS geometry AS
$BODY$
DECLARE
    tgp tg_pair;
    tgpairs tg_pair[];
    mbr geometry;
BEGIN

    select tr_data into tgpairs
    from test_tr --test_tr is the name of the trajectory table, may as well be parametrized
    where id = tr_id;
    if not found then
	raise exception 'trajectory id % not found', 2;
    end if;
    --TODO check null condition here

    FOREACH tgp IN ARRAY tgpairs
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