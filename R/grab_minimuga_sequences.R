# grab the probe sequences from the MiniMUGA annotation file
# in preparation for BLASTn against the mouse genome
#
library(data.table)
library(qtl2convert)

# read the file
mini <- data.table::fread("../UNC/miniMUGA-Marker-Annotations.csv",
                          data.table=FALSE)

# trim the probes that have a seqB
hasB <- (mini$seqB != "")
mini$seqA[hasB] <- substr(mini$seqA[hasB], 1, nchar(mini$seqA[hasB])-1)

# subset data
mini <- mini[,c("Marker", "seqA", "reference", "alternate", "strand")]
colnames(mini) <- strsplit("marker,probe_seq,snp_a,snp_b,strand", ",")[[1]]

# write probes to file
qtl2convert::write2csv(mini, "../Sequences/mini_seq.csv",
                       comment=paste0("Probe sequences for miniMUGA file,",
                                      "taken from file from Fernando (received via Vivek Kumar)"),
                       overwrite=TRUE)
