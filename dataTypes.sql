DROP TYPE IF EXISTS trajectory CASCADE;
CREATE TYPE trajectory AS (id int, s_time TIMESTAMP, e_time TIMESTAMP, bbox GEOMETRY, tr_data tg_pair[]);