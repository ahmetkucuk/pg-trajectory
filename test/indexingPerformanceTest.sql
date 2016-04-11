SELECT * FROM trajectory_table LIMIT 7;

--SELECT * FROM trajectory_table_without_indexing;

--67 ms
SELECT * FROM trajectory_table t WHERE t.s_time = '"2008-10-28 00:38:26"';

--euclidean with indexing 6696 ms.
SELECT EuclideanDistance(t1, t2) AS EuclideanDistance
FROM trajectory_table t1, trajectory_table t2
WHERE t1.s_time = '"2008-10-28 00:38:26"' AND t2.s_time='"2008-10-29 09:30:38"';

--edit distance (182) with indexing 423086 ms. 
SELECT tg_edit_distance_2(t1, t2, '1'::NUMERIC, TRUE) AS edit
FROM trajectory_table t1, trajectory_table t2
WHERE t1.s_time = '"2008-10-28 00:38:26"' AND t2.s_time='"2008-10-29 09:30:38"';

--sampling interval with indexing 14 ms.
SELECT get_sampling_interval(t) AS sampling_interval 
FROM trajectory_table t
WHERE t.s_time = '"2008-10-28 00:38:26"';

--time length with indexing 14 ms.
SELECT findTimeLength(t) AS timeLength
FROM trajectory_table t
WHERE t.s_time = '"2008-10-28 00:38:26"';


--156 ms.
SELECT * FROM trajectory_table_without_indexing t WHERE (t.tr).s_time = '"2008-10-28 00:38:26"';

--euclidean without indexing 6765 ms.
SELECT t1.id AS traj_1_ID, t2.id AS traj_2_ID, EuclideanDistance(t1.tr, t2.tr) AS EuclideanDistance
FROM trajectory_table_without_indexing t1, trajectory_table_without_indexing t2
WHERE (t1.tr).s_time = '"2008-10-28 00:38:26"' AND (t2.tr).s_time='"2008-10-29 09:30:38"';

--edit distance without indexing 430028 ms.
SELECT tg_edit_distance_2(t1.tr, t2.tr, '1'::NUMERIC, TRUE) AS edit
FROM trajectory_table_without_indexing t1, trajectory_table_without_indexing t2
WHERE (t1.tr).s_time = '"2008-10-28 00:38:26"' AND (t2.tr).s_time='"2008-10-29 09:30:38"';

--sampling interval without indexing 47 ms.
SELECT get_sampling_interval(t.tr) AS sampling_interval 
FROM trajectory_table_without_indexing t
WHERE (t.tr).s_time = '"2008-10-28 00:38:26"';

--time length with indexing 66 ms.
SELECT findTimeLength(t.tr) AS timeLength
FROM trajectory_table_without_indexing t
WHERE (t.tr).s_time = '"2008-10-28 00:38:26"';













