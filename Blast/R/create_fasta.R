# create fasta files

library(qtl2)

mm <- read_csv("../../Sequences/mm_seq.csv", rownames_included=FALSE)
gm <- read_csv("../../Sequences/gm_seq.csv", rownames_included=FALSE)

cat(paste0(">", mm$marker, "\n", mm$probe_seq, "\n", collapse=""),
    file="megamuga.fa")

cat(paste0(">", gm$marker, "\n", gm$probe_seq, "\n", collapse=""),
    file="gigamuga.fa")
