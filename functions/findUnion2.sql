DROP FUNCTION IF EXISTS t_union2( trajectory, trajectory );
CREATE OR REPLACE FUNCTION t_union2(tr1 trajectory, tr2 trajectory)
    RETURNS trajectory AS
$BODY$
DECLARE
    tgp1                tg_pair;
    tgp2                tg_pair;
    temp_pair           tg_pair;
    area                FLOAT;
    tgpairs1            tg_pair [];
    tgpairs2            tg_pair [];
    union_pairs         tg_pair [];
    indexOfUnion        INTEGER;
    endTime             TIMESTAMP;
    startTime           TIMESTAMP;
    currentTime         TIMESTAMP;
    result              trajectory;
    stepSize            INTERVAL;
    stepSizeLong        INT8;
    count               INT4;
    startIndex1         INTEGER;
    startIndex2         INTEGER;
    tr1_index           INTEGER;
    tr2_index           INTEGER;
    tr1_flag            BOOLEAN;
    tr2_flag            BOOLEAN;
BEGIN
    IF tr1 ISNULL OR tr2 ISNULL OR tr1.tr_data ISNULL OR tr2.tr_data ISNULL
    THEN
        result.id = 26;
        result.tr_data = union_pairs;
        RETURN result;
    END IF;

    stepSize = t_sampling_interval(tr1, tr2);
    stepSizeLong := EXTRACT(EPOCH FROM stepSize);
    --RAISE NOTICE 'long step size -> %', stepSizeLong;

    startTime = LEAST(tr1.s_time, tr2.s_time); -- of the union
    endTime = GREATEST(tr1.e_time, tr2.e_time); -- -- of the union
    count = (extract(EPOCH FROM (endTime - startTime)))::INT8 / stepSizeLong; --number of timesteps (minus 1)
    --RAISE NOTICE 'startTime - %', (startTime);
    --RAISE NOTICE 'endTime - %', (endTime);
    --RAISE NOTICE 'count - %', (count);
    indexOfUnion = 1;
    IF count < 0 THEN
        RAISE EXCEPTION 'The trajectory start-end times must be malformed (ids::(%, %))', tr1.id, tr2.id;
    ELSEIF count = 0 THEN --the trajectories co-exist at the same timestamp
        tgp1 := tr1.tr_data [1];
        tgp2 := tr2.tr_data [1];

        IF tgp1.t = tgp2.t THEN -- if the geometries are on the same timestamp (they must be)
            temp_pair.t = tgp1.t; --set the timestamp
            temp_pair.g := st_union(tgp1.g, tgp2.g); --find their intersection
            union_pairs [indexOfUnion] := temp_pair;
        END IF;
        result.id = 26;
        result.s_time = findstarttime(union_pairs);
        result.e_time = findendtime(union_pairs);
        result.bbox =  findMbr(union_pairs);
        result.tr_data = union_pairs;
        RETURN result;
    ELSE -- then count is more than 0, meaning union will have at least two
        currentTime = startTime;
        FOR i IN 1..(count+1) LOOP
            tr1_index = 1 + (extract(EPOCH FROM (currentTime - tr1.s_time)))::INT8 / stepSizeLong;
            tr2_index = 1 + (extract(EPOCH FROM (currentTime - tr2.s_time)))::INT8 / stepSizeLong;
            --RAISE NOTICE 'tr1_index -- %', tr1_index;
            --RAISE NOTICE 'tr2_index -- %', tr2_index;
            --RAISE NOTICE 'idx of uni-- %', indexOfUnion;
            IF tr1_index >= 1 AND tr1_index <= array_length(tr1.tr_data, 1) THEN
                tr1_flag = TRUE;
            ELSE
                tr1_flag = FALSE;
            END IF;
            IF tr2_index >= 1 AND tr2_index <= array_length(tr2.tr_data, 1) THEN
                tr2_flag = TRUE;
            ELSE
                tr2_flag = FALSE;
            END IF;

            IF tr1_flag = TRUE AND tr2_flag = TRUE THEN
                tgp1 := tr1.tr_data [tr1_index];
                tgp2 := tr2.tr_data [tr2_index];
                IF tgp1.t = tgp2.t THEN -- if the geometries are on the same timestamp (they must be)
                    temp_pair.t = tgp1.t; --set the timestamp
                    temp_pair.g := st_union(tgp1.g, tgp2.g); --find their union
                    union_pairs [indexOfUnion] := temp_pair;
                END IF;
            ELSEIF tr1_flag = TRUE AND tr2_flag = FALSE THEN --only tr1 is valid
                union_pairs [indexOfUnion] := tr1.tr_data [tr1_index];
            ELSEIF tr1_flag = FALSE AND tr2_flag = TRUE THEN --only tr2 is valid
                union_pairs [indexOfUnion] := tr2.tr_data [tr2_index];
            ELSEIF tr1_flag = FALSE AND tr2_flag = FALSE THEN --both of them invalid! there must be a problem
                temp_pair.t = currentTime;
                union_pairs [indexOfUnion] := temp_pair;
            END IF;
            currentTime = currentTime + stepSize;
            indexOfUnion = indexOfUnion + 1;
        END LOOP;
        result.id = 26;
        result.s_time = findstarttime(union_pairs);
        result.e_time = findendtime(union_pairs);
        result.bbox =  findMbr(union_pairs);
        result.tr_data = union_pairs;
        RETURN result;

    END IF;

END
$BODY$
LANGUAGE 'plpgsql';

--test here
SELECT unnest((t_union2(t1.tr, t2.tr)).tr_data)
FROM trajectory_table t1, trajectory_table t2
WHERE (t2.tr).id = 220 AND (t1.tr).id = 224;
