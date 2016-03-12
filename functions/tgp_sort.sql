DROP FUNCTION IF EXISTS tgp_sort(tg_pair[]);
CREATE OR REPLACE FUNCTION tgp_sort(tr_data tg_pair[]) RETURNS tg_pair[] AS
$BODY$
DECLARE
    tgp tg_pair;
    arr_length INTEGER;
    startTime timestamp;
    temp_pair tg_pair;
BEGIN

    --RAISE NOTICE 'my timestamp --> %', tgpairs[1].t;
    startTime := tr_data[1].t;

  arr_length := array_length(tr_data, 1);
  FOR i IN 1..arr_length LOOP
    FOR j in i..arr_length LOOP
      RAISE NOTICE '%', (i*j);
      IF tr_data[i] > tr_data[j] THEN
        temp_pair := tr_data[i];
        tr_data[i] := tr_data[j];
        tr_data[j] := temp_pair;
      END IF;
    END LOOP;
  END LOOP;

  RETURN tr_data;

END
$BODY$
LANGUAGE 'plpgsql' ;
