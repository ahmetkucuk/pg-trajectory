--pairwise omax
SELECT (t1.tr).id AS traj1_id, (t2.tr).id AS traj2_id, t_omax(t1.tr, t2.tr) AS OMAX
FROM trajectory_table t1, trajectory_table t2
WHERE (t1.tr).id < (t2.tr).id;

--pairwise all three measures
SELECT (t1.tr).id AS traj1_id, (t2.tr).id AS traj2_id, 
t_omax(t1.tr, t2.tr) AS OMAX, t_jaccard(t1.tr, t2.tr) AS Jaccard, t_jaccard_star(t1.tr, t2.tr) AS Jaccard_star
FROM trajectory_table t1, trajectory_table t2
WHERE (t1.tr).id < (t2.tr).id;
