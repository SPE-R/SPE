## ---
## SPE practicals complilation
## 2018-03-26
## ---

.SUFFIXES: .tex .pdf .rnw .R

## The master file
MAIN = pracs

## The rnw depencencies
RNWINCLUDES = basic-e dinput-e tab-e graph-intro-e simulation-e rates-rrrd-e logistic-e effects-e cont-eff-e \
	graphics-e oral-e DMDK-e causal-e occoh-caco-e renal-e tab-s graph-intro-s simulation-s rates-rrrd-s \
	logistic-s effects-s cont-eff-s graphics-s oral-s DMDK-s causal-s occoh-caco-s renal-s

TEX = $(RNWINCLUDES:=.tex)
RFILES = $(RNWINCLUDES:=.R)
RNWFILES = $(INCLUDES:=.rnw)

all: $(MAIN).pdf
$(MAIN).pdf: $(TEX) $(MAIN).tex

R: $(RFILES)

view: all
	evince $(MAIN).pdf &
  
.rnw.R:
	R CMD Stangle $<
  
.rnw.tex:
	R CMD Sweave $<
  
.tex.pdf:
	latexmk -pdf -pv $<
  
clean:
	rm -fv $(MAIN).pdf $(TEX) $(RFILES)
	rm -fv *.aux *.dvi *.log *.toc *.bak *~ *.blg *.bbl *.lot *.lof
	rm -fv *.nav *.snm *.out *.pyc *.vrb
	rm -fv Rplots.pdf *.RData
	latexmk -C

