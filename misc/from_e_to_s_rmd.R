# file.in <- 'pracs-book/basic-e.rmd'
# file.out <- 'pracs-book/basic-s.rmd'

## Files whose -s.rmd is hand-maintained and must NOT be auto-regenerated.
## Listed for defense-in-depth even though we also exclude them from files.in.
## Currently empty: ggplot2 was migrated to the single-source mechanism (see
## misc/SPE_faculty_setup.md "Solution-only content").
PROTECTED_S_RMD <- character(0)

## function to (re)generate the solution version of a practical from the
## exercise version. ALWAYS overwrites the output file -- this is the
## intended behaviour: edits to xxx-e.rmd should propagate to xxx-s.rmd
## without the developer having to remember to delete the latter.
## The PROTECTED_S_RMD list above is the escape hatch for files whose
## solutions are written by hand rather than mechanically derived.
##
## Inside the chapter's opts_chunk$set(...) call we flip the two "hide"
## defaults to their "show" counterparts so the solutions book displays
## output text AND plots by default:
##
##   results  = "hide"  ->  results  = "markup"
##   fig.show = "hide"  ->  fig.show = "show"
##
## The opts_chunk$set call may span several lines (some chapters write
## it that way), so we scan from its opening line forward until the
## first line containing the matching ")" and apply the rewrites
## across that whole block.
##
## Per-chunk overrides like {r dagitty, fig.show="hide"} live in chunk
## headers, not in opts_chunk$set, and are intentionally NOT touched.
from_e_to_s_rmd <-
  function(file.in, file.out){
    if (basename(file.out) %in% PROTECTED_S_RMD) {
      message(file.out, ' is protected (hand-maintained); not regenerated.')
      return(file.out)
    }
    cmd <- readLines(file.in)

    start <- which(stringr::str_detect(cmd, stringr::fixed('opts_chunk$set')))
    if (length(start) > 0) {
      start <- start[1]
      end <- start
      while (end <= length(cmd) && !stringr::str_detect(cmd[end], '\\)')) {
        end <- end + 1
      }
      block <- cmd[start:end]
      block <- stringr::str_replace_all(
        block, 'results( {0,2})=( {0,2})"hide"', 'results = "markup"')
      block <- stringr::str_replace_all(
        block, 'fig\\.show( {0,2})=( {0,2})"hide"', 'fig.show = "show"')
      cmd[start:end] <- block
    }

    writeLines(cmd, con = file.out)
    file.out
  }

files.in <-
  c(
    "basic-e.rmd",
    "dinput-e.rmd",
    "tidyverse-e.rmd",
    "tab-e.rmd",
    "graph-intro-e.rmd",
    "rates-rrrd-e.rmd",
    "effects-e.rmd",
    "cont-eff-e.rmd",
    "causal-e.rmd",
    ## "graphics-e.rmd" -- moved to pracs-book/_unused/, no longer rendered
    ## "ggplot2-e.rmd"  -- migrated to single-source; included directly in
    ##                    both _bookdown.yml and _bookdown-sol.yml.
    "oral-e.rmd",
    "DMDK-e.rmd",
    "occoh-caco-e.rmd",
    "causInf2-e.rmd",
    "renal-e.rmd"
  )

files.out <- stringr::str_replace(files.in, "-e.rmd", "-s.rmd")

for(i in seq_along(files.in)){
  from_e_to_s_rmd(
    file.path('pracs-book', files.in[i]),
    file.path('pracs-book', files.out[i])
  )
}
