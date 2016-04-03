-- by Craig Ringer
DROP FUNCTION IF EXISTS array_sort(ANYARRAY);
CREATE OR REPLACE FUNCTION array_sort (ANYARRAY)
RETURNS ANYARRAY LANGUAGE SQL
AS $$
SELECT array_agg(x ORDER BY x) FROM unnest($1) x;
$$