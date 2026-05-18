# Shared knit-time helpers for the SPE-R practicals bookdown.
#
# Sourced once before each chapter is knit (via `before_chapter_script`
# in _bookdown.yml and _bookdown-sol.yml). The faculty-facing API is
# documented in misc/SPE_faculty_setup.md under "Solution-only content".
#
# Dispatch is driven by the SPE_SOLUTIONS environment variable:
#   "1" -> we are rendering the SOLUTIONS book
#   anything else (default) -> we are rendering the EXERCISE book
#
# The workflow (deploy_bookdown.yml) and the local Makefile both set
# SPE_SOLUTIONS appropriately before each render.

# Returns TRUE if we are currently rendering the solutions book.
spe_solutions <- function() {
  identical(Sys.getenv("SPE_SOLUTIONS", "0"), "1")
}

# Wraps INLINE markdown so it appears only in the solutions book.
# Usage in .rmd:  `r solution("This sentence appears only in solutions.")`
solution <- function(content) {
  if (spe_solutions()) knitr::asis_output(content) else knitr::asis_output("")
}

# Wraps INLINE markdown so it appears only in the exercise book.
# Usage in .rmd:  `r exercise("Fill in the blank below.")`
exercise <- function(content) {
  if (!spe_solutions()) knitr::asis_output(content) else knitr::asis_output("")
}

# Chunk option `solution = TRUE`: include the chunk only in the solutions book.
# Chunk option `exercise = TRUE`: include the chunk only in the exercise book.
# When excluded, the chunk is neither evaluated nor rendered.
knitr::opts_hooks$set(
  solution = function(options) {
    if (isTRUE(options$solution) && !spe_solutions()) {
      options$include <- FALSE
      options$eval    <- FALSE
      options$echo    <- FALSE
    }
    options
  },
  exercise = function(options) {
    if (isTRUE(options$exercise) && spe_solutions()) {
      options$include <- FALSE
      options$eval    <- FALSE
      options$echo    <- FALSE
    }
    options
  }
)

# Multi-line PROSE blocks are handled by the companion pandoc lua filter
# pracs-book/_solutions.lua, which dispatches on the same SPE_SOLUTIONS
# env var to strip or keep ::: solution and ::: exercise fenced divs.
