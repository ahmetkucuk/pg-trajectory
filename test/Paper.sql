--SIMILARITY MEASURES

SELECT t_jaccard(t1.tr, t2.tr) from t_life_25_region_large_1 t1, t_life_25_region_large_2 t2;
SELECT t_jaccard(t1.tr, t2.tr) from t_life_50_region_large_1 t1, t_life_50_region_large_2 t2;
SELECT t_jaccard(t1.tr, t2.tr) from t_life_100_region_large_1 t1, t_life_100_region_large_2 t2;
SELECT t_jaccard(t1.tr, t2.tr) from t_life_200_region_large_1 t1, t_life_200_region_large_2 t2;
SELECT t_jaccard(t1.tr, t2.tr) from t_solar_large_1 t1, t_solar_large_2 t2;


SELECT t_omax(t1.tr, t2.tr) from t_life_25_region_large_1 t1, t_life_25_region_large_2 t2;
SELECT t_omax(t1.tr, t2.tr) from t_life_50_region_large_1 t1, t_life_50_region_large_2 t2;
SELECT t_omax(t1.tr, t2.tr) from t_life_100_region_large_1 t1, t_life_100_region_large_2 t2;
SELECT t_omax(t1.tr, t2.tr) from t_life_200_region_large_1 t1, t_life_200_region_large_2 t2;
SELECT t_omax(t1.tr, t2.tr) from t_solar_large_1 t1, t_solar_large_2 t2;


SELECT t_jaccard_star(t1.tr, t2.tr) from t_life_25_region_large_1 t1, t_life_25_region_large_2 t2;
SELECT t_jaccard_star(t1.tr, t2.tr) from t_life_50_region_large_1 t1, t_life_50_region_large_2 t2;
SELECT t_jaccard_star(t1.tr, t2.tr) from t_life_100_region_large_1 t1, t_life_100_region_large_2 t2;
SELECT t_jaccard_star(t1.tr, t2.tr) from t_life_200_region_large_1 t1, t_life_200_region_large_2 t2;
SELECT t_jaccard_star(t1.tr, t2.tr) from t_solar_large_1 t1, t_solar_large_2 t2;



--EDIT EUCLIDEAN ON REGION
SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_life_25_region_small_1 t1, t_life_25_region_small_2 t2;
SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_life_50_region_small_1 t1, t_life_50_region_small_2 t2;
SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_life_100_region_small_1 t1, t_life_100_region_small_2 t2;
SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_life_200_region_small_1 t1, t_life_200_region_small_2 t2;
SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_solar_small_1 t1, t_solar_small_2 t2;


--EDIT EUCLIDEAN ON POINT
SELECT EuclideanDistance(t1.tr, t2.tr)  from t_life_25_point_small_1 t1, t_life_25_point_small_2 t2;
SELECT EuclideanDistance(t1.tr, t2.tr) from t_life_50_point_small_1 t1, t_life_50_point_small_2 t2;
SELECT EuclideanDistance(t1.tr, t2.tr) from t_life_100_point_small_1 t1, t_life_100_point_small_2 t2;
SELECT EuclideanDistance(t1.tr, t2.tr) from t_life_200_point_small_1 t1, t_life_200_point_small_2 t2;
SELECT EuclideanDistance(t1.tr, t2.tr) from t_geolife_small_1 t1, t_geolife_small_2 t2;


SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_life_25_point_small_1 t1, t_life_25_point_small_2 t2;
SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_life_50_point_small_1 t1, t_life_50_point_small_2 t2;
SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_life_100_point_small_1 t1, t_life_100_point_small_2 t2;
SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_life_200_point_small_1 t1, t_life_200_point_small_2 t2;
SELECT tg_edit_distance_2(t1.tr, t2.tr, '0.2'::NUMERIC, FALSE ) from t_geolife_small_1 t1, t_geolife_small_2 t2;

SELECT findtimelength(t.tr) from t_life_200_point_large_1 t;