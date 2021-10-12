## Annotation files for MUGA arrays

### Updates for GRCm39 mouse build

[Dan Gatti](https://github.com/dmgatti) and [Belinda
Cornes](https://www.jax.org/people/belinda-cornes) have updated the
annotation files for mouse genome build GRCm39. These also include
sex-averaged genetic map positions for an updated version of the
[Cox et al. (2009)](https://doi.org/10.1534/genetics.109.105486) map; see
[CoxMapV3](https://github.com/kbroman/CoxMapV3).

- GigaMUGA:

  - [`gm_uwisc_dict_v2`](gm_uwisc_dict_v2.csv)
  - [`gm_uwisc_v2.csv`](gm_uwisc_v2.csv)

- MegaMUGA:

  - [`mm_uwisc_dict_v2.csv`](mm_uwisc_dict_v2.csv)
  - [`mm_uwisc_v2.csv`](mm_uwisc_v2.csv)

- MiniMUGA:

  - [`mini_uwisc_dict_v3.csv`](mini_uwisc_dict_v3.csv)
  - [`mini_uwisc_v3.csv`](mini_uwisc_v3.csv)

- Original MUGA:

  - [`muga_uwisc_dict_v2.csv`](muga_uwisc_dict_v2.csv)
  - [`muga_uwisc_v2.csv`](muga_uwisc_v2.csv)

---

### MegaMUGA/GigaMUGA annotation files


Updated annotation files for the MegaMUGA and GigaMUGA SNP genotyping
arrays.

See the [New MegaMUGA/GigaMUGA
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
  is a data dictionary describing the columns in `mm_gm_commonmark_uwisc_v1.csv`

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

### MiniMUGA

[Vivek Kumar](https://www.jax.org/research-and-faculty/faculty/vivek-kumar)
asked me to take a look at the miniMUGA array, using an [annotation file](https://github.com/kbroman/MUGAarrays/blob/master/UNC/miniMUGA-Marker-Annotations.csv)
he got from [Fernando Pardo Manuel de
Villena](https://www.med.unc.edu/genetics/people/primary-faculty/fernando-pardo-manuel-de-villena-phd).

The [miniMUGA paper](https://doi.org/10.1534/genetics.120.303596) has
now been published, with some additions to the array.
Initially [published at bioRxiv](https://doi.org/10.1101/2020.03.12.989400) on 2020-03-14,
it provides official annotations with the [Supplmental
material](https://doi.org/10.25386/genetics.11971941.v1), as [Table S2](https://gsajournals.figshare.com/articles/dataset/Supplemental_Material_for_Sigmon_et_al_2020/11971941?file=25117973).

My original analysis is at
<https://kbroman.org/MUGAarrays/mini_annotations.html>

But I've now added a comparison to the new annotations:
<https://kbroman.org/MUGAarrays/mini_revisited.html>

The annotation files are in this directory. The original version are
labeled `v1`:

- [`mini_uwisc_v1.csv`](mini_uwisc_v1.csv)
  is the key annotation file
- [`mini_uwisc_dict_v1.csv`](mini_uwisc_dict_v1.csv)
  is the data dictionary, with descriptions of the columns
- [`mini_commonmark_uwisc_v1.csv`](mini_commonmark_uwisc_v1.csv) has
  data on which pairs of markers on the miniMUGA array are assaying a
  common SNP, either the same probe or plus/minus strand pairs.
- [`mini_commonmark_uwisc_dict_v1.csv`](mini_commonmark_uwisc_dict_v1.csv)
  is a data dictionary describing the columns in `mini_commonmark_uwisc_v1.csv`

The version for the revised array are labeled `v2`:

- [`mini_uwisc_v2.csv`](mini_uwisc_v2.csv)
  is the key annotation file
- [`mini_uwisc_dict_v2.csv`](mini_uwisc_dict_v2.csv)
  is the data dictionary, with descriptions of the columns
- [`mini_commonmark_uwisc_v2.csv`](mini_commonmark_uwisc_v2.csv) has
  data on which pairs of markers on the miniMUGA array are assaying a
  common SNP, either the same probe or plus/minus strand pairs.
- [`mini_commonmark_uwisc_dict_v2.csv`](mini_commonmark_uwisc_dict_v2.csv)
  is a data dictionary describing the columns in `mini_commonmark_uwisc_v2.csv`

---

### Original MUGA

[Mandy Chen](https://www.jax.org/people/mandy-chen)
asked me to take a look at the original MUGA array, using
the annotations at UNC, <http://csbio.unc.edu/MUGA/snps.muga.Rdata>.

My analysis is at <https://kbroman.org/MUGAarrays/muga_annotations.html>

My annotation files are in this directory.

- [`muga_uwisc_v1.csv`](muga_uwisc_v1.csv)
  is the key annotation file
- [`muga_uwisc_dict_v1.csv`](muga_uwisc_dict_v1.csv)
  is the data dictionary, with descriptions of the columns
- [`muga_commonmark_uwisc_v1.csv`](muga_commonmark_uwisc_v1.csv) has
  data on which pairs of markers on the original MUGA array are assaying a
  common SNP, either the same probe or plus/minus strand pairs.
- [`muga_commonmark_uwisc_dict_v1.csv`](muga_commonmark_uwisc_dict_v1.csv)
  is a data dictionary describing the columns in `muga_commonmark_uwisc_v1.csv`
