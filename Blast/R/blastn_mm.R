# installed blastn with "sudo apt install ncbi-blast+"
#
# makeblastdb -in MouseFasta/chr19.fa -dbtype nuc
#
# blastn -db MouseFasta/chr19.fa -num_alignments 5 -out output_c19.txt -query wrong_location.fasta

# input <- "wrong_location.fa"
input <- "megamuga.fa"
output_dir <- "../results_mm"

# create indexes
for(chr in c(1:19,"X","Y","M")) {
    if(file.exists(paste0("../MouseFasta/chr", chr, ".fa.nsq"))) next
    cat(chr, "\n")
    system(paste0("makeblastdb -in ../MouseFasta/chr", chr, ".fa -dbtype nucl"))
}

# blast the sequences
if(!dir.exists(output_dir)) dir.create(output_dir)

cores <- parallel::detectCores()

for(chr in rev(c(1:19,"X","Y","M"))) {
    cat(chr, "\n")
    system(paste0("blastn -db ../MouseFasta/chr", chr, ".fa -num_threads ", cores,
                  " -ungapped -out ", output_dir, "/output_c",
                  chr, ".txt -query ", input, " -outfmt 6"))
}

# read the probe sequences
probes <- qtl2::read_csv("../../Sequences/mm_seq.csv")
nchar_probes <- setNames(nchar(probes$probe_seq), rownames(probes))

results <- lapply(c(1:19,"X","Y","M"), function(chr) {
    file <- paste0(output_dir, "/output_c", chr, ".txt")
    if(!file.exists(file)) return(NULL)
    if(length(readLines(file))==0) return(NULL)
    data.table::fread(paste0(output_dir, "/output_c", chr, ".txt"), header=FALSE, data.table=FALSE) })
results <- do.call("rbind", results)
colnames(results) <- c("query", "chr", "percent_match", "length", "n_mismatch", "n_gap",
                       "start_query", "end_query", "start_chr", "end_chr", "evalue", "bitscore")

results$probe_length <- nchar_probes[results$query]
results$tot_mismatch <- results$n_mismatch + (results$probe_length - results$length)
results <- results[results$tot_mismatch <= 2,]
results$chr <- sub("^chr", "", results$chr)

# determine SNP position
results$snp_pos <- results$end_chr
points_right <- results$end_chr > results$start_chr
results$snp_pos <- results$snp_pos + (points_right*2-1) # add +1 or -1 depending on direction
# now extend to end of query probe
results$snp_pos <- results$snp_pos + (results$probe_length - results$end_query)*(points_right*2-1)

# add strand info
results$strand <- rep("plus", nrow(results))
results$strand[results$end_chr < results$start_chr] <- "minus"

# remove duplicate rows
tag <- apply(results[,c("query", "chr", "start_chr", "end_chr")], 1, paste, collapse=":")
tagtab <- table(tag)
dup <- names(tagtab)[tagtab > 1]
todrop <- NULL
for(d in dup) {
     wh <- which(tag==d)
    todrop <- c(todrop, wh[-1])
}
results <- results[-todrop,]

saveRDS(results, paste0(output_dir, "/mm_blastn_results.rds"), compress=FALSE)
