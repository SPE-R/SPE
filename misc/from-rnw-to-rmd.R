# install.packages('mdsr')

Rnw2Rmd_spe <-
  function (path, new_path = NULL) {
    if (is.null(new_path)) {
      new_path <- path %>% gsub(".Rnw", ".Rmd", .) %>% gsub(".tex", ".Rmd", .) %>% fs::fs_path()
    }
    x <- readLines(path)
    x <- gsub("(``)(.*)('')", "*\\2*", x)
    
    x <- gsub("(<<)(.*)(>>=)", "```{r \\2}", x)
    x <- gsub("^@.*", "```", x)
    x <- gsub("(\\\\Sexpr\\{)([^\\}]+)(\\})", "`r \\2`", x)
    x <- gsub("(\\\\chapter\\{)([^\\}]+)(\\})", "# \\2", x)
    x <- gsub("(\\\\section\\{)([^\\}]+)(\\})", "## \\2", x)
    x <- gsub("(\\\\subsection\\{)([^\\}]+)(\\})", "### \\2", x)
    x <- gsub("(\\\\subsubsection\\{)([^\\}]+)(\\})", "#### \\2", x)
    x <- gsub("(\\\\citep\\{)([^\\}]+)(\\})", "[@\\2]", x)
    x <- gsub("(\\\\cite\\{)([^\\}]+)(\\})", "@\\2", x)
    x <- gsub("(\\\\ref\\{)([^\\}]+)(\\})", "\\\\@ref(\\2)", x)
    x <- gsub("(\\\\label\\{)([^\\}]+)(\\})", "{#\\2}", x)
    x <- gsub("(\\\\index\\{)([^\\}]+)(\\})(\\{)([^\\}]+)(\\})\\%",
              "\\\\index{\\2}{\\5}",
              x)
    x <- gsub("\\\\item", "- ", x)
    x <- gsub("(\\\\emph\\{)([^\\}]+)(\\})", "*\\2*", x)
    x <- gsub("(\\\\textit\\{)([^\\}]+)(\\})", "*\\2*", x)
    x <- gsub("(\\\\textbf\\{)([^\\}]+)(\\})", "**\\2**", x)
    x <- gsub("(\\\\textsf\\{)([^\\}]+)(\\})", "`\\2`", x)
    x <- gsub("(\\\\texttt\\{)([^\\}]+)(\\})", "`\\2`", x)
    x <- gsub("(\\\\href\\{)([^\\}]+)(\\})(\\{)([^\\}]+)(\\})",
              "[\\5](\\2)",
              x)
    x <- gsub("(\\\\url\\{)([^\\}]+)(\\})", "(\\2)", x)
    
    x <- gsub("\\\\begin\\{verbatim\\}", "```{r, eval = FALSE}", x)
    x <- gsub("\\\\end\\{verbatim\\}", "```", x)
    
    x <- gsub("\\{\\\\tt ([a-zA-Z0-9. _()=]*)\\}", "`\\1`", x, perl = TRUE)
    x <- gsub("\\{\\\\em ([a-zA-Z0-9. _()=]*)\\}", "*\\1*", x, perl = TRUE)
    # x <- gsub("\\\\verb\\+(.*)(\\})\\+", "`\\1`", x)
    x <- gsub("\\\\verb\\+(.*)\\+", "`\\1`", x)
    
    x <- gsub(
      "(\\\\SweaveOpts\\{)([^\\}]+)(\\})",
      "```{r, include=FALSE}\nknitr::opts_chunk$set(\\2)\n```",
      x
    )
    
    x <- gsub("\\\\begin\\{itemize\\}", "", x)
    x <- gsub("\\\\end\\{itemize\\}", "", x)
    x <- gsub("\\\\begin\\{enumerate\\}.*", "", x)
    x <- gsub("\\\\end\\{enumerate\\}", "", x)
    
    
    
    ## spe-r specific options
    x <- gsub("results(| )=(| )hide", "results='hide'", x)
    x <- gsub("results=verbatim(|,)", "", x)
    x <- gsub("prefix.string=(.*)( |\\}|\\))",
              "prefix.string='\\1'\\2",
              x)
    # x <- gsub("prefix.string=./graph/basic", "prefix.string='./graph/basic'", x)
    # x <- gsub("prefix.string=./graph/causal", "prefix.string='./graph/causal'", x)
    # x <- gsub("prefix.string=./graph/causInf2", "prefix.string='./graph/causInf2'", x)
    
    # x <- gsub("%\\\\begin\\{exercise\\}", '<div class="noteBoxes type1">', x)
    # x <- gsub("%\\\\end\\{exercise\\}", '</div>', x)
    x <- gsub("%\\\\begin\\{exercise\\}", '---', x)
    x <- gsub("%\\\\end\\{exercise\\}", '---', x)
    
    writeLines(x, new_path)
  }



# xx <- "SweaveOpts{results=verbatim,keep.source=TRUE,include=FALSE,eps=FALSE,prefix.string=./graph/causInf2}"
# xx <- "knitr::opts_chunk$set(results='hide', prefix.string=./graph/basic)"
# gsub("prefix.string=(.*)( |\\}|\\))", "prefix.string='\\1'\\2", xx)
#
# xx <- "knitr::opts_chunk$set(results=verbatim,keep.source=TRUE,include=FALSE,eps=FALSE,prefix.string='./graph/cont-eff')"
# gsub("results=verbatim(|,)", "", xx)


file.copy('pracs/data',
          'pracs-rmd',
          recursive = TRUE,
          overwrite = TRUE)
rnw.files <- list.files('pracs', '.rnw', full.names = TRUE)

length(rnw.files)
f.in <- rnw.files[5]

which(rnw.files == f.in)

dir.create('pracs-rmd/graph',
           showWarnings = FALSE,
           recursive = TRUE)
dir.create('pracs-html/graph',
           showWarnings = FALSE,
           recursive = TRUE)
for (f.in in rnw.files[30:length(rnw.files)]) {
  f.out <- file.path('pracs-rmd',
                     basename(f.in) |> stringr::str_replace('.rnw$', '.rmd'))
  cat('\nconverting', f.in, 'into', f.out)
  Rnw2Rmd_spe(f.in, f.out)
  rmarkdown::render(input = f.out, output_dir = 'pracs-html')
}

dir.create('pracs-rmd-edit')
file.copy(
  from = list.files('pracs-rmd', full.names = TRUE),
  'pracs-rmd-edit',
  overwrite = FALSE,
  recursive = TRUE
)

# dir.create('pracs-book')
# file.copy('pracs/data', 'pracs-book', recursive = TRUE, overwrite = TRUE)
# bookdown::create_gitbook('pracs-rmd-edit/')
# file.copy(list.files('pracs-rmd-edit/', pattern = '-e.rmd', full.names = TRUE), to = 'pracs-book')

# tinytex::reinstall_tinytex(repository = "illinois")

## styler
styler::style_dir('pracs-book', scope = "tokens")


unlink('pracs-book/_book/', recursive = TRUE)
unlink('pracs-book/_bookdown_files/', recursive = TRUE)
unlink('pracs-book/_main_files/', recursive = TRUE)
bookdown::render_book('pracs-book/', 'bookdown::gitbook')
bookdown::render_book('pracs-book/', 'bookdown::pdf_book')
bookdown::render_book('pracs-book/', 'bookdown::epub_book')
