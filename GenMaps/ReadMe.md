## Genetic maps of MM and GM markers

Got interpolated cM positions, from their physical positions, for all
markers whose probe sequences map uniquely to mouse genome build mm10,
using the [Mouse Map Converter](http://cgd.jax.org/mousemapconverter/)
at the Jackson Lab site.

- [`mm_cox.txt`](mm_cox.txt) and [`gm_cox.txt`](gm_cox.txt) have the
  positions from the [Cox et
  al.](https://doi.org/10.1534/genetics.109.105486) genetic map.

- [`mm_g2f1.txt`](mm_g2f1.txt) and [`gm_g2f1.txt`](gm_g2f1.txt) have the
  positions from the [Liu et al. (aka
  G2F1)](https://doi.org/10.1534/genetics.114.161653) genetic map.

All of the files lack header rows. The four columns are chromosome and
basepair position, followed by chromosome and sex-averaged cM position
from the mouse map converter. (I give it a file with chromosome and bp
position and select "Include Input" for the output.)
