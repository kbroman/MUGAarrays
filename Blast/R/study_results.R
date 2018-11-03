# study the results of blasting the sequences against the mouse genome (mm10)

clean_name <- function(ids) sapply(strsplit(ids, "\\|"), "[", 1)

# results of blasting the MM and GM markers against mouse genome (mm10)
# (including just the hits with <= 2 mismatches (out of 50 bp)
results_mm <- readRDS("results_mm/results.rds")
results_gm <- readRDS("results_gm/results.rds")

# clean versions of the query names
results_mm$clean_query <- clean_name(results_mm$query)
results_gm$clean_query <- clean_name(results_gm$query)

# markers with a hit
has_hit_mm <- unique(results_mm$clean_query)
has_hit_gm <- unique(results_gm$clean_query)

# annotations from UNC
load("../UNC/snps.megamuga.Rdata")
mm <- snps
load("../UNC/snps.gigamuga.Rdata")
gm <- snps
rm(snps)

tab_mm <- table(results_mm$clean_query)
tab_gm <- table(results_gm$clean_query)

# megamuga: 73,580 with one hit; 1508 with no hits; 2720 with >1 hit
one_hit_mm <- names(tab_mm)[tab_mm==1]
multi_hits_mm <- names(tab_mm)[tab_mm>1]
no_hits_mm <- mm$marker[!(mm$marker %in% has_hit_mm)]
c("0"=length(no_hits_mm), "1"=length(one_hit_mm), ">1"=length(multi_hits_mm))
n_hits_mm <- setNames(rep(0, nrow(mm)), rownames(mm))
n_hits_mm[names(tab_mm)] <- tab_mm

# gigamuga: 132,438 with one hit; 2742 with no hits; 8079 with >1 hit
one_hit_gm <- names(tab_gm)[tab_gm==1]
multi_hits_gm <- names(tab_gm)[tab_gm>1]
no_hits_gm <- gm$marker[!(gm$marker %in% has_hit_gm)]
c("0"=length(no_hits_gm), "1"=length(one_hit_gm), ">1"=length(multi_hits_gm))
n_hits_gm <- setNames(rep(0, nrow(gm)), rownames(gm))
n_hits_gm[names(tab_gm)] <- tab_gm

singles_mm <- results_mm[results_mm$clean_query %in% one_hit_mm,]
singles_gm <- results_gm[results_gm$clean_query %in% one_hit_gm,]

singles_mm$query_chr <- sapply(strsplit(singles_mm$query, "\\|"), "[", 2)
singles_mm$query_pos <- as.numeric(sapply(strsplit(singles_mm$query, "\\|"), "[", 3))
singles_gm$query_chr <- sapply(strsplit(singles_gm$query, "\\|"), "[", 2)
singles_gm$query_pos <- as.numeric(sapply(strsplit(singles_gm$query, "\\|"), "[", 3))
singles_mm <- singles_mm[,c("query", "chr", "tot_mismatch",
                            "start_query", "end_query", "start_chr", "end_chr",
                            "clean_query", "query_chr", "query_pos")]
singles_gm <- singles_gm[,c("query", "chr", "tot_mismatch",
                            "start_query", "end_query", "start_chr", "end_chr",
                            "clean_query", "query_chr", "query_pos")]

sum(singles_mm$chr != singles_mm$query_chr) #  6 mismatches
sum(singles_gm$chr != singles_gm$query_chr) # all match

table(singles_gm$query_pos - singles_gm$end_chr) # +/- 1 or 2 difference
table(singles_gm$query_pos - singles_gm$end_chr,
      singles_gm$end_chr - singles_gm$start_chr,
      singles_gm$end_query)

# some weird calculus here, to determine the correct value
wh <- singles_gm$end_query < 50 & singles_gm$end_chr > singles_gm$start_chr
singles_gm$end_chr[wh] <- singles_gm$end_chr[wh] + (50 - singles_gm$end_query[wh])

wh <- singles_gm$end_query < 50 & singles_gm$end_chr < singles_gm$start_chr
singles_gm$end_chr[wh] <- singles_gm$end_chr[wh] - (50 - singles_gm$end_query[wh])

singles_gm$pos_new <- singles_gm$end_chr + ifelse(singles_gm$start_chr > singles_gm$end_chr, -1, 1)
sum(singles_gm$pos_new != singles_gm$query_pos) # 1 difference

# some weird calculus here, to determine the correct value
wh <- singles_mm$end_query < 50 & singles_mm$end_chr > singles_mm$start_chr
singles_mm$end_chr[wh] <- singles_mm$end_chr[wh] + (50 - singles_mm$end_query[wh])

wh <- singles_mm$end_query < 50 & singles_mm$end_chr < singles_mm$start_chr
singles_mm$end_chr[wh] <- singles_mm$end_chr[wh] - (50 - singles_mm$end_query[wh])

singles_mm$pos_new <- singles_mm$end_chr + ifelse(singles_mm$start_chr > singles_mm$end_chr, -1, 1)
sum(singles_mm$pos_new != singles_mm$query_pos) # mostly different (mm9 vs mm10)


##############################
# new versions of the annotations
##############################

# make sure the sequences are correct
# include the new positions
# make chr, pos = NA for the markers with 0 or >1 hits
# add a column with "n_mm10_hits" with the number of hits to the mouse genome
gm_new <- readRDS("../PrimaryFiles/Revised/GM_snps_v3.rds")
mm_new <- readRDS("../PrimaryFiles/Revised/MM_snps_v3.rds")

char_col <- c("chr", "marker", "A1", "A2", "type", "rsID", "seq.A", "seq.B")
for(col in char_col) {
    if(col %in% colnames(gm)) gm[,col] <- as.character(gm[,col])
    if(col %in% colnames(mm)) mm[,col] <- as.character(mm[,col])
}

stopifnot(all(gm_new[gm$marker,"seq.A"] == gm[,"seq.A"]))

wh <- mm$marker[mm_new[mm$marker,"seq.A"] != mm[,"seq.A"]]
z <- cbind(mm_new[wh,c("marker","seq.A")], mm[wh,"seq.A"]) # the only differences are the missing ones
stopifnot(all(z$seq.A == ""))
mm_new[wh,"seq.A"] <- mm[wh, "seq.A"]
stopifnot(all(mm_new[mm$marker,"seq.A"] == mm$seq.A))

# reorder the new data frames as at UNC
mm_new <- mm_new[mm$marker,]
gm_new <- gm_new[gm$marker,]
stopifnot(all(mm_new$marker == mm$marker))
stopifnot(all(gm_new$marker == gm$marker))
stopifnot(all(mm_new$seq.A == mm$seq.A))
stopifnot(all(gm_new$seq.A == gm$seq.A))

# seq.B matches for GM
stopifnot(all(gm_new$seq.B == gm$seq.B | (is.na(gm_new$seq.B) & is.na(gm$seq.B))))

# combine the seq.B info
mm_new$seq.B[mm_new$seq.B == ""] <- NA
mm_new$seq.B[is.na(mm_new$seq.B) & !is.na(mm$seq.B)] <- mm$seq.B[is.na(mm_new$seq.B) & !is.na(mm$seq.B)]
mm$seq.B[!is.na(mm_new$seq.B) & is.na(mm$seq.B)] <- mm_new$seq.B[!is.na(mm_new$seq.B) & is.na(mm$seq.B)]
stopifnot(all(mm_new$seq.B == mm$seq.B | (is.na(mm_new$seq.B) & is.na(mm$seq.B))))

# make NA the chr, pos, cM where 0 or >1 hits
mm_new[names(n_hits_mm)[n_hits_mm != 1], c("chr", "pos", "cM")] <- NA
gm_new[names(n_hits_gm)[n_hits_gm != 1], c("chr", "pos", "cM")] <- NA

# paste in chr, pos for the single hits
mm_new[singles_mm$clean_query, "chr"] <- singles_mm$chr
mm_new[singles_mm$clean_query, "pos"] <- singles_mm$pos_new
gm_new[singles_gm$clean_query, "chr"] <- singles_gm$chr
gm_new[singles_gm$clean_query, "pos"] <- singles_gm$pos_new

# add n_mm10_hits column
mm_new[names(n_hits_mm), "n_mm10_hits"] <- n_hits_mm
gm_new[names(n_hits_gm), "n_mm10_hits"] <- n_hits_gm


# check the common markers between UNC mm/gm
mm_common <- mm[mm$marker %in% gm$marker,]
gm_common <- gm[match(mm_common$marker, gm$marker),]
stopifnot(all(gm_common$marker == mm_common$marker))
sum(mm_common$seq.A != gm_common$seq.A) # 29 have different sequences
dif_seq <- mm_common$marker[mm_common$seq.A != gm_common$seq.A]

# 8 where one either doesn't map or maps multiply
dif_seq_NA <- c("UNC780992", "UNC1681036", "JAX00357570", "UNC29538726",
                "UNC7283198", "JAX00611543", "UNC11448442", "UNC31179228")

# 21 where one hangs off one way and the other hangs off the other way
dif_seq <- c("JAX00019474", "UNC19959707", "UNC21599425", "UNC22740489", "UNC23689517",
             "UNC26072102", "UNC26408821", "UNC27604252", "UNC30509571", "UNC4070181",
             "UNC5934220", "UNC7115293", "UNC8920390", "UNC10933737", "UNC12559491",
             "JAX00674154", "JAX00709197", "UNC31119731", "JAX00717214", "JAX00184153",
             "JAX00184943")

query_pos <- sapply(dif_seq, function(a) c(results_mm[grep(a, results_mm$clean_query),"end_chr"],
                                           results_gm[grep(a, results_gm$clean_query),"end_chr"]))
# they all differ by 2 except JAX00674154 which differ by 1
# ...suggests that they are different snps :(

# check the common markers between MM and GM in the new data
mm_common <- mm_new[mm_new$marker %in% gm_new$marker,]
gm_common <- gm_new[match(mm_common$marker, gm_new$marker),]
stopifnot(all(gm_common$marker == mm_common$marker))
sum(mm_common$seq.A != gm_common$seq.A) # 29 have different sequences
library(broman)
sum(!cf(mm_common$chr, gm_common$chr)) # 7 differences ... but all where the sequences are different
sum(!is.na(mm_common$chr) & !is.na(gm_common$chr) & mm_common$pos != gm_common$pos) # 1 difference
mm_common$marker[!is.na(mm_common$chr) & !is.na(gm_common$chr) & mm_common$pos != gm_common$pos] # JAX00674154
wh <- !is.na(mm_common$chr) & !is.na(gm_common$chr) & !(mm_common$chr %in% c("M", "Y"))
# ... 4 cases where cM is missing in mm_common but not gm_common

# ... really need to paste in the G2F1 map

saveRDS(mm_new, "MM_snps_v4.rds")
saveRDS(gm_new, "GM_snps_v4.rds")

# save positions to files, for mouse map converter (http://cgd.jax.org/mousemapconverter)
write.table(mm_new[!is.na(mm_new$chr) & mm_new$chr %in% c(1:19,"X"),c("chr", "pos")],
            "megamuga_v4_mm10bp.txt", col.names=FALSE, row.names=FALSE, sep=" ", quote=FALSE)
gm_pos <- gm_new[!is.na(gm_new$chr) & gm_new$chr %in% c(1:19,"X"),c("chr", "pos")]
n_spl <- 10
gm_spl <- vector("list", n_spl)
for(i in 1:n_spl) {
    write.table(gm_pos[seq(i, nrow(gm_pos), by=n_spl),],
                paste0("gigamuga_v4_mm10bp_part", i, ".txt"),
                col.names=FALSE, row.names=FALSE, sep=" ", quote=FALSE)
}

# paste in the cM positions
mm_cM <- data.table::fread("megamuga_v4_g2f1_cM.txt", data.table=FALSE, head=FALSE)
mm_cM[mm_cM[,1] == 20,1] <- "X"
mm_new$cM <- NA
wh <- !is.na(mm_new$chr) & mm_new$chr %in% c(1:19,"X")
stopifnot(all(mm_cM[,1] == mm_new$chr[wh]))
mm_new$cM[wh] <- mm_cM[,2]

# fix a few other things
### make some things logical
for(col in c("Collaborative.Cross", "C57BL.6", "Genetically.enginereed.mice",
             "Mitochondria", "Other.Mus.species", "Chr.Y", "Special", "Wild.Mus.musculus",
             "MUGA")) {
    mm_new[,col] <- as.logical(mm_new[,col])
}
mm_new$Mitochondria <- FALSE
mm_new$Mitochondria[!is.na(mm_new$chr) & mm_new$chr=="M"] <- TRUE
mm_new$Chr.Y <- FALSE
mm_new$Chr.Y[!is.na(mm_new$chr) & mm_new$chr=="Y"] <- TRUE
cn <- colnames(mm_new)
cn[cn=="Genetically.enginereed.mice"] <- "Genetically.engineered.mice"
colnames(mm_new) <- cn


# paste in the cM positions
tmp <- lapply(1:n_spl, function(i)
                              data.table::fread(paste0("gigamuga_v4_g2f1_cM_part", i, ".txt"),
                                                data.table=FALSE, head=FALSE))
gm_cM <- gm_pos
for(i in 1:n_spl) {
    gm_cM[seq(i, nrow(gm_pos), by=n_spl),] <- tmp[[i]]
}
gm_cM[gm_cM[,1]==20,1] <- "X"
gm_new$cM <- NA
wh <- !is.na(gm_new$chr) & gm_new$chr %in% c(1:19,"X")
stopifnot(all(gm_cM[,1] == gm_new$chr[wh]))
gm_new$cM[wh] <- gm_cM[,2]

# fix a few other things
## haploChrM and haploChrY - make logical + drop markers with missing chr
gm_new$haploChrM <- as.logical(gm_new$haploChrM)
gm_new$haploChrM[is.na(gm_new$chr)] <- FALSE
gm_new$haploChrY <- as.logical(gm_new$haploChrY)
gm_new$haploChrY[is.na(gm_new$chr)] <- FALSE
## is.MM: change this to be properly in common (same name and sequence)
gm_common <- gm_new[gm_new$marker %in% mm$marker,]
mm_common <- mm_new[gm_common$marker,]
seq_match <- gm_common$marker[gm_common$seq.A == mm_common$seq.A]
gm_new$is.MM <- FALSE
gm_new[seq_match,"is.MM"] <- TRUE

# for each chromosome, find minimal cM and convert to 0
for(i in c(1:19,"X")) {
    mn <- min(mm_new$cM[!is.na(mm_new$chr) & mm_new$chr==i],
              gm_new$cM[!is.na(gm_new$chr) & gm_new$chr==i])
    mm_new$cM[!is.na(mm_new$chr) & mm_new$chr==i] <- mm_new$cM[!is.na(mm_new$chr) & mm_new$chr==i] - mn
    gm_new$cM[!is.na(gm_new$chr) & gm_new$chr==i] <- gm_new$cM[!is.na(gm_new$chr) & gm_new$chr==i] - mn
}

# hard-code a few badly behaved markers
bad_markers <- c("UNCJPD000988", "UNCJPD001874", "UNCJPD001230")
gm_new[bad_markers, c("chr", "pos", "cM")] <- NA
gm_new[bad_markers, "n_mm10_hits"] <- 2

saveRDS(mm_new, "MM_snps_v4.rds")
saveRDS(gm_new, "GM_snps_v4.rds")
