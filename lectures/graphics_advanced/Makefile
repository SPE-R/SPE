MainSrc = $(shell grep -l '^\\documentclass.*beamer' *tex)
pdffiles = $(MainSrc:.tex=.pdf)
handoutfiles = $(MainSrc:.tex=-handout.pdf)
4upfiles = $(MainSrc:.tex=-2x2.pdf)

.SUFFIXES = .tex .pdf -presentation.pdf -2x2.pdf
all: presentation handout 4up
presentation: $(pdffiles)
handout: $(handoutfiles)
4up: $(4upfiles)
%.pdf: %.tex
	TEXINPUTS=${HOME}/texinputs: pdflatex $<
	TEXINPUTS=${HOME}/texinputs: pdflatex $<
%-handout.pdf: %.tex
	TEXINPUTS=${HOME}/texinputs: pdflatex handouts.tex \\input $<
	TEXINPUTS=${HOME}/texinputs: pdflatex handouts.tex \\input $<
	mv handouts.pdf $@
%-2x2.pdf: %-handout.pdf
	pdfnup --nup 2x2 --landscape --outfile $@ $<
clean:
	rm -f *.vrb *.aux *.toc *.dvi *.log *.nav *.snm *~ *.out
realclean: clean
	rm -f $(pdffiles) $(handoutfiles) $(4upfiles)
