Compiling SPE-R practicals book
===============================

This is a short reference about the structure of the practicals book and how
to render individual chapters. For the full faculty workflow (GitHub setup,
daily git actions, building the whole book locally, what to edit), see
[`SPE_faculty_setup.md`](SPE_faculty_setup.md).

## Where chapter order is defined

The book is assembled by `bookdown` from the files listed in
[`pracs-book/_bookdown.yml`](../pracs-book/_bookdown.yml) under the
`rmd_files:` key. The order in that list is the order chapters appear in the
book.

```yaml
rmd_files: [
  "index.Rmd",
  "basic-e.rmd", "dinput-e.rmd",
  "tidyverse-e.rmd", "tab-e.rmd", "graph-intro-e.rmd", "rates-rrrd-e.rmd",
  "effects-e.rmd", "cont-eff-e.rmd", "causal-e.rmd",
  "ggplot2-e.rmd", "oral-e.rmd", "DMDK-e.rmd", "occoh-caco-e.rmd",
  "causInf2-e.rmd", "renal-e.rmd"
]
```

If you add a new practical, drop the `.rmd` file in `pracs-book/` and add its
filename to that list at the position you want it to appear in. The
"with-solutions" book has its own list in
[`pracs-book/_bookdown-sol.yml`](../pracs-book/_bookdown-sol.yml) — keep both
lists in sync.

## Rendering a single chapter

While you're editing one practical, the fastest feedback loop is to render
just that one file. In RStudio, open the `.rmd` file and click **Knit** (use
the down-arrow next to it to pick HTML, PDF, or Word).

From the command line, equivalently:

```bash
make -f pracs-book/Makefile preview CHAPTER=basic-e.rmd
```

This produces a standalone preview of the chapter — useful for iterating on
your text and code chunks without paying the cost of a full book build.

## Rendering the full book

See [section 4 of the faculty setup guide](SPE_faculty_setup.md#4-build-the-book-locally)
for the `make` targets (`html`, `pdf`, `html-sol`, `pdf-sol`, `clean`).

**Important**: if a full render fails midway, run `make -f pracs-book/Makefile clean`
before retrying. Bookdown leaves a half-written merged `.Rmd` in the
`pracs-book/` directory after a failed run; subsequent renders pick that up
instead of rebuilding from your edited sources, which can be very confusing.
