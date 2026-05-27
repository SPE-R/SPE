SPE-R faculty setup guide
=========================

This guide walks SPE-R faculty through getting the [SPE repository](https://github.com/SPE-R/SPE)
set up on a Windows machine, the everyday `git` actions you need, **which files
to edit** for the 2026 Tartu edition, and how to build the practicals book
locally before pushing.

For step-by-step screenshots of the RStudio workflow, see
[`SPE_git-quick_start.md`](SPE_git-quick_start.md). For the R/`renv` setup, see
[`SPE_setup.md`](SPE_setup.md).

If you get stuck at any step, write to <georgesd@iarc.who.int>.

---

## Table of contents

- [1. One-time setup (Windows)](#1-one-time-setup-windows)
  - [1.1 Install Git Portable](#11-install-git-portable)
  - [1.2 Install R, RStudio, and RTools](#12-install-r-rstudio-and-rtools)
  - [1.3 Configure RStudio to use Git and the Bash terminal](#13-configure-rstudio-to-use-git-and-the-bash-terminal)
  - [1.4 Tell git who you are](#14-tell-git-who-you-are)
  - [1.5 Authenticate to GitHub (pick one)](#15-authenticate-to-github-pick-one)
  - [1.6 Clone the SPE repository](#16-clone-the-spe-repository)
- [2. Daily git workflow](#2-daily-git-workflow)
- [3. What to edit (and what NOT to edit)](#3-what-to-edit-and-what-not-to-edit)
- [4. Build the book locally](#4-build-the-book-locally)
- [5. After you push: what happens](#5-after-you-push-what-happens)

---

## 1. One-time setup (Windows)

### 1.1 Install Git Portable

The Portable edition needs no installation and no admin rights:

1. Go to <https://git-scm.com/download/win> and download the file labelled
   **Portable ("thumbdrive edition") 64-bit** (e.g. `PortableGit-2.XX.X-64-bit.7z.exe`).
2. Run the file — it is a self-extracting archive. Pick a location you have
   write access to, e.g. `C:\Users\<yourname>\PortableGit\`.
3. Verify by double-clicking `<PortableGit>\git-bash.exe`. A terminal opens;
   type `git --version` and press Enter — you should see the installed
   version printed.

Wherever this guide says "in Git Bash", you can also use the RStudio Terminal
once you have set it up in step 1.3 below.

### 1.2 Install R, RStudio, and RTools

- Install the latest **R** from <https://cran.r-project.org/bin/windows/base/>.
- Install **RStudio Desktop** from <https://posit.co/download/rstudio-desktop/>.
- Install **RTools** from <https://cran.r-project.org/bin/windows/Rtools/>.
  RTools ships the `make.exe` that the local book Makefile needs, plus the
  C/C++/Fortran toolchain that some R packages compile from source. Match
  the RTools version to your R version (e.g. RTools 4.4 for R 4.4.x).
- Once you have cloned the repo (step 1.6), follow [`SPE_setup.md`](SPE_setup.md)
  to restore the `renv` environment.

### 1.3 Configure RStudio to use Git and the Bash terminal

So that the RStudio Git pane and the RStudio Terminal both work with the
PortableGit you just installed:

1. **Tools → Global Options → Git/SVN**:
   - Tick *Enable version control interface for RStudio projects*.
   - *Git executable*: browse to `<PortableGit>\bin\git.exe`
     (or `<PortableGit>\cmd\git.exe` — either works).
2. **Tools → Global Options → Terminal**:
   - *New terminals open with*: choose **Custom**.
   - *Custom shell binary*: `<PortableGit>\bin\bash.exe`.
   - *Custom shell options*: `--login -i`.
3. Click **OK** and restart RStudio.

Open a new Terminal in RStudio (Terminal pane → ＋), and verify everything is
wired up:

```bash
git  --version    # should print the PortableGit version
make --version    # should print GNU Make from RTools
bash --version    # should print the PortableGit bash version
```

If `make` reports "command not found", RStudio has not picked up RTools on
`PATH`. The simplest fix is to re-run the RTools installer (it has an option
near the end to add the toolchain to the Windows PATH), then restart RStudio.

From now on the `git` and `make` commands shown in this guide can be typed
directly into the RStudio Terminal — no need to leave the IDE.

### 1.4 Tell git who you are

In Git Bash, run **once**:

```bash
git config --global user.name  "Your Full Name"
git config --global user.email "you@example.org"      # use the email tied to your GitHub account
git config --global init.defaultBranch master
```

### 1.5 Authenticate to GitHub (pick one)

GitHub no longer accepts password authentication. You need either an **SSH
key** (recommended for long-lived setups) or a **personal access token (PAT)**
(easier for first-time users).

#### Option A — SSH key (recommended)

In Git Bash:

```bash
ssh-keygen -t ed25519 -C "you@example.org"
# Press Enter to accept the default file location.
# Optionally set a passphrase.

# Start the ssh-agent so it remembers the key:
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy the public key to your clipboard:
clip < ~/.ssh/id_ed25519.pub
```

Then in your browser:

1. Go to <https://github.com/settings/keys>
2. Click **New SSH key**
3. Title: something memorable (e.g. *Lab laptop 2026*)
4. Paste the key (already in your clipboard) and click **Add SSH key**

Test it:

```bash
ssh -T git@github.com
# expected: "Hi <username>! You've successfully authenticated..."
```

When you clone in step 1.6, use the **SSH URL** form (`git@github.com:SPE-R/SPE.git`).

#### Option B — Personal access token (PAT)

In R (e.g. inside RStudio):

```r
install.packages(c("usethis", "gitcreds"))   # if not already installed
usethis::create_github_token()
```

This opens the GitHub token creation page in your browser. Suggested settings:

- **Note**: *SPE-R 2026 token* (any memorable label)
- **Expiration**: *90 days* (you'll regenerate when it expires)
- **Scopes**: tick `repo`, `workflow`

Click **Generate token**, **copy the token immediately** (you won't see it again),
then in R:

```r
gitcreds::gitcreds_set()
# paste the token when prompted
```

When you clone in step 1.6, use the **HTTPS URL** form (`https://github.com/SPE-R/SPE.git`).

> **Note:** You need to be a member of the [SPE-R GitHub organization](https://github.com/orgs/SPE-R/people)
> to push. If you aren't yet, email <georgesd@iarc.who.int>.

### 1.6 Clone the SPE repository

In Git Bash, pick where you want the repo on disk and run:

```bash
cd /c/Users/<you>/Documents             # or wherever you keep code
git clone git@github.com:SPE-R/SPE.git  # SSH form (Option A)
# or:
git clone https://github.com/SPE-R/SPE.git   # HTTPS form (Option B, PAT)
cd SPE
```

(In RStudio: *File → New Project → Version Control → Git*, paste the URL,
choose a parent directory, *Create Project*.)

---

## 2. Daily git workflow

The everyday cycle is **pull → edit → commit → pull → push**.

```bash
git pull                              # 1. get the latest from GitHub before you start
# ... edit your files in RStudio or any editor ...
git status                            # 2. see what you've changed
git add adm/prog.tex pracs-book/your-chapter-e.rmd   # 3. stage specific files
git commit -m "Update Day 1 program for Tartu"        # 4. commit with a clear message
git pull                              # 5. pull again before pushing (avoids conflicts)
git push                              # 6. push your commits to GitHub
```

Same six steps in RStudio's *Git* tab: **Pull**, edit, tick the changed files,
**Commit** (write a message), then **Pull** again, then **Push**.

A few habits that will save you grief:

- **Pull before you start editing.** Always.
- **Commit small, focused chunks** (one logical change per commit) with
  descriptive messages — "Fix typo in causal inference section" beats
  "updates".
- **Pull just before pushing** in case someone else pushed while you were
  working. If git reports a conflict, RStudio will show you the differences;
  you pick which side to keep, then commit the resolution.
- **Push at least once a day** so nothing lives only on your laptop.

For more detail with screenshots see [`SPE_git-quick_start.md`](SPE_git-quick_start.md).

---

## 3. What to edit

| Path | What it is |
|---|---|
| `pracs-book/*-e.rmd` | **The practicals.** One R Markdown file per session. **This is the only file per chapter that you edit.** Both books (exercise and with-solutions) are rendered from this one source — see section 3.1 below. |
| `pracs-book/index.Rmd` | Book front matter: title, dates, authors. Rarely needs touching. |
| `adm/prog.tex` | The 2-page program (compiled to PDF). |
| `adm/SPE-R-timetable.md` | The detailed timetable with links (rendered to the website). |
| `lectures/<your-topic>/` | Your lecture slides — whatever source format you use — plus the compiled `.pdf` we ship to students. |

**Do NOT edit**:

| Path | Why |
|---|---|
| `pracs-book/*-s.rmd` | Auto-generated on every build from the matching `-e.rmd` by [`misc/from_e_to_s_rmd.R`](from_e_to_s_rmd.R). The file is git-ignored; any local copy is regenerated. |
| `pracs-book/SPE-R-*-practicals*.Rmd` | Auto-generated merged book file. If you see one in the directory, it is a leftover from a failed render — run `make -f pracs-book/Makefile clean` before retrying. |
| `pracs-book/SPE-R-*-practicals*/` | Built book output (git-ignored). |
| `pracs-book/_unused/` | Archived chapters and front-matter, kept for reference. |
| `renv/`, `renv.lock` | R package environment. Touch only via `renv::snapshot()` and only when you have deliberately added a package. |
| `.github/workflows/` | CI definitions. Coordinate with Damien before changing. |

### 3.1 How exercise and solution content differ — in one source file

You write ONE `-e.rmd` per practical. The build produces TWO books from
the same source:

- the **exercise book** — what students get during the course;
- the **with-solutions book** — extra explanations and full code, shipped alongside.

The differentiation is driven by an `SPE_SOLUTIONS` env var, set automatically
by CI and the local Makefile. By default, code chunk **output** (text and
figures) is hidden in the exercise book and shown in the with-solutions book —
you do not have to do anything to get that. For finer control, four primitives
let you mark content as exercise-only, solution-only, or both:

| What you want | How to write it |
|---|---|
| Prose / code shown in **both** books | Just write it. |
| **Inline** prose in one book only | `` `r solution("Only in solutions.")` `` / `` `r exercise("Only in exercises.")` `` |
| A **multi-line** prose block in one book only | `::: solution` …content… `:::` &nbsp;&nbsp; (or `::: exercise`) |
| A **whole code chunk** in one book only | ` ```{r, solution = TRUE} ` &nbsp;&nbsp; (or `exercise = TRUE`) |
| The **same code** but evaluated only in the solutions | ` ```{r, eval = spe_solutions()} ` |

A self-contained example combining most of them:

````markdown
Compute the rate.

`r exercise("Hint: use the rate variable from the dataset.")`

```{r, exercise = TRUE, eval = FALSE}
mean_rate <- ___          # fill in the blank
```

```{r, solution = TRUE}
mean_rate <- mean(rate)
mean_rate
```

::: solution
**Bonus**: in epidemiological practice we usually also report a 95% CI.
Compute it with `epitools::pois.exact()` and compare to the asymptotic
interval — they differ for small denominators.
:::
````

The implementation lives in [`pracs-book/_common.R`](../pracs-book/_common.R)
(R helpers and chunk hooks) and
[`pracs-book/_solutions.lua`](../pracs-book/_solutions.lua) (a pandoc filter
for the fenced `::: solution` / `::: exercise` divs). You should not need to
touch either while writing a practical.

> **Legacy** — a handful of older chapters do not yet use the primitives
> above. For those, the `-s.rmd` file is generated mechanically from the
> matching `-e.rmd` (basically `results = "hide"` → `results = "markup"`),
> with no room for solution-only content. When you next touch one of those
> chapters and want to add extras to the solutions, migrate it to the
> single-source pattern: see [`pracs-book/ggplot2-e.rmd`](../pracs-book/ggplot2-e.rmd)
> as a worked example.

---

## 4. Build the book locally

Before you push, build the book locally to make sure your edits render. From
the **repo root** (i.e. inside `SPE/`):

```bash
make -f pracs-book/Makefile help          # list all targets
make -f pracs-book/Makefile restore       # one-time: install R packages from renv.lock
make -f pracs-book/Makefile preview CHAPTER=basic-e.rmd     # fast: render one chapter
make -f pracs-book/Makefile html          # render the full HTML book (no LaTeX needed)
make -f pracs-book/Makefile pdf           # render the full PDF book (needs TinyTeX)
make -f pracs-book/Makefile html-sol      # HTML book WITH solutions
make -f pracs-book/Makefile pdf-sol       # PDF book WITH solutions
make -f pracs-book/Makefile clean         # wipe build outputs (do this if a render fails midway)
```

The HTML build needs no LaTeX and is fastest — use it for everyday checking.
Use `pdf` / `pdf-sol` before pushing if your edits touch math, figures, or
page-layout-sensitive bits.

If `make ... html` fails midway, **always run `make ... clean` before
retrying** — bookdown leaves a half-written merged file behind that causes
subsequent renders to use stale content.

> Don't have `make` on Windows? You can either install it via Git for
> Windows (it includes a `make.exe` if you tick the optional tools) or run
> the equivalent R commands directly:
>
> ```r
> options(knitr.duplicate.label = "allow")
> bookdown::render_book("pracs-book/", "bookdown::gitbook")            # html
> bookdown::render_book("pracs-book/", "bookdown::pdf_book")           # pdf
> ```

---

## 5. After you push: what happens

A push to `master` automatically triggers two GitHub Actions workflows:

1. **`renderbook`** — builds the practicals book in HTML + PDF + EPUB (both
   exercise and with-solutions versions) and deploys to the `gh-pages` branch.
   Visible at <https://spe-r.github.io/SPE/SPE-R-2026-practicals/>.
2. **`Compile and build SPE-R GitHub material`** — compiles the lecture
   handouts, extracts the R solution scripts, builds the data and material
   zips, and deploys to the `gh-spe-material` branch.

Both runs take 20–30 minutes. You can watch them at
<https://github.com/SPE-R/SPE/actions>. The course website at
<https://spe-r.github.io/> picks up the new artifacts automatically.

If a run fails, GitHub will email you. Most failures are content-related (a
broken R chunk, a missing package); a few are infrastructure-related (apt
mirror hiccups, blocked third-party actions). For the latter, ping Damien.
