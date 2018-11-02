## Re-derive MegaMUGA and GigaMUGA annotation files

I had identified a number of potential problems in the GigaMUGA
annotation file, as well as discrepencies between the GigaMUGA and
MegaMUGA files. I suspect that some of the columns in the
[GigaMUGA annotation file from UNC]() have been at least partially
scrambled.

I emailed GeneSeek to get files with the probe sequences on the
arrays, and on 2018-11-02 I received a `.xlsx` file by email from Ben
Pejsar, Genomic Market Development Manager, Neogen GeneSeek
Operations.

My goals are to:

- blast the sequences for all markers in each of the arrays against
  the mouse genome

- figure out which SNPs have a single hit in the mosue genome, and to
  where

- compare the sequences and probe locations, and the markers with
  multiple hits, to the UNC annotation file
