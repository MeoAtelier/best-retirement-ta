
db := retirement
psql := psql -d $(db) --set ON_ERROR_STOP=1

.PHONY: all

all: .o/district-health-board-2015 \
	.o/ta2017_gv_clipped \
	.o/au2017_gv_clipped \
	.o/pop-ta \
	.o/pop-dhb \
	.o/pop-au \
	.o/dhb-ta-overlap \
	.o/healthcare_professionals_per100kpop \
	.o/healthcare_professionals \
	.o/2017_Areas_Table \
	.o/rates \
	.o/dwellings \
	.o/avg-rates
	$(psql) -f analysis/export.sql


.o/pop-%: analysis/population/load-%.sql analysis/population/%.csv .o/db
	$(psql) -f $<
	touch $@


.o/%: analysis/%.sql .o/db
	$(psql) -f $<
	touch $@


.o/%: analysis/load-%.sql analysis/%.csv .o/db
	$(psql) -f $<
	touch $@

.o/dhb-ta-overlap: .o/district-health-board-2015 .o/au2017_gv_clipped 

.o/healthcare_professionals: .o/pop-dhb .o/healthcare_professionals_per100kpop .o/dhb-ta-overlap .o/pop-au

.o/avg-rates: .o/rates .o/dwellings

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


analysis/2017_Areas_Table.csv: analysis/2017_Areas_Table.txt
	iconv -f CP850 -t UTF-8 $< > $@
