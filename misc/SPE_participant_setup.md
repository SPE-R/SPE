SPE-R participant setup guide
=============================

This guide walks you, as a **course participant**, through everything you need
to do **before the course starts** so that you arrive ready to work with the
SPE-R material. Set aside about an hour, and do it while you still have a good
internet connection — installing the R packages is the slow part.

The 2026 edition runs **1–5 June 2026 in Tartu, Estonia**.

By the end of this guide you will have:

- `R` and an editor (RStudio **or** Positron) installed;
- a dedicated course folder/project on your laptop;
- the practical **data** in the right place;
- all the **R packages** the practicals use;
- bookmarks to the **timetable, lectures and practicals book**.

If you get stuck, write to <georgesd@iarc.who.int>.

---

## Table of contents

- [1. Install R](#1-install-r)
- [2. Install an editor: RStudio or Positron](#2-install-an-editor-rstudio-or-positron)
- [3. Create the course project](#3-create-the-course-project)
- [4. Download the data](#4-download-the-data)
- [5. Install the required R packages](#5-install-the-required-r-packages)
- [6. Check that everything works](#6-check-that-everything-works)
- [7. Where to find the course material](#7-where-to-find-the-course-material)
- [8. Recommended pre-reading](#8-recommended-pre-reading)
- [9. Troubleshooting](#9-troubleshooting)

---

## 1. Install R

Install **R 4.6.0** — the version the course material was compiled and tested
with. Using the same version avoids surprises.

- Download from **CRAN**: <https://cran.r-project.org/>
  - Windows: *Download R for Windows* → *base* → *Download R 4.6.0 for Windows*
  - macOS: *Download R for macOS* → pick the installer matching your chip
    (Apple silicon `arm64` vs older Intel)
  - Linux: follow the per-distribution instructions on CRAN

If you already have a recent R (4.6.x), you do **not** need to reinstall.

---

## 2. Install an editor: RStudio or Positron

You only need **one** of these. Both are free and both run the course
material equally well — pick whichever you prefer.

| Editor | Best if… | Download |
|---|---|---|
| **RStudio Desktop** | you want the long-established, classic R IDE (most course screenshots use it) | <https://posit.co/download/rstudio-desktop/> |
| **Positron** | you prefer a modern, VS Code–style editor (also from Posit; newer) | <https://positron.posit.co/> |

> If you have never used R before, **RStudio** is the safest choice and matches
> what most of the faculty will be showing on screen.

Install R (section 1) **before** the editor, so the editor can find it
automatically.

---

## 3. Create the course project

A "project" is just a dedicated folder for the course, so everything (data,
scripts, packages) lives in one place. Working inside it also means the data
paths used in the practicals (e.g. `read.table("data/fem.dat")`) work without
edits.

### Option A — RStudio

1. Launch RStudio.
2. **File → New Project… → New Directory → New Project**.
3. Give it a name, e.g. `SPE-R_2026`, and choose where to put it (e.g. your
   `Documents` folder).
4. **Tick "Use renv with this project"** (this prepares the package
   environment used in section 5).
5. Click **Create Project**. RStudio opens the new project in a fresh session.

### Option B — Positron

1. Create an empty folder named `SPE-R_2026` somewhere convenient
   (e.g. in `Documents`).
2. In Positron: **File → Open Folder…** and select that folder.
3. Positron will use this folder as your workspace. The package environment is
   set up in section 5.

> Whatever editor you use, make sure that when you run R code its **working
> directory is the project folder**. In RStudio this is automatic inside a
> project; in Positron the console opens in the folder you opened.

---

## 4. Download the data

The practicals read their datasets from a `data/` sub-folder of your project.

**Easiest — from R**, with your project open, run in the R console:

```r
download.file("https://github.com/SPE-R/SPE/raw/gh-spe-material/data.zip", "data.zip")
unzip("data.zip")        # creates a "data/" folder inside your project
```

**Or — manually**: download
<https://github.com/SPE-R/SPE/raw/gh-spe-material/data.zip>, then move/unzip it
**inside your project folder** so that you end up with a `data/` sub-folder.

After unzipping, your project should contain a `data/` folder with files such
as `fem.dat`, `melanoma.dat`, `occoh.txt`, `births.dta`, … Check with:

```r
list.files("data")
```

---

## 5. Install the required R packages

There are two ways. **Try `renv` first** — it installs the exact versions the
course was built with. If it gives you trouble, use the plain
`install.packages()` fallback, which is simpler and almost always works.

### 5a. Default: `renv` (recommended)

In the R console, from your project:

```r
install.packages("renv")     # skip if you already have it
renv::activate()             # turns the current folder into an renv project
                             # (if asked to restart R, do so, then continue)

download.file("https://github.com/SPE-R/SPE/raw/gh-spe-material/renv.lock", "renv.lock")
renv::restore()              # downloads and installs every package, at the locked version
```

Reply **`Y`** to the prompts (activate `renv`, install the packages, …).

This takes **10–30 minutes the first time** — packages may compile from source
on macOS/Linux (binary on Windows). It only needs to be done once; later it is
near-instant because packages are cached.

> If you ticked *"Use renv with this project"* in RStudio (section 3, Option A),
> `renv` is already active — downloading `renv.lock` overwrites the starter
> lockfile, and `renv::restore()` then installs everything listed in it.

### 5b. Fallback: plain `install.packages()`

If `renv` fails (e.g. a package won't compile, or a corporate network blocks
something), install the packages the ordinary way instead.

The full, always-up-to-date list of required packages — together with a single
ready-to-paste `install.packages(c(...))` command — is published here:

- **SPE-R software requirement page:**
  <https://github.com/SPE-R/SPE/blob/gh-spe-material/prerequest.knit.md>

Open that page, copy the `install.packages(c('...'))` command it shows, and run
it in your R console. Answer **Yes** if asked to install from source or to use a
personal library.

---

## 6. Check that everything works

With your project open, run these in the R console. No errors means you're
ready:

```r
list.files("data")                              # should list fem.dat, melanoma.dat, ...
fem <- read.table("data/fem.dat", header = TRUE) # read a sample dataset
head(fem)

library(Epi)                                    # a core package used throughout
library(tidyverse)                              # used in several practicals
```

If `list.files("data")` is empty, revisit section 4 (the `data/` folder is not
inside your project). If a `library(...)` call errors with "there is no package
called …", revisit section 5.

---

## 7. Where to find the course material

Everything is reachable from the course landing page: <https://spe-r.github.io/>

| Material | Link |
|---|---|
| **Timetable** | <https://github.com/SPE-R/SPE/blob/master/adm/SPE-R-timetable.md> |
| **Practicals book** (exercises) — HTML | <https://spe-r.github.io/SPE/SPE-R-2026-practicals/> |
| **Practicals book** (exercises) — PDF | <https://spe-r.github.io/SPE/SPE-R-2026-practicals/SPE-R-2026-practicals.pdf> |
| **Practicals book with solutions** — HTML | <https://spe-r.github.io/SPE/SPE-R-2026-practicals-with-solutions/> |
| **Practicals book with solutions** — PDF | <https://spe-r.github.io/SPE/SPE-R-2026-practicals-with-solutions/SPE-R-2026-practicals-with-solutions.pdf> |
| **Lectures** (individual PDFs) | <https://github.com/SPE-R/SPE/tree/gh-spe-material/lectures> |
| **Lecture handouts** (all lectures, 3-per-page) | <https://github.com/SPE-R/SPE/raw/gh-spe-material/SPE-2026-lectures-3x1.pdf> |
| **Data** (`data.zip`) | <https://github.com/SPE-R/SPE/raw/gh-spe-material/data.zip> |
| **R solution scripts** (`Rsolutions.zip`) | <https://github.com/SPE-R/SPE/raw/gh-spe-material/Rsolutions.zip> |
| **Everything in one zip** | <https://github.com/SPE-R/SPE/raw/gh-spe-material/SPE-all-material.zip> |

> The two books are built from the same exercises. Use the **exercises**
> version during the sessions; the **with-solutions** version (full code and
> extra explanations) is there to check your work and to revise afterwards.

---

## 8. Recommended pre-reading

These two chapters are **not** taught during the course but the practicals
assume you are comfortable with them. If you are new to R, read them
beforehand:

- **Practice with basic `R`**:
  <https://spe-r.github.io/SPE/SPE-R-2026-practicals/practice-with-basic-r.html>
- **Reading data into `R`**:
  <https://spe-r.github.io/SPE/SPE-R-2026-practicals/reading-data-into-r.html>

---

## 9. Troubleshooting

| Symptom | Try this |
|---|---|
| `renv::restore()` fails on one package | Re-run it (transient download failures are common). If it keeps failing on the same package, use the plain `install.packages()` fallback (section 5b). |
| A package won't compile from source (macOS/Linux) | Install the binary instead: `install.packages("<pkg>", type = "binary")`, or use the fallback list. |
| `read.table("data/fem.dat")` → "cannot open the connection" | Your working directory isn't the project root, or the `data/` folder isn't there. Check `getwd()` and `list.files("data")`; redo section 4 if needed. |
| Corporate network / proxy blocks downloads | Download `data.zip`, `renv.lock` and the packages from a home connection, or ask IT to allow `github.com` and `cran.r-project.org`. |
| Editor can't find R | Install R **before** the editor (section 1), then restart the editor. |

Still stuck? Email <georgesd@iarc.who.int> 
