# grab the probe sequences from the MiniMUGA annotation file
# in preparation for BLASTn against the mouse genome
#
library(data.table)
library(qtl2convert)

# read the file
unc_url <- "https://gsajournals.figshare.com/ndownloader/files/25117973"
unc_file <- "../UNC/miniMUGA_tableS2.csv"
if(!file.exists(unc_file)) download.file(unc_url, unc_file)
mini <- data.table::fread(unc_file,
                          data.table=FALSE)

# trim the probes that have a seqB
hasB <- (mini$seqB != "")
mini$seqA[hasB] <- substr(mini$seqA[hasB], 1, nchar(mini$seqA[hasB])-1)

# subset data
mini <- mini[,c("Marker name", "seqA", "reference allele", "alternate allele", "strand")]
colnames(mini) <- strsplit("marker,probe_seq,snp_a,snp_b,strand", ",")[[1]]

# write probes to file
qtl2convert::write2csv(mini, "../Sequences/mini2_seq.csv",
                       comment=paste0("Probe sequences for miniMUGA file,",
                                      "from supplement tableS2.csv at figshare",
                                      "https://doi.org/10.25386/genetics.11971941.v1"),
                       overwrite=TRUE)
