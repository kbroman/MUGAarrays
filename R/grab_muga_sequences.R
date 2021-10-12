# grab the probe sequences from the original MUGA annotation file
# in preparation for BLASTn against the mouse genome
#
library(data.table)
library(qtl2convert)

muga_file = "../UNC/snps.muga.Rdata"

if(!file.exists(muga_file)) {
  download.file(url      = "http://csbio.unc.edu/MUGA/snps.muga.Rdata", 
                destfile = muga_file)
}

# read the file
load(muga_file)
muga <- snps

# here, don't trim the probes that have a seqB

# subset data
muga <- muga[,c("marker", "seq.A", "A1", "A2")]
colnames(muga) <- strsplit("marker,probe_seq,snp_a,snp_b", ",")[[1]]

# write probes to file
qtl2convert::write2csv(muga, "../Sequences/muga_seq.csv",
                       comment="Probe sequences for original MUGA file",
                       overwrite=TRUE)
