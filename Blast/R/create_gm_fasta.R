# create gigamuga fasta file

library(qtl2)

gm <- read_csv("../../Sequences/gm_seq.csv", rownames_included=FALSE)

cat(paste0(">", gm$marker, "\n", gm$probe_seq, "\n", collapse=""),
    file="gigamuga.fa")
