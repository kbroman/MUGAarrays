## Re-derive MegaMUGA and GigaMUGA annotation files

I had identified a number of potential problems in the GigaMUGA
annotation file, as well as discrepancies between the GigaMUGA and
MegaMUGA files. I suspect that some of the columns in the
[GigaMUGA annotation file from UNC](http://csbio.unc.edu/MUGA/snps.gigamuga.Rdata)
have been at least partially scrambled.

I emailed GeneSeek to get files with the probe sequences on the
arrays, and on 2018-11-02 I received a `.xlsx` file by email from Ben
Pejsar, Genomic Market Development Manager, Neogen GeneSeek
Operations.

My goals are to:

- blast the sequences for all markers in each of the arrays against
  the mouse genome

- figure out which SNPs have a single hit in the mouse genome, and to
  where

- compare the sequences and probe locations, and the markers with
  multiple hits, to the UNC annotation file

The following document describes what I've found:

- [New MegaMUGA/GigaMUGA Annotations](https://kbroman.org/MUGAarrays/new_annotations.html)

The new annotation files are in the [`UWisc`](UWisc) directory of this repository.

---

## Contents

- [`UWisc`](UWisc) - the new annotation files

- [`Blast`](Blast) - includes R code for constructing fasta files
  with the array sequences, and for using `blastn` map them to the
  mouse genome. The [ReadMe file](Blast/ReadMe.md) explains the source
  for the mouse genome files, and of the command-line blastn program.

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

## License

The code in this repository are released under the [MIT
License](LICENSE.md).
