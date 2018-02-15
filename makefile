
db := retirement
psql := psql -d $(db) --set ON_ERROR_STOP=1

.PHONY: all upload

all: analysis/main.html

.o/gis: .o/sunshine \
	.o/ta2017_gv_clipped \
	.o/district-health-board-2015 \
	.o/au2017_gv_clipped 
	touch $@

.o/load: .o/gis \
	.o/pop-ta \
	.o/pop-au \
	.o/pop-dhb \
	.o/healthcare_professionals_per100kpop \
	.o/2017_Areas_Table \
	.o/rates \
	.o/dwellings \
	.o/two-bedroom \
	.o/sunshine \
	.o/crime
	rm -rf analysis/main_cache
	touch $@


analysis/main.html: analysis/main.Rmd .o/orig
	Rscript -e 'library(rmarkdown); rmarkdown::render("analysis/main.Rmd", "html_document")' --vanilla

.o/orig: .o/gis .o/load \
	.o/dhb-ta-overlap \
	.o/healthcare_professionals \
	.o/avg-rates \
	.o/over-65 \
	.o/ta-sunshine \
	.o/rank \
	.o/crime-percapita
	$(psql) -f analysis/export.sql
	graphics
	touch $@

upload: analysis/main.html
	./upload.sh

.o/sunshine: analysis/sunshine/sunshine-hours-annual-average-1972-2013_1.tif .o/db
	$(psql) -c 'DROP TABLE IF EXISTS sunshine CASCADE;'
	raster2pgsql -s 2193 $< sunshine | $(psql)
	touch $@

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

.o/over-65: .o/pop-ta

.o/ta-sunshine: .o/sunshine

.o/crime-percapita: .o/crime

.o/rank: .o/avg-rates .o/ta-sunshine .o/over-65 .o/healthcare_professionals .o/two-bedroom .o/crime-percapita

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
