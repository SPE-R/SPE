SPE-R faculty guide
===================

The single onboarding document for SPE-R faculty: get the
[SPE repository](https://github.com/SPE-R/SPE) running on your laptop,
learn the everyday `git` actions, and find your way around the practicals
book sources for the 2026 Tartu edition.

If you get stuck, write to <georgesd@iarc.who.int>.

---

## Table of contents

- [1. One-time setup](#1-one-time-setup)
  - [1.1 Install git](#11-install-git)
  - [1.2 Install R, RStudio, RTools](#12-install-r-rstudio-rtools)
  - [1.3 Configure RStudio to use git and the bash terminal](#13-configure-rstudio-to-use-git-and-the-bash-terminal)
  - [1.4 Authenticate to GitHub](#14-authenticate-to-github)
  - [1.5 Clone the repository and restore R packages](#15-clone-the-repository-and-restore-r-packages)
- [2. Daily git workflow](#2-daily-git-workflow)
- [3. What to edit](#3-what-to-edit)
  - [3.1 Exercise vs solution content in one file](#31-exercise-vs-solution-content-in-one-file)
- [4. Build and preview locally](#4-build-and-preview-locally)
- [5. What happens after you push](#5-what-happens-after-you-push)

---

## 1. One-time setup

### 1.1 Install git

**Windows** (no admin rights needed):

1. Download the **Portable** edition from <https://git-scm.com/download/win>
   (look for "Portable" — file named like `PortableGit-2.XX.X-64-bit.7z.exe`).
2. Run the file — it self-extracts. Pick a folder you have write access to,
   e.g. `C:\Users\<you>\PortableGit\`.
3. Verify by double-clicking `<PortableGit>\git-bash.exe` and typing
   `git --version`.

**macOS**: `brew install git`

**Linux**: `sudo apt install git` (Debian/Ubuntu) or your distribution's
equivalent.

### 1.2 Install R, RStudio, RTools

- **R**: <https://cran.r-project.org/bin/windows/base/>
- **RStudio Desktop**: <https://posit.co/download/rstudio-desktop/>
- **RTools** (Windows only): <https://cran.r-project.org/bin/windows/Rtools/>.
  Match the version to your R (e.g. RTools 4.4 for R 4.4.x). RTools ships
  `make.exe`, which the local book Makefile relies on, plus the toolchain
  needed to compile some R packages from source.

### 1.3 Configure RStudio to use git and the bash terminal

So that the Git pane and the Terminal both work from inside RStudio:

1. **Tools → Global Options → Git/SVN**:
   - Tick *Enable version control interface for RStudio projects*.
   - *Git executable*: browse to `<PortableGit>\bin\git.exe` (Windows).
     On macOS/Linux the default value is usually fine.
2. **Tools → Global Options → Terminal** (Windows only):
   - *New terminals open with*: **Custom**.
   - *Custom shell binary*: `<PortableGit>\bin\bash.exe`.
   - *Custom shell options*: `--login -i`.
3. Restart RStudio.

Open a new Terminal (Terminal pane → **+**) and verify:

```bash
git  --version
bash --version
make --version    # only if you installed RTools
```

Every `git` and `make` command in the rest of this guide can be typed
directly into the RStudio Terminal — no need to leave the IDE.

### 1.4 Authenticate to GitHub

GitHub no longer accepts password authentication. First tell git who you
are, then pick one of two auth methods.

```bash
git config --global user.name  "Your Full Name"
git config --global user.email "you@example.org"     # email tied to your GitHub account
git config --global init.defaultBranch master
```

> You must be a member of the [SPE-R organisation](https://github.com/orgs/SPE-R/people)
> to push. If you are not yet, email <georgesd@iarc.who.int>.

#### (a) SSH key — recommended for long-term use

```bash
ssh-keygen -t ed25519 -C "you@example.org"   # press Enter for defaults
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

clip < ~/.ssh/id_ed25519.pub                 # Windows
# macOS:  pbcopy < ~/.ssh/id_ed25519.pub
# Linux:  xclip -sel clip < ~/.ssh/id_ed25519.pub
```

Then in your browser: <https://github.com/settings/keys> → **New SSH key**
→ paste → **Add SSH key**. Test:

```bash
ssh -T git@github.com    # expected: "Hi <username>! You have successfully authenticated..."
```

For step 1.5, use the **SSH** clone URL: `git@github.com:SPE-R/SPE.git`.

#### (b) Personal access token (PAT) — easier for first-timers

In R:

```r
install.packages(c("usethis", "gitcreds"))
usethis::create_github_token()    # opens the GitHub token page in your browser
```

Tick scopes **`repo`** and **`workflow`**, click **Generate token**,
**copy it immediately** (you only see it once), then:

```r
gitcreds::gitcreds_set()          # paste the token when prompted
```

PATs expire (90 days by default); you'll need to regenerate when that
happens.

For step 1.5, use the **HTTPS** clone URL: `https://github.com/SPE-R/SPE.git`.

### 1.5 Clone the repository and restore R packages

In your terminal:

```bash
cd /c/Users/<you>/Documents             # Windows; macOS/Linux: cd ~/Documents
git clone git@github.com:SPE-R/SPE.git  # SSH (or HTTPS form per 1.4)
cd SPE
```

Then in RStudio: **File → Open Project in New Session...**, select the `SPE`
folder. In the R console:

```r
renv::restore()        # downloads and installs all R packages locked in renv.lock
```

This takes 10–30 minutes the first time (packages compile from source on
macOS/Linux; binary on Windows). Subsequent runs are seconds — packages
are cached.

---

## 2. Daily git workflow

The everyday cycle is **pull → edit → commit → pull → push**:

```bash
git pull                                 # 1. before you start
# ... edit files ...
git status                               # 2. see what changed
git add adm/prog.tex pracs-book/your-chapter-e.rmd      # 3. stage specific files
git commit -m "Update Day 1 program for Tartu"          # 4. commit with a clear message
git pull                                 # 5. again, just before pushing
git push                                 # 6. push to GitHub
```

Same six steps via RStudio's **Git** pane if you prefer: *Pull*, edit,
tick files, *Commit* (write a message), *Pull* again, *Push*.

Habits worth keeping:

- **Pull before you edit.** Always.
- **Commit small, descriptive chunks.** "Fix typo in causal inference" beats "updates".
- **Pull just before pushing** so you catch any conflicts early.
- **Push at least daily** so nothing important lives only on your laptop.

---

## 3. What to edit

| Path | What it is |
|---|---|
| `pracs-book/*-e.rmd` | **The practicals.** Edit only the `-e.rmd` files. Both books (exercise and with-solutions) are rendered from this single source — see section 3.1. |
| `pracs-book/index.Rmd` | Book front matter: title, dates, authors. Rarely needs touching. |
| `adm/prog.tex` | The 2-page program (compiled to PDF). |
| `adm/SPE-R-timetable.md` | The detailed timetable with links (rendered on the website). |
| `lectures/<your-topic>/` | Your lecture sources + the compiled `.pdf` shipped to students. |

**Do NOT edit**:

| Path | Why |
|---|---|
| `pracs-book/*-s.rmd` | Auto-generated on every build from the matching `-e.rmd`. Your edits are lost. |
| `pracs-book/SPE-R-*-practicals*.Rmd` | Auto-generated merged book file. If you see one in `pracs-book/`, run `make -f pracs-book/Makefile clean` (or delete it). |
| `pracs-book/SPE-R-*-practicals*/` | Built book output (git-ignored). |
| `pracs-book/_unused/` | Archived chapters, kept for reference. |
| `renv/`, `renv.lock` | R package environment. Touch only via `renv::snapshot()`. |
| `.github/workflows/` | CI definitions. Coordinate with Damien before changing. |

### 3.1 Exercise vs solution content in one file

You write ONE `-e.rmd` per practical. The build produces TWO books from
the same source:

- **exercise book** — what students get during the course;
- **with-solutions book** — extra explanations and full code, shipped alongside.

Dispatch is driven by an `SPE_SOLUTIONS` environment variable, set
automatically by CI and the Makefile. By default chunk **output** (text and
figures) is hidden in the exercise book and shown in the with-solutions
book — nothing to do.

For finer control, mark content as exercise-only, solution-only, or shared:

| What you want | How |
|---|---|
| Prose / code in **both** books | Just write it. |
| **Inline** prose, one book only | `` `r solution("Only in solutions.")` `` / `` `r exercise("Only in exercises.")` `` |
| **Multi-line** prose block, one book only | `::: solution` … `:::` &nbsp;&nbsp; (or `::: exercise`) |
| **Whole code chunk**, one book only | ` ```{r, solution = TRUE} ` &nbsp;&nbsp; (or `exercise = TRUE`) |
| **Same code**, run only in solutions | ` ```{r, eval = spe_solutions()} ` |

Self-contained example:

````markdown
Compute the rate.

`r exercise("Hint: use the rate variable.")`

```{r, exercise = TRUE, eval = FALSE}
mean_rate <- ___          # fill in the blank
```

```{r, solution = TRUE}
mean_rate <- mean(rate)
mean_rate
```

::: solution
**Bonus**: in epidemiological practice we usually also report a 95% CI.
Compute it with `epitools::pois.exact()`.
:::
````

See [`pracs-book/ggplot2-e.rmd`](../pracs-book/ggplot2-e.rmd) for a fully
migrated example. The implementation lives in
[`pracs-book/_common.R`](../pracs-book/_common.R) and
[`pracs-book/_solutions.lua`](../pracs-book/_solutions.lua); you should
not need to touch either.

> A handful of older chapters still use the legacy split `-e.rmd` /
> `-s.rmd` pair (the `-s.rmd` is auto-generated from `-e.rmd` and is the
> only thing that ships in the solutions book for those chapters). When
> you next touch one of those chapters and want to add solution-only
> extras, migrate it: drop the explicit `results = "hide"` from its
> setup chunk, then use the primitives above.

---

## 4. Build and preview locally

From the **repo root**.

### Preview one chapter (fast, ~1 min)

```r
setwd("pracs-book")

# Exercise version:
Sys.setenv(SPE_SOLUTIONS = "0")
bookdown::preview_chapter("oral-e.rmd")

# With-solutions version (migrated chapters only — e.g. ggplot2-e.rmd):
Sys.setenv(SPE_SOLUTIONS = "1")
bookdown::preview_chapter("ggplot2-e.rmd")

# With-solutions version (legacy chapters: preview the auto-generated -s.rmd):
source("../misc/from_e_to_s_rmd.R")    # (re)generate -s.rmd from -e.rmd
bookdown::preview_chapter("oral-s.rmd")
```

### Full book (10–25 min)

If you have `make` (RTools provides it on Windows):

```bash
make -f pracs-book/Makefile help        # list all targets
make -f pracs-book/Makefile html        # exercise book, HTML
make -f pracs-book/Makefile html-sol    # with-solutions book, HTML
make -f pracs-book/Makefile pdf         # PDF (needs TinyTeX)
make -f pracs-book/Makefile clean       # wipe build artefacts — always do this if a render fails midway
```

Without `make`, run the R equivalents from the repo root:

```r
options(knitr.duplicate.label = "allow")
Sys.setenv(SPE_SOLUTIONS = "0"); bookdown::render_book("pracs-book/", "bookdown::gitbook")
Sys.setenv(SPE_SOLUTIONS = "1"); bookdown::render_book("pracs-book/", "bookdown::gitbook",
                                                       config_file  = "_bookdown-sol.yml",
                                                       new_session  = TRUE)
```

Chapter order is defined in
[`pracs-book/_bookdown.yml`](../pracs-book/_bookdown.yml) (exercise book)
and [`pracs-book/_bookdown-sol.yml`](../pracs-book/_bookdown-sol.yml)
(with-solutions). If you add a new practical, update both lists.

---

## 5. What happens after you push

A push to `master` triggers two GitHub Actions workflows:

1. [`renderbook`](../.github/workflows/deploy_bookdown.yml) — renders the
   practicals book (HTML + PDF + EPUB, exercise and with-solutions) and
   deploys to the `gh-pages` branch. Visible at
   <https://spe-r.github.io/SPE/SPE-R-2026-practicals/>.
2. [`Compile and build SPE-R GitHub material`](../.github/workflows/jekyll-gh-pages.yml)
   — compiles the lecture handouts, extracts R solution scripts, builds the
   data and material zips, and deploys to the `gh-spe-material` branch.

Each run takes 20–30 minutes. Watch them at
<https://github.com/SPE-R/SPE/actions>. The course landing page at
<https://spe-r.github.io/> picks up the new artifacts automatically.

If a run fails, GitHub emails you. Most failures are content-related (a
broken R chunk, a missing package); a few are infrastructure-related
(blocked third-party actions, mirror hiccups). For the latter, ping
Damien.
