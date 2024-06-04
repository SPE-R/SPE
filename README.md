SPE
================

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

To produce the R source code from solutions .rnw files:

`make -f pracs/Makefile Rsol`

Automatic build of practicals pdf and R solutions files is preformed using [GitHub Actions](https://docs.github.com/fr/actions).

For SPE tagged release, the [SPE's GitHub Actions workflow](https://github.com/SPE-R/SPE/actions) will deploy pracs.pdf and R solutions files on the [gh-spe-material branch](https://github.com/SPE-R/SPE/tree/gh-spe-material). This material can be downloaded direcly from [gh-spe-material branch](https://github.com/SPE-R/SPE/tree/gh-spe-material) or via the dedicated [SPE-R github page](https://spe-r.github.io/).

-----

[data](https://github.com/SPE-R/SPE/tree/master/pracs/data) contains datasets used which are not in the Epi package

-----

[adm](https://github.com/SPE-R/SPE/tree/master/adm) contains:

-   the program content in prog.tex - read by both ./pracs/pracs.tex and by ./adm/program
-   program.tex which produces a 2-page program in a separate .pdf
-   index.html (website) and pics/ (nifty pictures used over the years) will be (re)moved soon. They will be relocated on by the [SPE-R github page](https://spe-r.github.io/) [git repository](https://github.com/SPE-R/SPE-R.github.io/tree/master).

-----

[slides](https://github.com/SPE-R/SPE/tree/master/slides) is supposed to contain slides; one folder per lecture; the lectures should be
compiled in PDF format. Theses PDF files will be combined in a single file for those who want to print the lectures.

-----

[misc](https://github.com/SPE-R/SPE/tree/master/misc) contains miscellaneous documents:

- [SPE git quick start guide](https://github.com/SPE-R/SPE/tree/master/misc/SPE_git-quick_start.md): couple of instructions to setup and use git on SPE repository
