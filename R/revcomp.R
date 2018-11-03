# function to do reverse complement
revcomp <- function(txt, swap_snp_alleles=TRUE) {
    comp <- function(a) {
        b <- a
        b[a=="A"] <- "T"
        b[a=="C"] <- "G"
        b[a=="G"] <- "C"
        b[a=="T"] <- "A"
        b[a=="a"] <- "t"
        b[a=="c"] <- "g"
        b[a=="g"] <- "c"
        b[a=="t"] <- "a"
        b[a=="["] <- "]"
        b[a=="]"] <- "["
        b }

    result <- sapply(strsplit(txt, ""), function(a) paste(rev(comp(a)), collapse=""))

    if(swap_snp_alleles) {
        snps <- c("A/C", "A/G", "A/T",
                  "C/A", "C/G", "C/T",
                  "G/A", "G/C", "G/T",
                  "T/A", "T/C", "T/G")
        snps_rev <- snps[c(4,7,10,1,8,11,2,5,12,3,6,9)]
        for(i in seq_along(snps)) result <- sub(snps[i], snps_rev[i], result, fixed=TRUE)
    }
    result
}

justcomp <- function(txt) {
    comp <- function(a) {
        b <- a
        b[a=="A"] <- "T"
        b[a=="C"] <- "G"
        b[a=="G"] <- "C"
        b[a=="T"] <- "A"
        b[a=="a"] <- "t"
        b[a=="c"] <- "g"
        b[a=="g"] <- "c"
        b[a=="t"] <- "a"
        b }

    result <- sapply(strsplit(txt, ""), function(a) paste(comp(a), collapse=""))
}
