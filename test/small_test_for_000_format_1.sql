DROP TABLE IF EXISTS trajectory_table_without_indexing CASCADE; 
CREATE TABLE trajectory_table_without_indexing(id BIGINT, tr trajectory);

--Traj entry --> 5
INSERT INTO trajectory_table_without_indexing(id, tr) VALUES (5,
 _trajectory( ARRAY [
ROW ( TIMESTAMP '2008-10-29 09:21:38', ST_GeomFromText('POINT(39.994238 116.326786)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:21:43', ST_GeomFromText('POINT(39.994315 116.326758)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:21:48', ST_GeomFromText('POINT(39.994414 116.326719)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:21:53', ST_GeomFromText('POINT(39.994429 116.3267)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:21:58', ST_GeomFromText('POINT(39.99445 116.326712)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:03', ST_GeomFromText('POINT(39.994467 116.32675)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:08', ST_GeomFromText('POINT(39.994501 116.326781)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:13', ST_GeomFromText('POINT(39.994548 116.326814)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:18', ST_GeomFromText('POINT(39.994531 116.326856)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:23', ST_GeomFromText('POINT(39.994501 116.326873)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:28', ST_GeomFromText('POINT(39.994535 116.326884)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:33', ST_GeomFromText('POINT(39.994553 116.326946)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:38', ST_GeomFromText('POINT(39.99453 116.327051)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:43', ST_GeomFromText('POINT(39.994594 116.32715)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:48', ST_GeomFromText('POINT(39.994622 116.32723)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:53', ST_GeomFromText('POINT(39.994678 116.327302)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:22:58', ST_GeomFromText('POINT(39.99473 116.327365)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:23:03', ST_GeomFromText('POINT(39.994723 116.327451)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:23:08', ST_GeomFromText('POINT(39.994673 116.32758)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:26:28', ST_GeomFromText('POINT(39.992875 116.328912)'))::tg_pair, 
ROW ( TIMESTAMP '2008-10-29 09:30:28', ST_GeomFromText('POINT(39.981814 116.322374)'))::tg_pair
]::tg_pair[]));


--Traj entry --> 7
INSERT INTO trajectory_table_without_indexing(id, tr) VALUES (7,
 _trajectory( ARRAY [
ROW ( TIMESTAMP '2008-11-03 10:13:36', ST_GeomFromText('POINT(39.999976 116.326565)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-03 10:13:41', ST_GeomFromText('POINT(40.000032 116.326175)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-03 10:13:46', ST_GeomFromText('POINT(40.000038 116.326154)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-03 10:13:51', ST_GeomFromText('POINT(40.000035 116.326081)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-03 10:15:51', ST_GeomFromText('POINT(39.996877 116.326645)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-03 10:15:56', ST_GeomFromText('POINT(39.996825 116.326536)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-03 10:16:01', ST_GeomFromText('POINT(39.996785 116.326341)'))::tg_pair
]::tg_pair[]));


--Traj entry --> 17
INSERT INTO trajectory_table_without_indexing(id, tr) VALUES (17,
 _trajectory( ARRAY [
ROW ( TIMESTAMP '2008-11-16 08:55:32', ST_GeomFromText('POINT(39.999006 116.324101)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:55:37', ST_GeomFromText('POINT(39.999021 116.324136)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:55:42', ST_GeomFromText('POINT(39.999052 116.324136)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:55:47', ST_GeomFromText('POINT(39.999049 116.324154)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:55:52', ST_GeomFromText('POINT(39.999054 116.324188)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:55:57', ST_GeomFromText('POINT(39.999082 116.324213)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:56:02', ST_GeomFromText('POINT(39.999094 116.324207)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:56:07', ST_GeomFromText('POINT(39.999123 116.324178)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:56:12', ST_GeomFromText('POINT(39.999174 116.324115)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:56:17', ST_GeomFromText('POINT(39.99926 116.324056)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:56:22', ST_GeomFromText('POINT(39.999355 116.324014)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-16 08:56:27', ST_GeomFromText('POINT(39.999497 116.323903)'))::tg_pair
]::tg_pair[]));


--Traj entry --> 18
INSERT INTO trajectory_table_without_indexing(id, tr) VALUES (18,
 _trajectory( ARRAY [
ROW ( TIMESTAMP '2008-11-17 05:11:33', ST_GeomFromText('POINT(40.007591 116.321614)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:11:38', ST_GeomFromText('POINT(40.007604 116.32158)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:11:43', ST_GeomFromText('POINT(40.007528 116.32163)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:11:48', ST_GeomFromText('POINT(40.007446 116.321594)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:11:53', ST_GeomFromText('POINT(40.007303 116.321553)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:11:58', ST_GeomFromText('POINT(40.007187 116.321495)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:03', ST_GeomFromText('POINT(40.007039 116.321475)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:08', ST_GeomFromText('POINT(40.006879 116.321501)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:13', ST_GeomFromText('POINT(40.006671 116.321603)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:18', ST_GeomFromText('POINT(40.006378 116.321811)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:23', ST_GeomFromText('POINT(40.00633 116.321758)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:28', ST_GeomFromText('POINT(40.00628 116.321717)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:33', ST_GeomFromText('POINT(40.006159 116.321683)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:38', ST_GeomFromText('POINT(40.005973 116.321688)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:43', ST_GeomFromText('POINT(40.005812 116.321644)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:48', ST_GeomFromText('POINT(40.005644 116.321647)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:53', ST_GeomFromText('POINT(40.005504 116.321672)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:12:58', ST_GeomFromText('POINT(40.005349 116.321694)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:03', ST_GeomFromText('POINT(40.005213 116.321734)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:08', ST_GeomFromText('POINT(40.005053 116.321787)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:13', ST_GeomFromText('POINT(40.004931 116.321807)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:18', ST_GeomFromText('POINT(40.004818 116.321805)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:23', ST_GeomFromText('POINT(40.004663 116.321817)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:28', ST_GeomFromText('POINT(40.004455 116.321912)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:43', ST_GeomFromText('POINT(40.003775 116.322275)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:48', ST_GeomFromText('POINT(40.003616 116.32231)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:53', ST_GeomFromText('POINT(40.003807 116.321999)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:13:58', ST_GeomFromText('POINT(40.003734 116.321962)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:03', ST_GeomFromText('POINT(40.003604 116.32198)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:08', ST_GeomFromText('POINT(40.003422 116.322014)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:13', ST_GeomFromText('POINT(40.003222 116.322038)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:18', ST_GeomFromText('POINT(40.003032 116.322033)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:23', ST_GeomFromText('POINT(40.002864 116.322035)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:28', ST_GeomFromText('POINT(40.002692 116.32204)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:33', ST_GeomFromText('POINT(40.002532 116.32207)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:38', ST_GeomFromText('POINT(40.002376 116.322103)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:43', ST_GeomFromText('POINT(40.002188 116.322151)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:48', ST_GeomFromText('POINT(40.002031 116.322182)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:53', ST_GeomFromText('POINT(40.001906 116.322182)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:14:58', ST_GeomFromText('POINT(40.001821 116.322161)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:03', ST_GeomFromText('POINT(40.001689 116.322196)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:08', ST_GeomFromText('POINT(40.001565 116.322227)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:13', ST_GeomFromText('POINT(40.001459 116.322251)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:18', ST_GeomFromText('POINT(40.001388 116.322283)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:23', ST_GeomFromText('POINT(40.001347 116.322261)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:28', ST_GeomFromText('POINT(40.00122 116.322248)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:33', ST_GeomFromText('POINT(40.001102 116.322215)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:38', ST_GeomFromText('POINT(40.000971 116.322227)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:43', ST_GeomFromText('POINT(40.000814 116.32227)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:48', ST_GeomFromText('POINT(40.000595 116.322307)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:53', ST_GeomFromText('POINT(40.000364 116.322364)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:15:58', ST_GeomFromText('POINT(40.000148 116.322434)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:03', ST_GeomFromText('POINT(40.000978 116.321899)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:08', ST_GeomFromText('POINT(40.000823 116.321863)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:13', ST_GeomFromText('POINT(40.000698 116.321849)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:18', ST_GeomFromText('POINT(40.000541 116.321849)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:23', ST_GeomFromText('POINT(40.000375 116.321857)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:28', ST_GeomFromText('POINT(40.000271 116.321857)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:33', ST_GeomFromText('POINT(40.000162 116.321841)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:38', ST_GeomFromText('POINT(40.000074 116.321874)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:43', ST_GeomFromText('POINT(39.999929 116.321908)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:48', ST_GeomFromText('POINT(39.999766 116.321992)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:53', ST_GeomFromText('POINT(39.999548 116.322088)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:16:58', ST_GeomFromText('POINT(39.999464 116.322176)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:03', ST_GeomFromText('POINT(39.999387 116.322309)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:08', ST_GeomFromText('POINT(39.999293 116.322448)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:13', ST_GeomFromText('POINT(39.999235 116.32257)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:18', ST_GeomFromText('POINT(39.999152 116.322728)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:23', ST_GeomFromText('POINT(39.999086 116.322872)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:28', ST_GeomFromText('POINT(39.999036 116.323002)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:33', ST_GeomFromText('POINT(39.998992 116.323163)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:38', ST_GeomFromText('POINT(39.998984 116.323295)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:43', ST_GeomFromText('POINT(39.99894 116.323449)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:48', ST_GeomFromText('POINT(39.998894 116.323609)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:53', ST_GeomFromText('POINT(39.998884 116.323777)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:17:58', ST_GeomFromText('POINT(39.998884 116.323953)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:18:03', ST_GeomFromText('POINT(39.998817 116.32413)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:18:08', ST_GeomFromText('POINT(39.998722 116.324318)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:18:13', ST_GeomFromText('POINT(39.998661 116.324437)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:18:18', ST_GeomFromText('POINT(39.998662 116.324518)'))::tg_pair, 
ROW ( TIMESTAMP '2008-11-17 05:18:33', ST_GeomFromText('POINT(39.998616 116.324511)'))::tg_pair
]::tg_pair[]));

