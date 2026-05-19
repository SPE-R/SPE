# Unused practical files

This directory contains practical files that are not part of the active
SPE-R practicals book build. They are kept here (rather than deleted) so
they can be reintegrated quickly if needed in a future edition.

## What is here

- `graphics-e.rmd` — older graphics practical. Superseded in the active
  build by `graph-intro-e.rmd` and `ggplot2-e.rmd`.
- `simulation-e.rmd` — never referenced by `_bookdown.yml`. Likely a draft
  that was never finished.
- `index-s.Rmd` — older "with solutions" version of the book front
  matter. Its subtitle/description difference is now encoded as inline
  R in `pracs-book/index.Rmd`, dispatched by the `SPE_SOLUTIONS` env
  var, so the same `index.Rmd` serves both books and bookdown can name
  the first output file `index.html` (which it only does when the
  source is literally named `index.Rmd`).

## How to reintegrate a file

1. Move the file back to `pracs-book/`:

   ```bash
   git mv pracs-book/_unused/<file> pracs-book/
   ```

2. Add its filename to the `rmd_files:` list in
   [`pracs-book/_bookdown.yml`](../_bookdown.yml) (and
   [`_bookdown-sol.yml`](../_bookdown-sol.yml) if it is also part of the
   solutions book).

3. If it is an `-e.rmd` whose `-s.rmd` should be auto-generated, also add
   it to the `files.in` list in
   [`misc/from_e_to_s_rmd.R`](../../misc/from_e_to_s_rmd.R).
