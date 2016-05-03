DROP FUNCTION IF EXISTS tg_mbr(tg_pair[]) CASCADE;

--findMBR:: finds mbr of a particular trajectory specified by the tr_id
--@param tr_id:: an integer specifying the trajectory identifier
CREATE OR REPLACE FUNCTION tg_mbr(tr_data tg_pair[]) RETURNS GEOMETRY AS
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
