##' ---
##' title: Install SPE practicals R dependencies
##' author: Damien G.
##' ---

##' This script will screen all the files from the working directory (and childs) to detect the 
##' required packages and will then install them.
##' 
##' If you run the script without argument, the latest stable version of packages (and dependencies) 
##' will be installed (default)
##' 
##' `Rscript install-dependencies.R`
##' 
##' Alternatively giving the script a date argument (as `YYYY-MM-DD`) will lead to the installation
##' of the packages et this date (threw `checkpoint` features). This can be usefull or reproductibility
##' concerns.
##' 
##' `Rscript install-dependencies.R 2018-01-01`
##' 

## read script arguments if some given
args <- commandArgs(trailingOnly = TRUE) 

## get the list of available package
pkg.avail <- installed.packages()[, 'Package']

## install checkpoint package if not available
if(!('checkpoint' %in% pkg.avail)){ 
  install.packages('checkpoint') 
} 

if(!length(args)){ 
  message('The checkpoint process have been switch off because no date referred')
  message('Latest stable version of the packages will be installed')
  pkg.missing <- checkpoint:::scanForPackages()
  if(length(pkg.missing$pkgs)){
    install.packages(pkg.missing$pkgs, dependencies = TRUE)
  }
} else { 
  checkpoint.date <- args[1] 
  ## check date validity 
  if(!grepl(pattern = '^[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}$', x = checkpoint.date)){ 
    stop('Argument should be a checkpoint date at the format YYYY-MM-DD') 
  } else { 
    ## install the package as they were at a given date 
    checkpoint:::checkpoint(checkpoint.date, checkpointLocation = getwd()) 
  } 
} 

quit(save = 'no', status = 0) 

# ### the formal bash version ======================================================================
# ## install the packages at a defined checkpoint date  
# 
# # define the checkpoint date 
# CHECKPOINT_DATE=2018-02-01 
# # install all the required packages 
# Rscript --vanilla install-pkg-checkoint.R $CHECKPOINT_DATE 
# # set env var to let R know where the pkg are installed (trick based on Epi pkg location) 
# EPI_PKG_LOCATION=`find .checkpoint/$CHECKPOINT_DATE/ -type d -name "Epi" -print` 
# R_LIBS_USER=${EPI_PKG_LOCATION%%/Epi} 
#


# export R_LIBS_USER 