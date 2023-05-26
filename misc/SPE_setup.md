Setting Up an `R` Project for SPE-R course using RStudio and `renv`
=====================

## Introduction:

Setting up a dedicated `R` project for a SPE-R course can help you organize your work, manage dependencies, and ensure reproducibility. In this tutorial, we will guide you through the process of initializing a ready to be use `R` project using RStudio and leveraging the `renv` package for dependency management.

## Prerequisites:

Before proceeding with this tutorial, ensure that you have `R` and [RStudio installed](https://posit.co/download/rstudio-desktop/)  on your system. We recommend to have get the latest releases of `R` and Rstudio. Additionally, make sure you have the `renv` package installed by running `install.packages("renv")` in the R console.

## Step 1: Creating a New `R` Project

1. Launch RStudio.

2. Click on `File` in the top menu and select `New Project`.

3. In the `New Project` dialog box, choose `New Directory` and click `Next`.

4. Select `New Project` and click `Next`.

5. Choose a directory location for your project and provide a name for the project (e.g. SPE-R_2023).

6. Click `Create Project` to create the `R` project.

## Step 2: Configuring renv for the Project

1. Once your project is created, RStudio will automatically open the project in a new session.

2. Open the `R` console in RStudio.

3. Download the up to date list of packages to be installed (renv.lock file) from SPE-R website. In the console, `download.file("https://github.com/SPE-R/SPE/raw/gh-spe-material/renv.lock", "renv.lock")`

4. In the console, run `renv::restore()` and reply `Y` to the console questions you will be asked (e.g. activate `renv`, download all packages, ...). This will initialize the `renv` environment for the project and download all the required packages for SPE-R course.

## Step 3: Download the data that will be used in the practical

1. Get the data from git repository. In `R`: `download.file("https://github.com/SPE-R/SPE/raw/gh-spe-material/data.zip", "data.zip")`

2. Unzip the data. In `R`: `unzip('data.zip')`


## Conclusion:

In this tutorial, you have learned how to set up an `R` project for SPE-R course using RStudio and `renv`. By creating a dedicated project and managing dependencies with `renv`, you can organize your work, ensure reproducibility, and collaborate with others effectively. Happy coding!

