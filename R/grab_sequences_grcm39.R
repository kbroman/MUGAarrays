# grab the probe sequences from the GeneSeek MM and GM files
# in preparation for BLASTn against the mouse genome
#
# also write versions with just untrimmed versions of probes that I'm otherwise trimming

library(data.table)
library(qtl2convert)

# read the two sets of files
gm <- data.table::fread("../GeneSeek/gigamuga_geneseek.csv",
                        data.table=FALSE)
rownames(gm) <- gm$Name

mm <- data.table::fread("../GeneSeek/megamuga_geneseek.csv",
                        data.table=FALSE)
rownames(mm) <- mm$Name


# grab the two SNP alleles
gm$SNPa <- substr(gm$SNP, 2, 2)
gm$SNPb <- substr(gm$SNP, 4, 4)
mm$SNPa <- substr(mm$SNP, 2, 2)
mm$SNPb <- substr(mm$SNP, 4, 4)

# in the cases where the AlleleB probe sequence is available, clip off that last base
# so that the probe doesn't contain the SNP
gm_hasB <- which(gm$AlleleB_ProbeSeq != "")
gm$AlleleA_ProbeSeq_orig <- gm$AlleleA_ProbeSeq
gm$AlleleA_ProbeSeq[gm_hasB] <- substr(gm$AlleleA_ProbeSeq[gm_hasB], 1,
                                    nchar(gm$AlleleA_ProbeSeq[gm_hasB])-1)

mm_hasB <- which(mm$AlleleB_ProbeSeq != "")
mm$AlleleA_ProbeSeq_orig <- mm$AlleleA_ProbeSeq
mm$AlleleA_ProbeSeq[mm_hasB] <- substr(mm$AlleleA_ProbeSeq[mm_hasB], 1,
                                    nchar(mm$AlleleA_ProbeSeq[mm_hasB])-1)


# pull out just the columns we want to keep
gm_untrimmed <- gm[gm_hasB,c("Name", "AlleleA_ProbeSeq_orig", "SNPa", "SNPb", "IlmnStrand")]
mm_untrimmed <- mm[mm_hasB,c("Name", "AlleleA_ProbeSeq_orig", "SNPa", "SNPb", "IlmnStrand")]
gm <- gm[,c("Name", "AlleleA_ProbeSeq", "SNPa", "SNPb", "IlmnStrand")]
mm <- mm[,c("Name", "AlleleA_ProbeSeq", "SNPa", "SNPb", "IlmnStrand")]

# rename the columns
colnames(gm_untrimmed) <- colnames(mm_untrimmed) <-
colnames(gm) <- colnames(mm) <- c("marker", "probe_seq", "snp_a", "snp_b", "strand")

# write to CSV files
write2csv(gm, "../Sequences/gm_seq.csv",
          comment="Probe sequences for GigaMUGA file, taken from GeneSeek's annotations",
          overwrite=TRUE)

write2csv(mm, "../Sequences/mm_seq.csv",
          comment="Probe sequences for MegaMUGA file, taken from GeneSeek's annotations",
          overwrite=TRUE)

# write to CSV files
write2csv(gm_untrimmed, "../Sequences/gm_untrimmed_seq.csv",
          comment="Probe sequences for GigaMUGA file, taken from GeneSeek's annotations",
          overwrite=TRUE)

write2csv(mm_untrimmed, "../Sequences/mm_untrimmed_seq.csv",
          comment="Probe sequences for MegaMUGA file, taken from GeneSeek's annotations",
          overwrite=TRUE)
