DROP TABLE IF EXISTS distance_table;
CREATE TABLE distance_table (id NUMERIC, tr trajectory);

select count(*) from distance_table;


select tg_edit_distance_2(T.tr1, T.tr2, '0.5'::NUMERIC, TRUE) as edit, t_jaccard(T.tr1, T.tr2) as jaccard FROM (SELECT t1.tr AS tr1, t2.tr AS tr2 FROM distance_table t1, distance_table t2 WHERE t_jaccard((t1.tr), (t2.tr)) > 0 LIMIT 100) AS T;

SELECT * from (select tg_edit_distance_2(t1.tr, t2.tr, '0.5'::NUMERIC, TRUE) as r, t_jaccard(t1.tr, t2.tr) as j, t1.id, t2.id from distance_table t1, distance_table t2 LIMIT 500) AS T WHERE T.j>0;