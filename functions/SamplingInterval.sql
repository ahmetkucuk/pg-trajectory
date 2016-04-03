DROP FUNCTION IF EXISTS get_sampling_interval( trajectory );
CREATE OR REPLACE FUNCTION get_sampling_interval(tr trajectory)
  RETURNS INTERVAL AS
$BODY$
DECLARE
 stepSize INTERVAL;

BEGIN
 IF array_length(tr.tr_data, 1) > 1 THEN
    stepSize = (tr.e_time - tr.s_time) / (array_length(tr.tr_data, 1) - 1);
 ELSE
    stepSize = INTERVAL '-1 seconds';
 END IF;

 RETURN stepSize;
END
$BODY$
LANGUAGE 'plpgsql';
