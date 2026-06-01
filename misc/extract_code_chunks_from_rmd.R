## Extract the R code of each practical chapter into a `-s.R` file that ships
## in Rsolutions.zip. There are two kinds of chapter:
##
##  * LEGACY chapters keep a separate `xxx-e.rmd` / `xxx-s.rmd` pair. The
##    `-s.rmd` is auto-generated from the `-e.rmd` by from_e_to_s_rmd.R, then
##    purled to `xxx-s.R`.
##
##  * SINGLE-SOURCE chapters carry their solution-only content inside the one
##    `xxx-e.rmd`, behind the SPE_SOLUTIONS flag. We purl the `-e.rmd` directly
##    with the flag ON (and the _common.R chunk hooks loaded) and write the
##    result to `xxx-s.R`.
##
## In both cases the output is named `-s.R`, so the workflow step
## `cp pracs-book/*-s.R deploy/Rsolutions` collects them with no change.

library(knitr)

book_dir <- "pracs-book"

purl_to_R <- function(input, output) {
  knitr::purl(input, output = output, quiet = TRUE)
}

## --- LEGACY chapters ---------------------------------------------------------
## from_e_to_s_rmd.R defines `files.in` (the legacy `-e.rmd` chapters) and
## `files.out` (their `-s.rmd`), and writes the `-s.rmd` files as a side effect.
source("misc/from_e_to_s_rmd.R")
legacy_e <- files.in

for (f_ in file.path(book_dir, files.out)) {
  purl_to_R(f_, output = sub("\\.rmd$|\\.Rmd$", ".R", f_))
}

## --- SINGLE-SOURCE chapters --------------------------------------------------
## Derive the single-source list automatically: every `*-e.rmd` listed in
## _bookdown.yml that is NOT handled by the legacy pipeline above. This avoids
## maintaining the list in a second place.
yml_lines  <- readLines(file.path(book_dir, "_bookdown.yml"))
chapters_e <- stringr::str_match(yml_lines, '"([^"]*-e\\.rmd)"')[, 2]
chapters_e <- chapters_e[!is.na(chapters_e)]
singlesource_e <- setdiff(chapters_e, legacy_e)

## Render in "solutions" mode so that, via the _common.R opts_hooks,
## `solution = TRUE` chunks are kept and `exercise = TRUE` chunks are dropped.
Sys.setenv(SPE_SOLUTIONS = "1")
source(file.path(book_dir, "_common.R"))

for (f_ in file.path(book_dir, singlesource_e)) {
  purl_to_R(f_, output = sub("-e\\.rmd$", "-s.R", f_))
}
