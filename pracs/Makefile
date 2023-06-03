## ---
## SPE practicals complilation
## 2018-03-26
## ---

SHELL = /bin/sh

## the files suffixes to consider
.SUFFIXES: .tex .pdf .rnw .R .rmd .html

## The master file
MAIN = pracs

## The rnw depencencies
RNWINCLUDES = basic-e dinput-e tab-e tidyverse-e graph-intro-e simulation-e rates-rrrd-e logistic-e effects-e \
  cont-eff-e graphics-e oral-e DMDK-e causal-e  causInf2-e occoh-caco-e renal-e tab-s tidyverse-s graph-intro-s simulation-s \
  rates-rrrd-s logistic-s effects-s cont-eff-s graphics-s oral-s DMDK-s causal-s causInf2-s occoh-caco-s renal-s 

TEX = $(RNWINCLUDES:=.tex)
RFILES = $(RNWINCLUDES:=.R)
RNWFILES = $(RNWINCLUDES:=.rnw)
RMDFILES = $(RNWINCLUDES:=.rmd)
HTMLFILES = $(RNWINCLUDES:=.html)


RFILESSOL = $(filter %-s.R, $(RFILES))
TEXFILESEX = $(filter %-e.tex, $(TEX))
TEXFILESSOL = $(filter %-s.tex, $(TEX))
RMDFILESEX = $(filter %-e.rmd, $(RMDFILES))
HTMLFILESEX = $(filter %-e.html, $(HTMLFILES))

SRCDIR   = pracs
BUILDDIR = build

all: builddir; $(MAKE) -C ${BUILDDIR} $(MAIN).pdf; $(MAKE) -C ${BUILDDIR} $(MAIN)-sol.pdf 

$(MAIN).pdf: $(TEXFILESEX) $(MAIN).tex

$(MAIN)-sol.pdf: $(TEX) $(MAIN)-sol.tex

R: builddir; $(MAKE) -C ${BUILDDIR} $(RFILES)

Rsol: builddir; $(MAKE) -C ${BUILDDIR} $(RFILESSOL)

Rmd: builddir; $(MAKE) -C ${BUILDDIR} $(RMDFILESEX)

html: builddir; $(MAKE) -C ${BUILDDIR} $(HTMLFILESEX)

config: builddir

view: all
	evince $(MAIN).pdf &
  
.rnw.R:
	R CMD Stangle $<
  
.rnw.tex:
	R CMD Sweave $<
  
.tex.pdf:
	latexmk -pdflatex='pdflatex -file-line-error -synctex=1 -recorder -halt-on-error -interaction=nonstopmode' -pdf -pv $<
	
.rnw.rmd:
	perl rnw2rmd.pl $< > $(patsubst %.rnw,%.rmd,$<)

.rmd.html:
	R -e 'try(rmarkdown::render("$<", "html_document"))'

.PHONY: clean builddir

builddir:
	mkdir -p ${BUILDDIR} && cp -r $(SRCDIR)/* ${BUILDDIR}  && echo 'renv::activate("../")' > ${BUILDDIR}/.Rprofile

  
clean:
	rm -rf ${BUILDDIR}
#	rm -fv $(MAIN).pdf $(TEX) $(RFILES)
#	rm -fv *.aux *.dvi *.log *.toc *.bak *~ *.blg *.bbl *.lot *.lof
#	rm -fv *.nav *.snm *.out *.pyc *.vrb
#	rm -fv Rplots.pdf *.RData
#	rm -fv *.pdf
#	latexmk -C

