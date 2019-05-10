# create (original) muga fasta file

library(qtl2)

muga <- read_csv("../../Sequences/muga_seq.csv", rownames_included=FALSE)

cat(paste0(">", muga$marker, "\n", muga$probe_seq, "\n", collapse=""),
    file="muga.fa")
