# grab the probe sequences from the GeneSeek MM and GM files
# in preparation for BLASTn against the mouse genome

library(data.table)
library(qtl2convert)

# read the two sets of files
gm <- data.table::fread("../GeneSeek/gigamuga_geneseek.csv",
                        skip=7, data.table=FALSE)
wh <- which(gm[,1]=="[Controls]")
gm <- gm[1:(wh-1),]
rownames(gm) <- gm$Name

mm <- data.table::fread("../GeneSeek/megamuga_geneseek.csv",
                        skip=7, data.table=FALSE)
wh <- which(mm[,1]=="[Controls]")
mm <- mm[1:(wh-1),]
rownames(mm) <- mm$Name


# grab the two SNP alleles
gm$SNPa <- substr(gm$SNP, 2, 2)
gm$SNPb <- substr(gm$SNP, 4, 4)
mm$SNPa <- substr(mm$SNP, 2, 2)
mm$SNPb <- substr(mm$SNP, 4, 4)

# in the cases where the AlleleB probe sequence is available, clip off that last base
# so that the probe doesn't contain the SNP
hasB <- gm$AlleleB_ProbeSeq != ""
gm$AlleleA_ProbeSeq[hasB] <- substr(gm$AlleleA_ProbeSeq[hasB], 1,
                                    nchar(gm$AlleleA_ProbeSeq[hasB])-1)

hasB <- mm$AlleleB_ProbeSeq != ""
mm$AlleleA_ProbeSeq[hasB] <- substr(mm$AlleleA_ProbeSeq[hasB], 1,
                                    nchar(mm$AlleleA_ProbeSeq[hasB])-1)


# pull out just the columns we want to keep
gm <- gm[,c("Name", "AlleleA_ProbeSeq", "SNPa", "SNPb", "IlmnStrand")]
mm <- mm[,c("Name", "AlleleA_ProbeSeq", "SNPa", "SNPb", "IlmnStrand")]

# rename the columns
colnames(gm) <- colnames(mm) <- c("marker", "probe_seq", "snp_a", "snp_b", "strand")

# write to CSV files
write2csv(gm, "../Sequences/gm_seq.csv",
          comment="Probe sequences for GigaMUGA file, taken from GeneSeek's annotations",
          overwrite=TRUE)

write2csv(mm, "../Sequences/mm_seq.csv",
          comment="Probe sequences for MegaMUGA file, taken from GeneSeek's annotations",
          overwrite=TRUE)
