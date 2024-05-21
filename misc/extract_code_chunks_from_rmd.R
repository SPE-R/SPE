## get the -e.rmd and create the -s.rmd file if needed
source('misc/from_e_to_s_rmd.R')

for(f_ in file.path('pracs-book', files.out)) {
  knitr::purl(f_, output = stringr::str_replace(f_, '.rmd$|.Rmd$', '.R'))
}
