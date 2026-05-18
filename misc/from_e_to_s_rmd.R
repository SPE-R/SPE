# file.in <- 'pracs-book/basic-e.rmd'
# file.out <- 'pracs-book/basic-s.rmd'

## Files whose -s.rmd is hand-maintained and must NOT be auto-regenerated.
## Listed for defense-in-depth even though we also exclude them from files.in.
PROTECTED_S_RMD <- c("ggplot2-s.rmd")

## function to (re)generate the solution version of a practical from the
## exercise version. ALWAYS overwrites the output file -- this is the
## intended behaviour: edits to xxx-e.rmd should propagate to xxx-s.rmd
## without the developer having to remember to delete the latter.
## The PROTECTED_S_RMD list above is the escape hatch for files whose
## solutions are written by hand rather than mechanically derived.
from_e_to_s_rmd <-
  function(file.in, file.out){
    if (basename(file.out) %in% PROTECTED_S_RMD) {
      message(file.out, ' is protected (hand-maintained); not regenerated.')
      return(file.out)
    }
    cmd.in <- cmd.out <- readLines(file.in)
    ## detect the line where chunk options are set
    opt.line.in <- which(stringr::str_detect(cmd.in, stringr::fixed('opts_chunk$set'))) |> head(1)
    ## replace results = 'hide' by results = 'markup'
    cmd.out[opt.line.in] <-
      cmd.in[opt.line.in] |>
      stringr::str_replace('results( {0,2})=( {0,2})\"hide\"', 'results = \"markup\"')
    ## write the solution file (overwrites if it already exists)
    writeLines(cmd.out, con = file.out)
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
    ## "ggplot2-e.rmd"  -- its -s.rmd is hand-maintained; do not regenerate
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
