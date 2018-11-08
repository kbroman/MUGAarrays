# determine the amount to shift the G2F1 maps
#
# want to shift the MM, GM, and mini maps by the same amounts
# want to get them all so that cM > 0

mini <- data.table::fread("../GenMaps/mini_g2f1.txt", header=FALSE, data.table=FALSE)
mm <- data.table::fread("../GenMaps/mm_g2f1.txt", header=FALSE, data.table=FALSE)
gm <- data.table::fread("../GenMaps/gm_g2f1.txt", header=FALSE, data.table=FALSE)

g2f1_shift <- setNames(rep(NA, 20), c(1:19,"X"))

for(chr in c(1:19,"X")) {
    mini_bp <- mini[mini[,1]==chr,2]
    mini_cM <- mini[mini[,1]==chr,5]
    mm_bp <- mm[mm[,1]==chr,2]
    mm_cM <- mm[mm[,1]==chr,5]
    gm_bp <- gm[gm[,1]==chr,2]
    gm_cM <- gm[gm[,1]==chr,5]

    ratio <- diff(range(c(gm_cM, mm_cM, mini_cM)))/
        (diff(range(c(gm_bp, mm_bp, mini_bp)))/1e6)

    # shift to make 3 Mbp == 0 cM
    g2f1_shift[chr] <- -min(c(gm_cM, mm_cM, mini_cM)) + ratio * (min(c(gm_bp, mm_bp, mini_bp))/1e6 - 3)
}

write.table(cbind(chr=names(g2f1_shift), shift=broman::myround(g2f1_shift,3)),
            "../GenMaps/g2f1_shift.csv", sep=",", quote=FALSE,
            row.names=FALSE, col.names=TRUE)
