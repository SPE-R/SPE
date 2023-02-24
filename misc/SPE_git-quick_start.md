SPE git - quick start
=====================

-----

This is a quick and basic guide to work on [SPE repository](https://github.com/SPE-R/SPE) using git.

For ease of use, I decided to use git through [RStudio](https://posit.co/download/rstudio-desktop/) software. Everything can be done with any git client, the workflow remains the same, so feel free to use the one suits you the best.

For any question/issue please send me a mail at georgesd at iarc.who.int

-----

# Table of content

- [Workflow](#workflow)
- [Prerequest](#prerequest)
- [Setting-up acount and repository](#setting-up-acount-and-repository)
  * [Linking GitKraken to your github account](#linking-gitkraken-to-your-github-account)
  * [Cloning SPE repository](#cloning-spe-repository)
  * [Opening SPE repository](#opening-spe-repository)
- [Git actions](#git-actions)
  * [Pulling online version of the repository](#pulling-online-version-of-the-repository)
  * [Committing changes](#committing-changes)
  * [Pushing changes](#pushing-changes)
  


# Workflow

The usual git workflow is the following:

-----
1. `pull` (get the latest online version of the repository or `clone` it if you do not have any copy of the repository on your hard drive)
2. Work on your files, make your changes, ...
3. `commit` your changes (locally commit and comment your changes)
4. `pull` again (to prevent from file conflicts)
5. `push` your changes online

-----

**note 1**: the steps 2,3,4 should be repeated several times before to `push` your modification

**note 2**: you have first to `clone` and download the repository the first time (has only to be done once)

**note 3**: more complete tutorial on how to use git with RStudion can be found on the web (e.g. [github-and-rstudio](https://resources.github.com/github-and-rstudio/) ). 

# Prerequest

  - Having [RStudio](https://posit.co/download/rstudio-desktop/) installed on your machine.
  - Having `git` installed on your machine (please refer to [install-git](https://happygitwithr.com/install-git.html#install-git) for OS specific guidance)
  - Having a [github](https://github.com/) account and being a member of [SPE-R](https://github.com/orgs/SPE-R) 
  organization ([list of SPE-R members](https://github.com/orgs/SPE-R/people))

# Setting-up acount and repository
 
## [Cloning](https://git-scm.com/docs/git-clone) [SPE repository](https://github.com/SPE-R/SPE)

1. Open `RStudio` software
2. Click on `File > New project`

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-001.png)

3. Click on `Version Control > Git`

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-002.png)

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-003.png)

4. Fill the repository URL `https://github.com/SPE-R/SPE`, the project directory name `SPE` and choose the place where you want the repository to be clone on your had drive with `Browse..` button and click on `Create Project`

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-004.png)

**note 4**: If this is the first time you clone a repository, you might be asked to give some git ids (fill it accordingly with your [github](https://github.com/) credentials)


**note 5**: You only have to do it once. If you have already done that you can directly open the `SPE.Rproj` project in Rstudio

# Git actions

Now the repository is clone and the `SPE.Rproj` project open in `Rstudio` you should be able to intereact with the `github` repository. 

## [Pulling](https://git-scm.com/docs/git-pull) online version of the repository 

**note 6**: This is a very important step that insure that your synch with the most up to date version of the repository.

Getting the latest version of the repository available online.

Please remember to do it every time you open the repository and before pushing your changes.

1. Just click on `Pull` button in the `Git` tab on `Rstudio` top right panel.

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-004b.png)

2. Be sure that a message like `Pulled successfully` or `Already up to date` in the windows that pop-up

## [Changing your files]

You can now modify the files at your convenience within RStudio or your favorite script editor.
The list of modified/created/deleted files should be listed in the `Git` tab with the associated status
(e.g. `M` for modified, `A` for newly created files, `D` for deleted files, ...). When you are happy with your modifications you should commit your changes.

## [Committing](https://git-scm.com/docs/git-commit) changes

Documenting and accepting changes you made in the code locally (this will not affect the online version)
This has to be done regularly!

1. See what changes have been done since the last pull/commit in the `Git` tab 

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-005.png)

1. Tick the files you want to commit/stage (i.e. commit the changed you have done on the file)
2. Check that all and only the files you want to commit have been selected
3. Click on `Commit` 
3. Write a explicit and understandable description of what changes have been added/changed/removed
4. Commit the changes

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-006.png)

You should see a pop-up widows confirming the commits done.

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-007.png)

## [Pushing](https://git-scm.com/docs/git-push) changes

Pushing your local changes of the repository online.
This is the last step. 

1. Just click on `Push`

If everything goes right, a message should popup with something like `Pushed Successfully`.

Your changes are now online and the manual generation will be automatically triggered. 

If somebody has pushed his changes in between your latest pulled version and your `push` you might be asked to resolve some conflicts.
RStudio will then let you compare the differences/conflicts between your local version and the latest available online one. You will have to choose which files/lines to keep/discard.
The only way to prevent it is to `pull`/`commit`/`push` regularly.