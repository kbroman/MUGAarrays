R_OPTS=--no-save --no-restore --no-init-file --no-site-file
.PHONY : all

all: docs/study_sequences.html Sequences/gm_seq.csv

docs/study_sequences.html: R/study_sequences.Rmd $(GENESEEK) $(UNC)
	cd R;R $(R_OPTS) -e "rmarkdown::render('$(<F)')"
	mv R/$(@F) $@

Blast/R/gigamuga.fa: Blast/R/create_gm_fasta.R Sequences/gm_seq.csv Sequences/mm_seq.csv
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/R/megamuga.fa: Blast/R/create_gm_fasta.R Sequences/mm_seq.csv
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/results_gm/gm_blastn_results.rds: Blast/R/blastn_gm.R Blast/R/gigamuga.fa
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/results_mm/mm_blastn_results.rds: Blast/R/blastn_mm.R Blast/R/megamuga.fa
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Sequences/gm_seq.csv: R/grab_sequences.R $(GENESEEK)
	cd R;R $(R_OPTS) -e "source('$(<F)')"

GENESEEK = GeneSeek/common_markers.csv GeneSeek/gigamuga_geneseek.csv GeneSeek/megamuga_geneseek.csv
UNC = UNC/snps.gigamuga.Rdata UNC/snps.megamuga.Rdata

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
