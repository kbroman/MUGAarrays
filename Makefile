geneseek: GeneSeek/common_markers.csv \
		  GeneSeek/gigamuga_geneseek.csv \
		  GeneSeek/megamuga_geneseek.csv

GeneSeek/common_markers.csv: Python/xlsx2csv.py GeneSeek/Markers_common_to_both_Giga_and_Mega.xlsx
	$^ --sheet 1 > $@

GeneSeek/gigamuga_geneseek.csv: Python/xlsx2csv.py GeneSeek/Markers_common_to_both_Giga_and_Mega.xlsx
	$^ --sheet 2 > $@

GeneSeek/megamuga_geneseek.csv: Python/xlsx2csv.py GeneSeek/Markers_common_to_both_Giga_and_Mega.xlsx
	$^ --sheet 3 > $@
