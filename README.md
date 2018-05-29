SPE
================

[![Build Status](https://travis-ci.org/SPE-R/SPE.svg?branch=master)](https://travis-ci.org/SPE-R/SPE)

**Material for the course Statistical Practice in Epidemiology with R**

-----

[pracs](https://github.com/SPE-R/SPE/tree/master/pracs) contains the exercises:

-   it reads ./adm/prog.tex which contain the program in details
-   each exercise has two files xxx-e.rnw and xxx-s.rnw
-   exercise .rnw files should contain the Sweave option "prefix.string=./graph/xxx" to avoid clutter in the pracs folder
-   the file pracs.tex compiles all the resulting .tex files to a single document - the file topreport.tex which in turn useful.tex

-----

To compile the pracs.pdf file, **in the root directory (i.e. `SPE`)**, run:

`make -f pracs/Makefile`

This will lead to the creation of `build/pracs.pdf` file.

Then clean the working directory running:

`make -f pracs/Makefile clean`

Automatic build of practicals pdf is preformed threw [SPE's Travis-ci platform](https://travis-ci.org/SPE-R/SPE).

For SPE tagged release, the [SPE's Travis-ci platform](https://travis-ci.org/SPE-R/SPE) will deploy pracs.pdf file on the [travis-build branch](https://github.com/SPE-R/SPE-R.github.io/tree/travis-build) of [SPE-R github page](https://spe-r.github.io/).

-----

[data](https://github.com/SPE-R/SPE/tree/master/data) contains datasets used which are not in the Epi package

-----

[adm](https://github.com/SPE-R/SPE/tree/master/adm) contains:

-   the program content in prog.tex - read by both ./pracs/pracs.tex and by ./adm/program
-   program.tex which produces a 2-page program in a separate .pdf
-   index.html (website) and pics/ (nifty pictures used over the years) will be (re)moved soon. They will be relocated on by the [SPE-R github page](https://spe-r.github.io/) [git repository](https://github.com/SPE-R/SPE-R.github.io/tree/master).

-----

[slides](https://github.com/SPE-R/SPE/tree/master/slides) is supposed to contain slides; one folder per lecture

-----

[misc](https://github.com/SPE-R/SPE/tree/master/misc) contains misclaneous documents:

- [SPE git quick statr guide](https://github.com/SPE-R/SPE/tree/master/misc/SPE_git-quick_start.md): coulpe of instructions to setup and use git on SPE repos
