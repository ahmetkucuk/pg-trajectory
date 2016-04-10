SELECT * from trajectory_table;

CREATE INDEX temporal_index ON trajectory_table USING btree ( tsrange(s_time, e_time));
CREATE INDEX spatial_index ON trajectory_table USING GIST (bbox);
VACUUM trajectory_table;