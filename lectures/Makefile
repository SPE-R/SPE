## ---
## SPE lectures pdf complilation as 3x1 handbook
## 2018-06-25
## ---

SHELL = /bin/sh

## the files suffixes to consider
.SUFFIXES: .pdf

## The master file
MAIN = SPE-2018-lectures-3x1

## The rnw depencencies
PDFINCLUDES = \
	ecology/R-history-ecology.pdf \
	language-index/spe2018-lang_index.pdf \
	poisson-logistic/SPE-Poisson-Logistic-Regression.pdf \
	linmodels/lm.pdf \
	graphics_advanced/Graphics.pdf \
	Survival_competing_risk/Survival_competing_risk.pdf \
	time-rep/time-rep.pdf \
	casecontrol/NCC-CC-studies.pdf \
	causal/spe2017-CIlect-kf.pdf \
	multistate/multistate.pdf
	
## PDFINCLUDES = \
	linmodels/lm.pdf \
	graphics_advanced/Graphics.pdf \
	time-rep/time-rep.pdf \
	casecontrol/NCC-CC-studies.pdf \
	causal/spe2017-CIlect-kf.pdf \
	multistate/multistate.pdf


##inpdf = $(FILEINCLUDES:.=.pdf)
scaledpdf = $(PDFINCLUDES:.pdf=-scaled.pdf)
3x1pdf = $(PDFINCLUDES:.pdf=-3x1.pdf)

SRCDIR   = lectures
BUILDDIR = build-lectures

all: 3x1; $(MAKE) -C ${BUILDDIR} $(MAIN).pdf

$(MAIN).pdf: $(3x1pdf)
	pdfjam --pagecommand '{\thispagestyle{plain}}' --preamble '\footskip 3.1cm' --fitpaper 'true' --rotateoversize 'true' --suffix joined --outfile $@ $^
	#pdfjoin $^ -o $@ 

%-scaled.pdf: %.pdf 
	pdfjam --papersize '{5.04in,3.78in}' --outfile $@ $<
	##pdfjam --papersize '{5.04in,3.78in}' --suffix 'scaled' $< 

%-3x1.pdf: %-scaled.pdf 
	pdfjam-slides3up --outfile $@ $<

scale: builddir; $(MAKE) -C ${BUILDDIR} $(scaledpdf) 

3x1: scale; $(MAKE) -C ${BUILDDIR} $(3x1pdf) 

view: all; evince $(MAIN).pdf & 

.PHONY: clean builddir 

builddir:
	mkdir -p ${BUILDDIR} && cp -r $(SRCDIR)/* ${BUILDDIR} 

clean:
	rm -rf ${BUILDDIR}
	