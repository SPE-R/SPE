# file.in <- 'pracs-book/basic-e.rmd'
# file.out <- 'pracs-book/basic-s.rmd'

## function to convert exercise to solution version of the practicals
## this function will not overwrite the output file if not exists
from_e_to_s_rmd <-
  function(file.in, file.out){
    if(file.exists(file.out)) {
      warning(paste0(file.out, ' already exixsts and will not be updated.'))
    } else {
      cmd.in <- cmd.out <- readLines(file.in)
      ## detect the line where chunk options are set
      opt.line.in <- which(sringr::str_detect(cmd.in, sringr::fixed('opts_chunk$set'))) |> head(1)
      ## replace results = 'hide' by results = 'markup'
      cmd.out[opt.line.in] <- 
        cmd.in[opt.line.in] |> 
        sringr::str_replace('results( {0,2})=( {0,2})\"hide\"', 'results = \"markup\"')
      ## save the new file
      writeLines(cmd.out, con = file.out)
    }
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
    "graphics-e.rmd",
    "oral-e.rmd",
    "DMDK-e.rmd",
    "occoh-caco-e.rmd",
    "causInf2-e.rmd",
    "renal-e.rmd"
  )

files.out <- sringr::str_replace(files.in, "-e.rmd", "-s.rmd")

for(i in seq_along(files.in)){
  from_e_to_s_rmd(
    file.path('pracs-book', files.in[i]),
    file.path('pracs-book', files.out[i])
  )
}
