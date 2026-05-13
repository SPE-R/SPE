## ---
## Local rendering helpers for the SPE-R practicals bookdown.
## Run from the repo root: `make -f pracs-book/Makefile <target>`
## ---

SHELL = /bin/sh

RSCRIPT  = Rscript -e
ALLOWDUP = options(knitr.duplicate.label = "allow")
BOOK_DIR = pracs-book

.PHONY: help html pdf epub all html-sol pdf-sol epub-sol all-sol \
        solutions preview restore clean

help:
	@echo "Targets (run from repo root, e.g. 'make -f pracs-book/Makefile html'):"
	@echo "  html        Render HTML book (gitbook) - fastest, no LaTeX needed"
	@echo "  pdf         Render PDF book (needs TinyTeX or system TeX Live)"
	@echo "  epub        Render EPUB book"
	@echo "  all         html + pdf + epub"
	@echo "  html-sol    HTML book with solutions"
	@echo "  pdf-sol     PDF book with solutions"
	@echo "  epub-sol    EPUB book with solutions"
	@echo "  all-sol     all + html-sol + pdf-sol + epub-sol"
	@echo "  solutions   Generate missing -s.rmd files from -e.rmd files"
	@echo "  preview     Preview one chapter: make ... preview CHAPTER=basic-e.rmd"
	@echo "  restore     renv::restore() to install/update R packages"
	@echo "  clean       Remove generated book output directories"

html:
	$(RSCRIPT) '$(ALLOWDUP); bookdown::render_book("$(BOOK_DIR)/", "bookdown::gitbook")'

pdf:
	$(RSCRIPT) '$(ALLOWDUP); bookdown::render_book("$(BOOK_DIR)/", "bookdown::pdf_book")'

epub:
	$(RSCRIPT) '$(ALLOWDUP); bookdown::render_book("$(BOOK_DIR)/", "bookdown::epub_book")'

all: html pdf epub

solutions:
	$(RSCRIPT) 'source("misc/from_e_to_s_rmd.R")'

html-sol: solutions
	$(RSCRIPT) '$(ALLOWDUP); bookdown::render_book("$(BOOK_DIR)/", "bookdown::gitbook", new_session = TRUE, config_file = "_bookdown-sol.yml")'

pdf-sol: solutions
	$(RSCRIPT) '$(ALLOWDUP); bookdown::render_book("$(BOOK_DIR)/", "bookdown::pdf_book", new_session = TRUE, config_file = "_bookdown-sol.yml")'

epub-sol: solutions
	$(RSCRIPT) '$(ALLOWDUP); bookdown::render_book("$(BOOK_DIR)/", "bookdown::epub_book", new_session = TRUE, config_file = "_bookdown-sol.yml")'

all-sol: all html-sol pdf-sol epub-sol

preview:
	@if [ -z "$(CHAPTER)" ]; then \
	  echo "Usage: make -f pracs-book/Makefile preview CHAPTER=<file>"; \
	  echo "  e.g.: make -f pracs-book/Makefile preview CHAPTER=basic-e.rmd"; \
	  exit 1; \
	fi
	$(RSCRIPT) 'bookdown::preview_chapter("$(BOOK_DIR)/$(CHAPTER)")'

restore:
	$(RSCRIPT) 'renv::restore()'

clean:
	rm -rf $(BOOK_DIR)/SPE-R-*-practicals $(BOOK_DIR)/SPE-R-*-practicals-with-solutions $(BOOK_DIR)/_book $(BOOK_DIR)/_bookdown_files
	rm -f $(BOOK_DIR)/SPE-R-*-practicals.Rmd $(BOOK_DIR)/SPE-R-*-practicals-with-solutions.Rmd
