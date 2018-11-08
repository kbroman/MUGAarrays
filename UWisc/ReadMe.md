## MegaMUGA/GigaMUGA annotation files

Updated annotation files for the MegaMUGA and GigaMUGA SNP genotyping
arrays.

See the [New MegaMugA/GigaMUGA
annotations](https://kbroman.org/MUGAarrays/new_annotations.html)
document (and [its R Markdown
source](https://github.com/kbroman/MUGAarrays/blob/master/R/new_annotations.Rmd))
for a description of how they were created.

- [`mm_uwisc_v1.csv`](mm_uwisc_v1.csv) and [`gm_uwisc_v1.csv`](gm_uwisc_v1.csv)
  are the annotation files
- [`mm_uwisc_dict_v1.csv`](mm_uwisc_dict_v1.csv) and [`gm_uwisc_dict_v1.csv`](gm_uwisc_dict_v1.csv)
  are data dictionaries, with descriptions of the columns
- [`mm_gm_commonmark_uwisc_v1.csv`](mm_gm_commonmark_uwisc_v1.csv) has
  data on which markers are in common, within and between the two
  arrays
- [`mm_gm_commonmark_uwisc_dict_v1.csv`](mm_gm_commonmark_uwisc_dict_v1.csv)
  is a data dictionary describing the columns in

You can load the annotation files into [R](https://www.r-project.org) as follows:

```{r}
dir <- "https://raw.githubusercontent.com/kbroman/MUGAarrays/master/UWisc/"
mm <- read.csv(paste0(dir, "mm_uwisc_v1.csv"))
gm <- read.csv(paste0(dir, "gm_uwisc_v1.csv"))
mm_dict <- read.csv(paste0(dir, "mm_uwisc_dict_v1.csv"))
gm_dict <- read.csv(paste0(dir, "gm_uwisc_dict_v1.csv"))
common <- read.csv(paste0(dir, "mm_gm_commonmark_uwisc_v1.csv"))
common_dict <- read.csv(paste0(dir, "mm_gm_commonmark_uwisc_dict_v1.csv"))
```

---

## MiniMUGA

[Vivek Kumar](https://www.jax.org/research-and-faculty/faculty/vivek-kumar)
asked me to take a look at the miniMUGA array, using an [annotation file](https://github.com/kbroman/MUGAarrays/blob/master/UNC/miniMUGA-Marker-Annotations.csv)
he got from [Fernando Pardo Manuel de
Villena](https://www.med.unc.edu/genetics/people/primary-faculty/fernando-pardo-manuel-de-villena-phd).

My analysis is at <https://kbroman.org/MUGAarrays/mini_annotations.html>

The annotation files are in this directory.
