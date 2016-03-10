DROP FUNCTION IF EXISTS findIntersectionAreaOfTwo(integer, integer);
CREATE OR REPLACE FUNCTION findIntersectionAreaOfTwo(tr_id1 integer, tr_id2 integer) RETURNS float AS
$BODY$
DECLARE
    tgp1 tg_pair;
    tgp2 tg_pair;
    area float;
    tgpairs1 tg_pair[];
    tgpairs2 tg_pair[];
    endTime timestamp;
BEGIN

    select tr_data into tgpairs1
    from trajectorytable
    where id = tr_id1;
    if not found then
	raise exception 'trajectory id % not found', 2;
    end if;

    select tr_data into tgpairs2
    from trajectorytable
    where id = tr_id2;
    if not found then
	raise exception 'trajectory id % not found', 2;
    end if;
    --TODO check null condition here

    --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
    area = 0;

    FOREACH tgp1 IN ARRAY tgpairs1
    LOOP
      FOREACH tgp2 IN ARRAY tgpairs2
      LOOP
          RAISE NOTICE 'loop timestamp --> %', area;
          IF tgp1.t = tgp2.t THEN
            area := area + ST_Area(ST_Intersection(tgp1.g, tgp2.g));
          END IF;
      END LOOP;
    END LOOP;
    RETURN area;
END
$BODY$
LANGUAGE 'plpgsql' ;