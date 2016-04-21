
DROP TYPE IF EXISTS moves CASCADE;
CREATE TYPE moves AS (
    moveID int,
    tg_samples tg_pair[],
    move_sem_info text
);

DROP TYPE IF EXISTS stops CASCADE;
CREATE TYPE stops AS (
    stopID int,
    times_of_stops timestamp without time zone[],
    geom_at_stop geometry,
    stop_sem_info text
);

DROP TYPE IF EXISTS semantic_trajectory CASCADE;
CREATE TYPE semantic_trajectory AS (
    s_begin tg_pair,
    list_of_moves moves[],
    list_of_stops stops[],
    s_end tg_pair
);

DROP FUNCTION IF EXISTS _semantic(tg_pair, moves[], stops[], tg_pair) CASCADE;
CREATE OR REPLACE FUNCTION _semantic(fb tg_pair, fm moves[], fs stops[], fe tg_pair) RETURNS semantic_trajectory AS
$BODY$
DECLARE
 sem semantic_trajectory;
 no_of_moves INTEGER;
 no_of_tgs INTEGER;
 no_of_stops INTEGER;
 no_of_tStops INTEGER;
 j INTEGER;
 k INTEGER;
 tempMove moves;
 tempStop stops;
BEGIN
 sem.s_begin = fb;
 sem.s_end = fe;

 no_of_moves = array_length(fm, 1);
 FOR j IN 1..no_of_moves LOOP
    -- use tempMove instead of sem.list_of_moves[j]
    --sem.list_of_moves[j].moveID = fm[j].moveID;
    tempMove.moveID = fm[j].moveID;
    no_of_tgs = array_length(fm[j].tg_samples, 1);
    FOR k IN 1..no_of_tgs LOOP
       --sem.list_of_moves[j].tg_samples[k] = fm[j].tg_samples[k];
       tempMove.tg_samples[k] = fm[j].tg_samples[k];
    END LOOP;
    --sem.list_of_moves[j].move_sem_info = fm[j].move_sem_info;
    tempMove.move_sem_info = fm[j].move_sem_info;
    sem.list_of_moves[j] = tempMove;
 END LOOP;

 no_of_stops = array_length(fs, 1);
 FOR j IN 1..no_of_stops LOOP
    --sem.list_of_stops[j].stopID = fs[j].stopID;
    tempStop.stopID = fs[j].stopID;
    no_of_tStops = array_length(fs[j].times_of_stops, 1);
    FOR k IN 1..no_of_stops LOOP
       --sem.list_of_stops[j].times_of_stops[k] = fs[j].times_of_stops[k];
       tempStop.times_of_stops[k] = fs[j].times_of_stops[k];
    END LOOP;
    --sem.list_of_stops[j].geom_at_stop = fs[j].geom_at_stop;
    tempStop.geom_at_stop = fs[j].geom_at_stop;
    --sem.list_of_stops[j].stop_sem_info = fs[j].stop_sem_info;
    tempStop.stop_sem_info = fs[j].stop_sem_info;
    sem.list_of_stops[j] = tempStop;
 END LOOP;

 RETURN sem;

END
$BODY$
LANGUAGE 'plpgsql';
