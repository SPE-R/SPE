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
  - [1.1 Install Git for Windows](#11-install-git-for-windows)
  - [1.2 Install R and RStudio](#12-install-r-and-rstudio)
  - [1.3 Tell git who you are](#13-tell-git-who-you-are)
  - [1.4 Authenticate to GitHub (pick one)](#14-authenticate-to-github-pick-one)
  - [1.5 Clone the SPE repository](#15-clone-the-spe-repository)
- [2. Daily git workflow](#2-daily-git-workflow)
- [3. What to edit (and what NOT to edit)](#3-what-to-edit-and-what-not-to-edit)
- [4. Build the book locally](#4-build-the-book-locally)
- [5. After you push: what happens](#5-after-you-push-what-happens)

---

## 1. One-time setup (Windows)

### 1.1 Install Git for Windows

Download and install Git for Windows from <https://git-scm.com/download/win>.
Accept the defaults; this gives you both **Git Bash** (a small Linux-style
terminal where the `git` commands shown below work) and integration with
RStudio.

Verify by opening **Git Bash** and typing:

```bash
git --version
```

### 1.2 Install R and RStudio

- Install the latest R from <https://cran.r-project.org/bin/windows/base/>.
- Install RStudio Desktop from <https://posit.co/download/rstudio-desktop/>.
- Once you've cloned the repo (step 1.5), follow [`SPE_setup.md`](SPE_setup.md)
  to restore the `renv` environment.

### 1.3 Tell git who you are

In Git Bash, run **once**:

```bash
git config --global user.name  "Your Full Name"
git config --global user.email "you@example.org"      # use the email tied to your GitHub account
git config --global init.defaultBranch master
```

### 1.4 Authenticate to GitHub (pick one)

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

When you clone in step 1.5, use the **SSH URL** form (`git@github.com:SPE-R/SPE.git`).

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

When you clone in step 1.5, use the **HTTPS URL** form (`https://github.com/SPE-R/SPE.git`).

> **Note:** You need to be a member of the [SPE-R GitHub organization](https://github.com/orgs/SPE-R/people)
> to push. If you aren't yet, email <georgesd@iarc.who.int>.

### 1.5 Clone the SPE repository

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

## 3. What to edit (and what NOT to edit)

### Edit these

| Path | What it is |
|---|---|
| `adm/prog.tex` | The 2-page program/timetable (compiled to PDF) |
| `adm/SPE-R-timetable.md` | The detailed timetable with links (rendered to the website) |
| `pracs-book/*.rmd` | **The practicals.** One file per session (e.g. `basic-e.rmd`, `causal-e.rmd`). These are R Markdown files — text + R code chunks. |
| `pracs-book/index.Rmd` | Book front matter: title, dates, authors. Rarely needs touching. |
| `lectures/<your-topic>/` | Your lecture slides. Whatever source format you use (`.tex`, `.Rnw`, PowerPoint exported to PDF) plus the compiled `.pdf` we ship to students. |

### Do NOT edit these

| Path | Why |
|---|---|
| `pracs/*.rnw` | **Deprecated.** Old Sweave version of the practicals, kept only for historical reference. Will be removed in a future cleanup. All edits go to `pracs-book/*.rmd`. |
| `pracs-book/*-s.rmd` | Auto-generated solutions, derived from the corresponding `*-e.rmd`. The one exception is `pracs-book/ggplot2-s.rmd` which is hand-maintained. |
| `pracs-book/SPE-R-*-practicals*.Rmd` | Auto-generated merged book file. If you see one in the directory, it's a leftover from a failed render — delete it (see Phase 4 of the Makefile's `clean` target). |
| `pracs-book/SPE-R-*-practicals/` | Built book output (ignored by git anyway). |
| `renv/`, `renv.lock` | R package environment. Touch only via `renv::snapshot()` and only when you've deliberately added a package. |
| `.github/workflows/` | CI definitions. Coordinate with Damien before changing. |

### The exercise → solution pattern

Each practical lives in two files:

- `xxx-e.rmd` (exercise) — what the student sees. Code chunks have `results = "hide"` so outputs aren't shown.
- `xxx-s.rmd` (solution) — same content, with `results = "markup"` so outputs are shown.

The `-s.rmd` files are generated automatically from the `-e.rmd` files by
`misc/from_e_to_s_rmd.R`. **Edit only the `-e.rmd` file**, then either let CI
regenerate the `-s.rmd` or run the `solutions` target locally
(see [section 4](#4-build-the-book-locally)).

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
