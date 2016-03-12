select * from t_table;

select t_record_at(t_table.tr,to_timestamp(9955598))
    from t_table LIMIT 1;

select t_intersection(t1.tr,t2.tr)
    from t_table t1, t_table t2 WHERE (t2.tr).id = 4 AND (t1.tr).id = 5;


select t_union(t1.tr,t2.tr)
    from t_table t1, t_table t2 WHERE (t2.tr).id = 4 AND (t1.tr).id = 5;


select t_jaccard(t1.tr,t2.tr)
    from t_table t1, t_table t2 WHERE (t2.tr).id = 4 AND (t1.tr).id = 6;

select t_jaccard_star(t1.tr,t2.tr)
    from t_table t1, t_table t2 WHERE (t2.tr).id = 4 AND (t1.tr).id = 6;

select *, (jaccard_star - jaccard) as diff from (
    select (t1.tr).id, (t2.tr).id, (t3.tr).id, t_jaccard(t1.tr, t2.tr, t3.tr) as jaccard,
        t_jaccard_star(t1.tr, t2.tr, t3.tr) as jaccard_star from
        trajectory_table t1, trajectory_table t2, trajectory_table t3) as j;


select *, (jaccard_star - jaccard) as diff from (
    select (t1.tr).id, (t2.tr).id, t_jaccard(t1.tr, t2.tr) as jaccard,
        t_jaccard_star(t1.tr, t2.tr) as jaccard_star from
        trajectory_table t1, trajectory_table t2 WHERE (t1.tr).id != (t2.tr).id) as j;

select t_area(t_intersection(t1.tr, t2.tr)) as area, t_area(t_union(t1.tr, t2.tr)) as area2 from trajectory_table t1, trajectory_table t2 WHERE (t1.tr).id = 1 AND (t2.tr).id = 2;

