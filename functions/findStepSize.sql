DROP FUNCTION IF EXISTS t_sampling_interval(trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_sampling_interval(tr1 trajectory, tr2 trajectory) RETURNS INTERVAL AS
$BODY$
DECLARE

    stepSize1 INTERVAL;
    stepSize2 INTERVAL;
BEGIN

    IF array_length(tr1.tr_data, 1) > 1 THEN
        stepSize1 = (tr1.e_time - tr1.s_time) / (array_length(tr1.tr_data, 1) - 1);
    ELSE
        stepSize1 = INTERVAL '-1 seconds';
    END IF;

    IF array_length(tr2.tr_data, 1) > 1 THEN
        stepSize2 = (tr2.e_time - tr2.s_time) / (array_length(tr2.tr_data, 1) - 1);
    ELSE
        stepSize2 = (INTERVAL '-1 seconds');
    END IF;

    IF stepSize1 = (INTERVAL '-1 seconds') THEN
        IF stepSize2 = (INTERVAL '-1 seconds') THEN
            RETURN stepSize1;
        ELSE
            RETURN stepSize2;
        END IF;
    END IF;

    IF stepSize2 = (INTERVAL '-1 seconds') THEN
        IF stepSize1 = (INTERVAL '-1 seconds') THEN
            RETURN stepSize2;
        ELSE
            RETURN stepSize1;
        END IF;
    END IF;

    IF stepSize1 != stepSize2 THEN
        RAISE EXCEPTION 'step sizes not equal %', stepSize1, stepSize2;
        --stepSize1 = -1;
    END IF;

    return stepSize1;

END
$BODY$
LANGUAGE 'plpgsql' ;