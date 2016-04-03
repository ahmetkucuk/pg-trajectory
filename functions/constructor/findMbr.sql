DROP FUNCTION IF EXISTS findMbr(tg_pair[]);

--findMBR:: finds mbr of a particular trajectory specified by the tr_id
--@param tr_id:: an integer specifying the trajectory identifier
CREATE OR REPLACE FUNCTION findMbr(tr_data tg_pair[]) RETURNS geometry AS
$BODY$
DECLARE
    tgp tg_pair;
    mbr geometry;
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
