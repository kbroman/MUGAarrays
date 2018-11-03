R_OPTS=--no-save --no-restore --no-init-file --no-site-file

all: docs/study_sequences.html Sequences/gm_seq.csv

docs/study_sequences.html: R/study_sequences.Rmd geneseek unc
	cd R;R $(R_OPTS) -e "rmarkdown::render('$(<F)')"
	mv R/$(@F) $@

Sequences/gm_seq.csv: R/grab_sequences.R GeneSeek/gigamuga_geneseek.csv GeneSeek/megamuga_geneseek.csv
	cd R;R $(R_OPTS) -e "source('$(<F)')"

geneseek: GeneSeek/common_markers.csv \
		  GeneSeek/gigamuga_geneseek.csv \
		  GeneSeek/megamuga_geneseek.csv

unc: UNC/snps.gigamuga.Rdata UNC/snps.megamuga.Rdata

GeneSeek/common_markers.csv: Python/xlsx2csv.py GeneSeek/Markers_common_to_both_Giga_and_Mega.xlsx
	$^ --sheet 1 > $@

GeneSeek/gigamuga_geneseek.csv: Python/xlsx2csv.py GeneSeek/Markers_common_to_both_Giga_and_Mega.xlsx
	$^ --sheet 2 > $@

GeneSeek/megamuga_geneseek.csv: Python/xlsx2csv.py GeneSeek/Markers_common_to_both_Giga_and_Mega.xlsx
	$^ --sheet 3 > $@

UNC/snps.gigamuga.Rdata:
	wget -O $@ http://csbio.unc.edu/MUGA/snps.gigamuga.Rdata
	touch $@

UNC/snps.megamuga.Rdata:
	wget -O $@ http://csbio.unc.edu/MUGA/snps.megamuga.Rdata
	touch $@
