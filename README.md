# SPE
[![Build Status](https://travis-ci.org/SPE-R/SPE.svg?branch=master)](https://travis-ci.org/SPE-R/SPE)

Material for the course Statistical Practice in Epidemiology with R

#
pracs contains the exercises: 
- it reads ./adm/prog.tex which contain the program in details
- each exercise has two files xxx-e.rnw and xxx-s.rnw
- exercise .rnw files should contain the Sweave option
  "prefix.string=./graph/xxx" to avoid clutter in the pracs folder
- the file pracs.tex compiles all the resulting .tex files to a single
  document - \input the file topreport.tex which in turn \input useful.tex
#
data contains datasets used which are not in the Epi package
#
adm contains 
- the program content in prog.tex - read by both ./pracs/pracs.tex 
  and by ./adm/program 
- program.tex which produces a 2-page program in a separate .pdf
- index.html for the webpage
- pics/ with all the nifty pictures used over the years  
# 
slides is supposed to contain slides; one folder per lecture 
