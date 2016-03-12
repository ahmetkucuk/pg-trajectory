DROP FUNCTION IF EXISTS t_sampling_interval(trajectory, trajectory);
CREATE OR REPLACE FUNCTION t_sampling_interval(tr1 trajectory, tr2 trajectory) RETURNS INTERVAL AS
$BODY$
DECLARE

    stepSize1 INTERVAL;
    stepSize2 INTERVAL;
BEGIN
    stepSize1 = (tr1.e_time - tr1.s_time) / array_length(tr1.tr_data, 1);
    stepSize2 = (tr2.e_time - tr2.s_time) / array_length(tr2.tr_data, 1);
    RAISE EXCEPTION 'step sizes not equal %', stepSize1, stepSize2;
    return stepSize1;

END
$BODY$
LANGUAGE 'plpgsql' ;