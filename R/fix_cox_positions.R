# fix cox map positions
#
# Our first version of the CoxMapV3 used an "improved" version of the
# crimap software. We used that because we had trouble getting the
# original crimap to compile and run.
#
# But we found that the changes in the estimated genetic maps were
# large and not entirely trustworthy, with long stretches of 0
# recombination.
#
# And so we went back to the original crimap software, was able to get
# it to compile and run, and got estimated maps that are now closely
# matching the originals, but updated for mouse genome build 39.
#
# But these still showed stretches of 0 recombination, and so we've
# "smoothed" the Cox maps slightly, by taking the intervals lengths to
# be a 1/50 mixture of constant recombination across the chromosome.
#
# See https://github.com/kbroman/CoxMapV3
#     https://github.com/kbroman/CriMap
#
# This script plugs in the new maps in place of the old ones

mini_file <- "../UWisc/mini_uwisc_v3.csv"
mini_nfile <- sub("v3", "v5", mini_file)
mini <- data.table::fread(mini_file, data.table=FALSE) # marker, chr, bp_grcm39, cM_cox

mm_file <- "../UWisc/mm_uwisc_v2.csv"
mm_nfile <- sub("v2", "v4", mm_file)
mm <- data.table::fread(mm_file, data.table=FALSE) # marker, chr, bp_grcm39, cM_cox

muga_file <- "../UWisc/muga_uwisc_v2.csv"
muga_nfile <- sub("v2", "v4", muga_file)
muga <- data.table::fread(muga_file, data.table=FALSE) # marker, chr, bp_grcm39, cM_cox

gm_file <- "../UWisc/gm_uwisc_v2.csv"
gm_nfile <- sub("v2", "v4", gm_file)
gm <- data.table::fread(gm_file, data.table=FALSE) # marker, chr, bp_grcm39, cM_cox

# copy dictionary files to new versions
file.copy(sub("uwisc", "uwisc_dict", mini_file),
          sub("uwisc", "uwisc_dict", mini_nfile))
file.copy(sub("uwisc", "uwisc_dict", mm_file),
          sub("uwisc", "uwisc_dict", mm_nfile))
file.copy(sub("uwisc", "uwisc_dict", muga_file),
          sub("uwisc", "uwisc_dict", muga_nfile))
file.copy(sub("uwisc", "uwisc_dict", gm_file),
          sub("uwisc", "uwisc_dict", gm_nfile))

library(mmconvert) # need mmconvert >= 0.3-1

# function to convert maps
correct_cox <- function(input) {

    # the portion of the input that is on autosomes or X chr and has GRCM39 position
    input_ax <- input[!is.na(input$chr) & input$chr %in% c(1:19,"X") & !is.na(input$bp_grcm39), ]

    # pull out just the 3 key columns
    input_ax_pos <- input_ax[,c("chr", "bp_grcm39", "marker")]
    colnames(input_ax_pos)[2] <- "pos"

    # get interpolated Cox map positions
    output <- mmconvert(input_ax_pos, "bp")
    cM_cox <- output$cM_coxV3_ave
    cM_cox[output$chr=="X"] <- output$cM_coxV3_female[output$chr=="X"]

    # paste them into the input object
    rn <- rownames(input)
    rownames(input) <- input$marker
    input[output$marker, "cM_cox"] <- cM_cox
    rownames(input) <- rn

    input
}

# convert the 4 arrays
mini_rev <- correct_cox(mini)
write.table(mini_rev, mini_nfile, sep=",", quote=FALSE,
            row.names=FALSE, col.names=TRUE)

mm_rev <- correct_cox(mm)
write.table(mm_rev, mm_nfile, sep=",", quote=FALSE,
            row.names=FALSE, col.names=TRUE)

muga_rev <- correct_cox(muga)
write.table(muga_rev, muga_nfile, sep=",", quote=FALSE,
            row.names=FALSE, col.names=TRUE)

gm_rev <- correct_cox(gm)
write.table(gm_rev, gm_nfile, sep=",", quote=FALSE,
            row.names=FALSE, col.names=TRUE)
