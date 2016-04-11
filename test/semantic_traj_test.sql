DROP TABLE IF EXISTS semantic_trajectory_table CASCADE; 
CREATE TABLE semantic_trajectory_table (id int, str semantic_trajectory);

INSERT INTO semantic_trajectory_table (id, str)
VALUES (1,
_semantic(
--begin
( to_timestamp(10), ST_GeomFromText('POINT(1 2)') )::tg_pair,
--array of moves begins
ARRAY [
--move no 1
ROW(1,
--tgs of move 1
ARRAY[
ROW( to_timestamp(20), ST_GeomFromText('POINT(6 7)') )::tg_pair,
ROW( to_timestamp(30), ST_GeomFromText('POINT(7 8)') )::tg_pair
]::tg_pair[],
--sem info of move 1
'at marta 101'
)::moves,

--move no 2
ROW(2,
--tgs of move 2
ARRAY[
ROW( to_timestamp(60), ST_GeomFromText('POINT(15 16)') )::tg_pair,
ROW( to_timestamp(70), ST_GeomFromText('POINT(17 18)') )::tg_pair
]::tg_pair[],
--sem info of move 2
'at bus 1213'
)::moves,
--move no 3
ROW(3,
--tgs of move 2
ARRAY[
ROW( to_timestamp(100), ST_GeomFromText('POINT(15 16)') )::tg_pair,
ROW( to_timestamp(110), ST_GeomFromText('POINT(17 18)') )::tg_pair
]::tg_pair[],
--sem info of move 2
'at bus 1213'
)::moves

--all moves listed
]::moves[],
--array of stops begin
ARRAY[
--stop no 1
ROW(1,
--times of stop 1
ARRAY[to_timestamp(40), to_timestamp(50)],
--geom of stop 1
ST_GeomFromText('POINT(17 18)'),
--sem info at stop 1
'stopped for shopping'
)::stops,

--stop no 2
ROW(2,
--times of stop 2
ARRAY[to_timestamp(80), to_timestamp(90)],
--geom of stop 2
ST_GeomFromText('POINT(21 22)'),
--sem info at stop 1
'stopped for gossipping'
)::stops

-- all stops listed
]::stops[],

--end
( to_timestamp(120), ST_GeomFromText('POINT(101 202)') )::tg_pair
) --_semantic
)
;--values

SELECT unnest((s.str).list_of_moves) FROM semantic_trajectory_table s;

SELECT (mt.lm).moveID, ((mt.lm).tg_samples[1]).t AS Initial_move_times, (mt.lm).move_sem_info FROM 
(SELECT unnest((s.str).list_of_moves) AS lm FROM semantic_trajectory_table s) AS mt ;

SELECT (st.ls).stopID, (st.ls).times_of_stops[1] AS Initial_stop_times, (st.ls).geom_at_stop AS Stop_points, (st.ls).stop_sem_info FROM 
(SELECT unnest((s.str).list_of_stops) AS ls FROM semantic_trajectory_table s) AS st ;

SELECT (mt.lm).moveID, ((mt.lm).tg_samples[1]).t AS moveTime, (mt.lm).move_sem_info AS moveInfo FROM 
(SELECT unnest((s.str).list_of_moves) AS lm FROM semantic_trajectory_table s) AS mt 
UNION
SELECT (st.ls).stopID, (st.ls).times_of_stops[1] AS stopTime, (st.ls).stop_sem_info FROM 
(SELECT unnest((s.str).list_of_stops) AS ls FROM semantic_trajectory_table s) AS st ;

SELECT ( ((s.str).s_end).t - ((s.str).s_begin).t )AS time_passed
FROM semantic_trajectory_table s;



