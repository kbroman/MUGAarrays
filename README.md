## Re-derive MegaMUGA and GigaMUGA annotation files

[![doi badge](https://zenodo.org/badge/DOI/10.5281/zenodo.2587005.svg)](https://doi.org/10.5281/zenodo.2587005)

I had identified a number of potential problems in the GigaMUGA
annotation file, as well as discrepancies between the GigaMUGA and
MegaMUGA files. I suspect that some of the columns in the
[GigaMUGA annotation file from UNC](http://csbio.unc.edu/MUGA/snps.gigamuga.Rdata)
have been at least partially scrambled.

I emailed GeneSeek to get files with the probe sequences on the
arrays, and on 2018-11-02 I received a `.xlsx` file by email from Ben
Pejsar, Genomic Market Development Manager, Neogen GeneSeek
Operations.

My goals were to:

- blast the sequences for all markers in each of the arrays against
  the mouse genome

- figure out which SNPs have a single hit in the mouse genome, and to
  where

- compare the sequences and probe locations, and the markers with
  multiple hits, to the UNC annotation file

Summary of findings:

- the `unique` column in the UNC annotation file for the GigaMUGA
  array was messed up.

- we should use `NA` for chromosome and position of markers whose
  probe does not have a single perfect match in the mouse genome
  assembly

- for a small number of markers (the transversions, with two-bead
  Illumina probes), the probe sequence in the GeneSeek file includes
  the SNP and the SNP basepair positions in the UNC GigaMUGA file were
  off by 1.

- For the markers with unique probes, the GigaMUGA annotation
  file has the correct chromosome and position (except for the
  off-by-1 cases), while the MegaMUGA annotation file has six markers
  with incorrect chromosome assignment.

- There are a bunch of markers with different names but the same probe
  sequence. More troubling, there are 29 markers that are on both the
  MegaMUGA and GigaMUGA arrays but with different probes on the two
  arrays. These are switches from plus to minus strand but without
  changing the marker name, and for 8 of them, the sequence on one
  array is either not unique or has no perfect match in the genome.

- I'm not sure what to do with the markers on the "P" chromosome
  (pseudoautosomal?)

The following document describes what I've found:

- [New MegaMUGA/GigaMUGA Annotations](https://kbroman.org/MUGAarrays/new_annotations.html)

The new annotation files are in the [`UWisc`](UWisc) directory of this repository.
This includes a file, [`mm_gm_commonmark_uwisc_v1.csv`](UWisc/mm_gm_commonmark_uwisc_v1.csv),
indicating which markers are assaying common SNPs, within and between
the two arrays.

---

## Contents

- [`UWisc`](UWisc) - the new annotation files

- [`Blast`](Blast) - includes R code for constructing fasta files
  with the array sequences, and for using `blastn` map them to the
  mouse genome. The [ReadMe file](Blast/ReadMe.md) explains the source
  for the mouse genome files, and of the command-line blastn program.
  (installed `blastn` on linux with `sudo apt install ncbi-blast+`)

- [`GeneSeek`](Geneseek) - includes the `.xlsx` file with probe
  sequences, from Ben Pejsar at GeneSeek.

- [`Python`](Python) - `xlsx2csv.py` script for pulling worksheets
  from a `.xlsx` file as a CSV file.

- [`R`](R) - R code and R Markdown files with the analyses.
  [`new_annotations.Rmd`](R/new_annotations.Rmd) is the key document.

- [`UNC`](UNC) - the [ReadMe file](UNC/ReadMe.md) has URLs
  for the UNC annotation files.

- [`GenMaps`](GenMaps) - raw genetic map files derived using the
  [Mouse Map Converter](http://cgd.jax.org/mousemapconverter/).

- [`docs`](docs) - compiled RMarkdown files, available on the web:

  - [New annotations](https://kbroman.org/MUGAarrays/new_annotations.html)
  - [Study sequences](https://kbroman.org/MUGAarrays/study_sequences.html)

- [`Makefile`](Makefile) - [GNU
  Make](https://www.gnu.org/software/make) file to automate/document the
  analyses.

---

## MiniMUGA

[Vivek Kumar](https://www.jax.org/research-and-faculty/faculty/vivek-kumar)
asked me to take a look at the miniMUGA array, using an [annotation file](https://github.com/kbroman/MUGAarrays/blob/master/UNC/miniMUGA-Marker-Annotations.csv)
he got from [Fernando Pardo Manuel de
Villena](https://www.med.unc.edu/genetics/people/primary-faculty/fernando-pardo-manuel-de-villena-phd).

My analysis is at <https://kbroman.org/MUGAarrays/mini_annotations.html>

My annotation files are in the [`UWisc`](UWisc) directory.

---

## License

The code in this repository are released under the [MIT
License](LICENSE.md).
