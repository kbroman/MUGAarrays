# create fasta files

gmv3 <- readRDS("../PrimaryFiles/Revised/GM_snps_v3.rds")

# some initial ones to check
wrong_location <- c("UNC5698022", "UNCJPD000988", "UNC3640234",
                    "UNCJPD001874", "UNCJPD002501", "Mit0045",
                    "Mit016", "UNCJPD001230", "UNC17110748")
slightly_wrong <- "UNC684769"
wrong_location <- c(wrong_location, slightly_wrong)
wrong_location <- c(wrong_location, c("UNC16498383", "UNC26271493", "UNC2815389", "Cwc22exon12dist2"))


cat(paste0(">", wrong_location, "\n", as.character(gmv3[wrong_location, "seq.A"]), "\n", collapse=""),
    file="wrong_location.fa")

#                annotated position   position to which it maps
#                  chr  pos_Mbp          chr pos_Mbp   LOD
# UNC5698022        11   87.408            3  85.114 336.6
# UNCJPD000988       2  139.433            6  65.644 220.4
# UNC3640234        18   66.053            2 101.393 377.2
# UNCJPD001874       4   99.130            5  21.210 121.2
# UNCJPD002501       6    5.122            8  41.812 270.6
# Mit0045            1  132.791            [mitochondrial]
# Mit016             1   24.613            [mitochondrial]
# UNCJPD001230       3   40.978           19  23.343 381.5
# UNC17110748       14   84.754            9 110.206 321.4
# UNC684769          1   46.517            1  53.757 381.9
# UNC16498383        2  119.179            9  63.166 336.5
# UNC26271493        9   52.202           16   5.848 460.2
# UNC2815389        10   83.413            2  29.972 252.4
# Cwc22exon12dist2   2   77.904            2  83.826 249.7


# BLAST results
# UNC5698022     3:85,728,711-85,728,760    + 11:87,407,495-87,407,544
# UNCJPD000988   2:139,432,612-139,432,661  + 6:65,680,010-65,680,060
# UNC3640234     2:101,530,537-101,530,586  + 18:66,052,572-66,052,621
# UNCJPD001874   4:99,130,302-99,130,351
# UNCJPD002501   6:5,122,468-5,122,517
# Mit0045        1:132,791,172-132,791,221  + 12:97,061,620-97,061,669 + M:15,867-15,916
# Mit016         1:24,613,118-24,613,167    + M:9,411-9,460
# UNCJPD001230   3:40,977,516-40,977,565
# UNC17110748    9:110,240,089-110,240,138  + 14:84,754,007-84,754,056
# UNC684769      1:46,517,173-46,517,222

# additional problems: UNC16498383 (2 -> 9:63.6)
#                      UNC26271493 (9 -> 16:6.1)
#                      UNC2815389  (10 -> 2:29.9)
#
# "Cwc22exon12dist2" looks to be off slightly: belongs near 83.826 rather than 77.904 Mbp

load("../UNC/snps.gigamuga.Rdata")
markers <- paste0(snps$marker, "|", sub("^chr", "", snps$chr), "|", snps$pos)
cat(paste0(">", markers, "\n", as.character(snps$seq.A), "\n", collapse=""),
    file="gigamuga.fa")

load("../UNC/snps.megamuga.Rdata")
markers <- paste0(snps$marker, "|", sub("^chr", "", snps$chr), "|", snps$pos)
cat(paste0(">", markers, "\n", as.character(snps$seq.A), "\n", collapse=""),
    file="megamuga.fa")
