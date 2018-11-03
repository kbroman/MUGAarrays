# create megamuga fasta file

library(qtl2)

mm <- read_csv("../../Sequences/mm_seq.csv", rownames_included=FALSE)

cat(paste0(">", mm$marker, "\n", mm$probe_seq, "\n", collapse=""),
    file="megamuga.fa")
