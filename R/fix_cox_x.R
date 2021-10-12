# fix CoxMapV3 positions in muga annotations for X chromosome
library(here)
library(mmconvert)

arrays <- c("muga", "mm", "gm", "mini")
versions <- c(2, 2, 2, 3)

files <- paste0(arrays, "_uwisc_v", versions, ".csv")

for(file in files) {
    locfile <- here("UWisc", file)
    map <- data.table::fread(locfile, data.table=FALSE)

    wh <- (map$chr=="X" & !is.na(map$bp_grcm39))

    if(any(wh)) {
        submap <- map[wh, c("chr", "bp_grcm39", "marker")]

        newmap <- mmconvert(submap, "bp")

        stopifnot(nrow(submap) == nrow(newmap), all(submap$marker == newmap$marker))
        map[wh, "cM_cox"] <- newmap$cM_coxV3_female

        write.table(map, locfile, sep=",", quote=FALSE, row.names=FALSE, col.names=TRUE)
    }
}
