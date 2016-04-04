--TRAJECTORY TO STRING
SELECT (t.tr).s_time as start_time, (t.tr).e_time as end_time, st_astext((t.tr).bbox) as mbr,
  (t.tr).geom_type as type, get_sampling_interval(t.tr) as step_size
FROM trajectory_table t;


--TRAJECTORY TO AREA, INTERSECTION, UNION
SELECT t1.id, t2.id, t_area(t1.tr) as area1, t_area(t2.tr) as area2,
  t_intersection_area(t1.tr, t2.tr) as intersection,
  t_union_area(t1.tr, t2.tr) as union_area
FROM trajectory_table t1, trajectory_table t2;


--JACCARD - JACCARD STAR - OMAX
SELECT t1.id, t2.id, t_jaccard(t1.tr, t2.tr) as jaccard,
  t_jaccard_star(t1.tr, t2.tr) as jaccard_star, t_omax(t1.tr, t2.tr) as omax
FROM trajectory_table t1, trajectory_table t2
WHERE (t1.tr).geom_type = 'Polygon' AND (t2.tr).geom_type = 'Polygon';

--OMAX Filter
SELECT (F1.A).id, (F1.B).id, t_jaccard_star((F1.A).tr, (F1.B).tr) FROM (
SELECT t1 as A, t2 as B, t_omax(t1.tr, t2.tr) as omax
FROM trajectory_table t1, trajectory_table t2
WHERE (t1.tr).geom_type = 'Polygon' AND (t2.tr).geom_type = 'Polygon') AS F1
WHERE omax > 0.04;


--EDIT DISTANCE FOR POINT
SELECT tg_edit_distance_2(t1.tr, t2.tr, '1'::NUMERIC, TRUE), (t1.tr).geom_type, (t2.tr).geom_type
FROM trajectory_table t1, trajectory_table t2
WHERE (t1.tr).geom_type = 'Point' AND (t2.tr).geom_type = 'Point';


--EDIT DISTANCE FOR POLYGON
SELECT tg_edit_distance_2(t1.tr, t2.tr, '1'::NUMERIC, TRUE), (t1.tr).geom_type, (t2.tr).geom_type
FROM trajectory_table t1, trajectory_table t2
WHERE (t1.tr).geom_type = 'Polygon' AND (t2.tr).geom_type = 'Polygon' LIMIT 1;

--zNormalize
SELECT zNormalize((t.tr).tr_data,2,3) FROM trajectory_table t WHERE t.id = 2;

--Euclidean Distance for points
SELECT t1.id AS traj_1_ID, t2.id AS traj_2_ID, EuclideanDistance(t1.tr, t2.tr) AS EuclideanDistance
FROM trajectory_table t1, trajectory_table t2
WHERE (t1.tr).geom_type = 'Point' AND (t2.tr).geom_type = 'Point';

--Modifying the trajecotries; trajectory 2 (point) spans from time 10 to 30
UPDATE trajectory_table t 
SET tr = drop_head(tr)
WHERE id = 1;

UPDATE trajectory_table t
SET tr = add_at_tail(( to_timestamp(40), ST_GeomFromText('POINT(9 10)') )::tg_pair, tr)
WHERE id = 1;

UPDATE trajectory_table t
SET tr = modify_at_time( to_timestamp(30), ST_GeomFromText('POINT(500 600)'), tr)
WHERE id = 1;

--APPENDIX
SELECT t1.id, t2.id, t_area(t1.tr) as area1, t_area(t2.tr) as area2, t_omax(t1.tr, t2.tr) as omax
FROM trajectory_table t1, trajectory_table t2;
