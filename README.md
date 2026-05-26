SPE
===

**Material for the course Statistical Practice in Epidemiology with R**

The 2026 edition runs **1–5 June 2026 in Tartu, Estonia**.

## Where the course material lives

| Directory | What is in it |
|---|---|
| [`pracs-book/`](pracs-book/) | The practicals, as R Markdown sources rendered to a `bookdown` book (HTML, PDF, EPUB), in two variants: exercise and with-solutions. Faculty edit only the `*-e.rmd` files. |
| [`lectures/`](lectures/) | One sub-folder per lecture. Source files + the compiled `.pdf` that ships to students. Each lecturer maintains their own folder. |
| [`adm/`](adm/) | Course timetable ([`prog.tex`](adm/prog.tex), [`SPE-R-timetable.md`](adm/SPE-R-timetable.md)) and historical post-mortems. |
| [`misc/`](misc/) | Faculty onboarding and reference docs (see below) plus a couple of helper R scripts. |

## Faculty: start here

- **[`misc/SPE_faculty_setup.md`](misc/SPE_faculty_setup.md)** — the single onboarding guide: install git on Windows, authenticate to GitHub, the daily `pull / edit / commit / push` loop, what to edit (and what *not* to edit), how to add solution-only content in a single source file, and how to build the book locally.
- [`misc/SPE_setup.md`](misc/SPE_setup.md) — installing R, RStudio and the `renv` package environment.
- [`misc/SPE_git-quick_start.md`](misc/SPE_git-quick_start.md) — the RStudio-based git workflow with screenshots.
- [`misc/compiling-practicals-book.md`](misc/compiling-practicals-book.md) — short reference on how `bookdown` assembles chapters and how to render one chapter while iterating.

## What CI does on every push to `master`

Two GitHub Actions workflows publish the material automatically:

1. **[`renderbook`](.github/workflows/deploy_bookdown.yml)** — renders the practicals `bookdown` in HTML + PDF + EPUB, both the exercise and the with-solutions versions, and pushes them to the [`gh-pages` branch](https://github.com/SPE-R/SPE/tree/gh-pages). Visible at <https://spe-r.github.io/SPE/SPE-R-2026-practicals/>.
2. **[`Compile and build SPE-R GitHub material`](.github/workflows/jekyll-gh-pages.yml)** — compiles the lecture handouts, extracts the R solution scripts, builds the data and material zips, and pushes them to the [`gh-spe-material` branch](https://github.com/SPE-R/SPE/tree/gh-spe-material).

The companion repo [`SPE-R.github.io`](https://github.com/SPE-R/SPE-R.github.io/) (the course landing page at <https://spe-r.github.io/>) links to the artifacts produced by both workflows.
