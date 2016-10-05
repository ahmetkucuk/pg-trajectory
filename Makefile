EXTENSION = pg_trajectory        # the extensions name
SOURCE_FILE = pg_trajectory--0.0.1.sql
$(shell rm $(SOURCE_FILE))
$(shell cat ./model/TrajectoryDataModel.sql >> $(SOURCE_FILE))
$(shell find ./functions -type f -iname '*.sql' -exec sh -c "cat {}" \; >> $(SOURCE_FILE))
DATA = $(SOURCE_FILE) # script files to install

# postgres build stuff
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)