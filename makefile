
db := retirement
psql := psql -d $(db) --set ON_ERROR_STOP=1

.PHONY: all

all: .o/district-health-board-2015 \
	.o/territorial-authority-2018-clipped-generalised \
	.o/pop-ta \
	.o/pop-dhb \
	.o/dhb-ta-overlap \
	.o/healthcare_professionals_per100kpop \
	.o/healthcare_professionals


.o/pop-%: analysis/population/load-%.sql analysis/population/%.csv .o/db
	$(psql) -f $<
	touch $@


.o/%: analysis/%.sql .o/db
	$(psql) -f $<
	touch $@


.o/%: analysis/load-%.sql analysis/%.csv .o/db
	$(psql) -f $<
	touch $@

.o/dhb-ta-overlap: .o/district-health-board-2015 .o/territorial-authority-2018-clipped-generalised

.o/healthcare_professionals: .o/pop-dhb .o/healthcare_professionals_per100kpop

.o/%: analysis/shp/%.shp .o/db
	$(psql) -c 'drop table if exists "$*" cascade'
	shp2pgsql -s 2193 $< | $(psql)
	$(psql) -c 'create index on "$*" using gist (geom); ANALYZE;'
	touch $@

.o/db:
	mkdir -p .o
	dropdb --if-exists $(db)
	createdb $(db)
	$(psql) -c "CREATE EXTENSION postgis;"
	touch $@

