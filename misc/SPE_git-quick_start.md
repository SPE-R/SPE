SPE git - quick start
=====================

-----

This is a quick and basic guide to work on [SPE repository](https://github.com/SPE-R/SPE) using git.

For ease of use, I decided to use git through [RStudio](https://www.gitkraken.com/) software.

For any question/issue please send me a mail at georgesd at iarc.fr

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

**note 2**: you have first to `clone` and setup the repository correctly once


# Prerequest

  - Having [GitKraken](https://www.gitkraken.com) installed on your machine. ([How to Install GitKraken](https://support.gitkraken.com/how-to-install]) [GitKraken Overview](https://www.gitkraken.com/git-client) click on `Watch video now`)
  - Having a [github](https://github.com/) account and being a member of [SPE-R](https://github.com/orgs/SPE-R) 
  organization ([list of SPE-R members](https://github.com/orgs/SPE-R/people))

# Setting-up acount and repository
 
## Linking GitKraken to your github account

1. Open `GitKraken` software
2. If this is the first time you open it, you will be asked to give some git ids. Click on 
`Sign in with GitHub` and enter your [github](https://github.com/) credentials.

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-001.png)

Once you have done it once you should be automatically connected to your git account each time
you will open `GitKraken`. You can easily check it in the upper right corner of `GitKraken` window.

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-002.png)


## [Cloning](https://git-scm.com/docs/git-clone) [SPE repository](https://github.com/SPE-R/SPE)

You only have to do it once. If you have already done that you can go to the `opening` step .

1. Click on the top left corner (folder icon)
2. Click on `Clone`
3. Select `Github.com`
4. Click on `Browse` and define where you want the repository to be saved on your local machine
5. Scroll down until you find `SPE-R` > `SPE` 
6. Click on `Clone the repo!`

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-003.png)


## Opening [SPE repository](https://github.com/SPE-R/SPE)

1. Click on the top left corner (folder icon)
2. Click on `Open`
3. Select `Recently Openned`
4. Select `SPE`

If `SPE` does not show up in the recently opened projects, click on `Open a Repository` and select the 
directory where you have cloned [SPE repository](https://github.com/SPE-R/SPE) (directory named `SPE`)

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-004.png)


# Git actions

## [Pulling](https://git-scm.com/docs/git-pull) online version of the repository

Getting the latest version of the repository available online.

Please remember to do it every time you open the repository and before pushing your changes.

1. Just click on `Pull` button

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-005.png)

2. Be sure that a message like `Pulled Successfully` shows up on the top right corner

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-006.png)


## [Committing](https://git-scm.com/docs/git-commit) changes

Documenting and accepting changes you made in the code locally (this will not affect the online version)
This has to be done regularly!

1. See what changes have been done since the last pull/commit and click on `see changes`

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-007.png)

1. Select the files you want to stage (i.e. commit the changed you have done on the file)
2. Check that all and only the files you want to commit have been selected
3. Write a explicit and understandable description of what changes have been added/changed/removed
4. Commit the changes

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-008.png)


## [Pushing](https://git-scm.com/docs/git-push) changes

Pushing your local changes of the repository online.
This is the last step. 

1. Just click on `Push`

![](https://github.com/SPE-R/SPE/blob/master/misc/SPE_git-quick_start-images/spe_git-quick_start-009.png)

If everything goes right, a blue message should popup on the right corner of your windows with something like `Pushed Successfully`.

If somebody has pushed his changes in between your latest pulled version and your `push` you might be asked to resolve some conflicts.
GitKraken will then let you compare the differences/conflicts between your local version and the latest available online one. You will have to choose which files/lines to keep/discard.
This is not the best part of the process and the only way to prevent it is to `pull`/`commit`/`push` regularly.