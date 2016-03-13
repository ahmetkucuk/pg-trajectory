DROP FUNCTION IF EXISTS t_intersection( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_intersection(tr1 trajectory, tr2 trajectory)
    RETURNS trajectory AS
$BODY$
DECLARE
    tgp1                tg_pair;
    tgp2                tg_pair;
    temp_pair           tg_pair;
    area                FLOAT;
    tgpairs1            tg_pair [];
    tgpairs2            tg_pair [];
    intersecting_pairs  tg_pair [];
    indexOfIntersection INTEGER;
    endTime             TIMESTAMP;
    startTime           TIMESTAMP;
    result              trajectory;
    stepSize            INTERVAL;
    stepSizeLong        INT8;
    count               INT4;
    startIndex1         INTEGER;
    startIndex2         INTEGER;
BEGIN
    IF tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL
    THEN
        result.id = 25;
        result.tr_data = intersecting_pairs;
        RETURN result;
    END IF;

    stepSize = t_sampling_interval(tr1, tr2);
    --RAISE NOTICE '%', stepSize;
    IF stepSize = '-1 seconds' :: INTERVAL
    THEN --then it means both of them have only one time-geo pair
        tgp1 := tr1.tr_data [1];
        --RAISE NOTICE '%', tgp1;
        tgp2 := tr2.tr_data [1];
        --RAISE NOTICE '%', tgp1;
        indexOfIntersection = 0;
        IF tgp1.t = tgp2.t THEN -- if the geometries are on the same timestamp
            temp_pair.t = tgp1.t; --set the timestamp
            temp_pair.g := st_intersection(tgp1.g, tgp2.g); --find their intersection
            intersecting_pairs [indexOfIntersection] := temp_pair;
        END IF;
        result.id = 25;
        result.tr_data = intersecting_pairs;
        RETURN result;
    END IF;


    stepSizeLong := EXTRACT(EPOCH FROM stepSize);
    --RAISE NOTICE 'long step size -> %', stepSizeLong;

    startTime = GREATEST(tr1.s_time, tr2.s_time);
    endTime = LEAST(tr1.e_time, tr2.e_time);
    count = (extract(EPOCH FROM (endTime - startTime)))::INT8 / stepSizeLong;
    --RAISE NOTICE 'startTime - %', (startTime);
    --RAISE NOTICE 'endTime - %', (endTime);
    --RAISE NOTICE 'count - %', (count);

    IF count >= 0 THEN
        startIndex1 := (extract(EPOCH FROM (startTime - tr1.s_time)))::INT8 / stepSizeLong;
        startIndex2 := (extract(EPOCH FROM (startTime - tr2.s_time)))::INT8 / stepSizeLong;
        --RAISE NOTICE 'startIndex1 - %', startIndex1;
        --RAISE NOTICE 'startIndex2 - %', startIndex2;
    ELSE
        result.id = 25;
        result.tr_data = intersecting_pairs;
        RAISE WARNING 'No temporal co-existence -- start and end time (%, %)', startTime, endTime;
        RETURN result;
    END IF;

    IF count = 0 THEN --then there is only one time-geo pair that starts at start indices
        tgp1 := tr1.tr_data [startIndex1 + 1];
        --RAISE NOTICE 'tgp1 -- %', tgp1;
        tgp2 := tr2.tr_data [startIndex2 + 1];
        --RAISE NOTICE 'tgp2 -- %', tgp1;
        indexOfIntersection = 0;
        IF tgp1.t = tgp2.t
        THEN
            temp_pair.t = tgp1.t;
            temp_pair.g := st_intersection(tgp1.g, tgp2.g);
            intersecting_pairs [indexOfIntersection] := temp_pair;
        END IF;
        result.id = 25;
        result.tr_data = intersecting_pairs;
        RETURN result;

    ELSE -- then there are more than one
        indexOfIntersection = 0;
        FOR i IN 1..(count+1) LOOP
            tgp1 := tr1.tr_data [startIndex1 + i];
            tgp2 := tr2.tr_data [startIndex2 + i];
            IF tgp1.t = tgp2.t
            THEN
                temp_pair.t = tgp1.t;
                temp_pair.g := st_intersection(tgp1.g, tgp2.g);
                intersecting_pairs [indexOfIntersection] := temp_pair;
                indexOfIntersection = indexOfIntersection + 1;
            END IF;
        END LOOP;

        result.id = 25;
        result.tr_data = intersecting_pairs;
        RETURN result;
    END IF;

END
$BODY$
LANGUAGE 'plpgsql';

--test here
SELECT t_intersection(t1.tr, t2.tr)
FROM trajectory_table t1, trajectory_table t2
WHERE (t2.tr).id = 220 AND (t1.tr).id = 224;
