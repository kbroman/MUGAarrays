R_OPTS=--no-save --no-restore --no-init-file --no-site-file
.PHONY : all

all: docs/new_annotations.html docs/study_sequences.html docs/mini_annotations.html R/new_annotations.R R/mini_annotations.R docs/muga_annotations.html R/muga_annotations.R docs/mini_revisited.html

docs/study_sequences.html: R/study_sequences.Rmd $(GENESEEK) $(UNC)
	cd R;R $(R_OPTS) -e "rmarkdown::render('$(<F)')"
	mv R/$(@F) $@

docs/new_annotations.html: R/new_annotations.Rmd $(GENESEEK) $(UNC) $(BLAST) GenMaps/g2f1_shift.csv
	cd R;R $(R_OPTS) -e "rmarkdown::render('$(<F)')"
	mv R/$(@F) $@

docs/mini_annotations.html: R/mini_annotations.Rmd \
							Blast/results_mini/mini_blastn_results.rds \
							UNC/miniMUGA-Marker-Annotations.csv
	cd R;R $(R_OPTS) -e "rmarkdown::render('$(<F)')"
	mv R/$(@F) $@

docs/mini_revisited.html: R/mini_revisited.Rmd docs/mini_annotations.html
	cd R;R $(R_OPTS) -e "rmarkdown::render('$(<F)')"
	mv R/$(@F) $@

docs/muga_annotations.html: R/muga_annotations.Rmd \
							Blast/results_muga/muga_blastn_results.rds \
							UNC/snps.muga.Rdata
	cd R;R $(R_OPTS) -e "rmarkdown::render('$(<F)')"
	mv R/$(@F) $@

R/new_annotations.R: R/new_annotations.Rmd
	cd R;R $(R_OPTS) -e "knitr::purl('$(<F)')"

R/mini_annotations.R: R/mini_annotations.Rmd
	cd R;R $(R_OPTS) -e "knitr::purl('$(<F)')"

R/muga_annotations.R: R/muga_annotations.Rmd
	cd R;R $(R_OPTS) -e "knitr::purl('$(<F)')"

GenMaps/g2f1_shift.csv: R/amount_to_shift_g2f1.R \
						GenMaps/gm_g2f1.txt \
						GenMaps/mm_g2f1.txt \
						GenMaps/mini_g2f1.txt
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/R/gigamuga.fa: Blast/R/create_gm_fasta.R Sequences/gm_seq.csv
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/R/megamuga.fa: Blast/R/create_mm_fasta.R Sequences/mm_seq.csv
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/R/minimuga.fa: Blast/R/create_mini_fasta.R Sequences/mini_seq.csv
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/R/muga.fa: Blast/R/create_muga_fasta.R Sequences/muga_seq.csv
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/R/gigamuga_untrimmed.fa: Blast/R/create_gm_untrimmed_fasta.R Sequences/gm_seq.csv Sequences/gm_untrimmed_seq.csv
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/results_gm/gm_blastn_results.rds: Blast/R/blastn_gm.R Blast/R/gigamuga.fa
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/results_mm/mm_blastn_results.rds: Blast/R/blastn_mm.R Blast/R/megamuga.fa
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/results_mini/mini_blastn_results.rds: Blast/R/blastn_mini.R Blast/R/minimuga.fa
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/results_muga/muga_blastn_results.rds: Blast/R/blastn_muga.R Blast/R/muga.fa
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Blast/results_gm_untrimmed/gm_untrimmed_blastn_results.rds: Blast/R/blastn_gm_untrimmed.R Blast/R/gigamuga_untrimmed.fa
	cd $(<D);R $(R_OPTS) -e "source('$(<F)')"

Sequences/gm_seq.csv: R/grab_sequences.R $(GENESEEK)
	cd R;R $(R_OPTS) -e "source('$(<F)')"

Sequences/mini_seq.csv: R/grab_minimuga_sequences.R
	cd R;R $(R_OPTS) -e "source('$(<F)')"

Sequences/muga_seq.csv: R/grab_muga_sequences.R
	cd R;R $(R_OPTS) -e "source('$(<F)')"

GENESEEK = GeneSeek/common_markers.csv GeneSeek/gigamuga_geneseek.csv GeneSeek/megamuga_geneseek.csv
UNC = UNC/snps.gigamuga.Rdata UNC/snps.megamuga.Rdata UNC/snps.muga.Rdata
BLAST = Blast/results_gm/gm_blastn_results.rds Blast/results_gm/mm_blastn_results.rds Blast/results_gm_untrimmed/gm_untrimmed_blastn_results.rds

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

UNC/snps.muga.Rdata:
	wget -O $@ http://csbio.unc.edu/MUGA/snps.muga.Rdata
	touch $@
