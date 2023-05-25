## original idea & report by Henrik Bengtsson at
## https://stat.ethz.ch/pipermail/r-devel/2016-February/072388.html

## This script downloads the list of currently published R packages
## from CRAN and also looks at all the archived package versions to
## combine these into a list of all R packages ever published on
## CRAN with the date of first release.

## The script saves the package data at the end so you don't need to
## scrape the web every time to produce a plot.

## CRAN mirror to use
CRAN_page <- function(...) {
    ##file.path('https://cran.rstudio.com/src/contrib', ...)
    ##file.path('https://cran.ma.imperial.ac.uk/src/contrib', ...)
    ##file.path('https://www.stats.bris.ac.uk/R/src/contrib', ...)
    file.path('https://anorien.csc.warwick.ac.uk/CRAN/src/contrib', ...)
}

parse_apache_directory_listing <- function(url) {
    rbindlist(lapply(
        htmllistparse$fetch_listing(url)[[2]], function(item) data.table(
            Name = item$name,
            `Last modified` = as.POSIXct(time$strftime('%Y-%m-%d %H:%M:%S', item$modified)),
            Size = ifelse(is.null(item$size), 0, item$size))))
}

## we love data.table
library(data.table)

## get list of currently available packages on CRAN
library(reticulate)
use_python('/usr/bin/python3', required = TRUE)
## Use "pip install htmllistparse" on the command line to install this Python module
htmllistparse <- import('htmllistparse')
time <- import('time')

pkgs <- parse_apache_directory_listing(CRAN_page())

## drop directories
pkgs <- pkgs[Size != 0]
## drop files that does not seem to be R packages
pkgs <- pkgs[grep('tar.gz$', Name)]

## package name should contain only (ASCII) letters, numbers and dot
pkgs[, name := sub('^([a-zA-Z0-9\\.]*).*', '\\1', Name)]

## grab date from last modified timestamp
pkgs[, date := as.character(`Last modified`)]

## keep date and name
pkgs <- pkgs[, .(name, date)]

## list of packages with at least one archived version
archives <- parse_apache_directory_listing(CRAN_page('Archive'))

## keep directories
archives <- archives[grep('/$', Name)]

## add packages not found in current list of R packages
archives[, Name := sub('/$', '', Name)]
pkgs <- rbind(pkgs,
              archives[!Name %in% pkgs$name, .(name = Name)],
              fill = TRUE)

## reorder pkg in alphabet order
setorder(pkgs, name)

## number of versions released is 1 for published packages
pkgs[, versions := 0]
pkgs[!is.na(date), versions := 1]

## mark archived pacakges
pkgs[, archived := FALSE]
pkgs[name %in% archives$Name, archived := TRUE]

## NA date of packages with archived versions
pkgs[archived == TRUE, date := NA]

## lookup release date of first version & number of releases
saveRDS(pkgs, '/tmp/pkgs.RDS')
pkgs[is.na(date), c('date', 'versions') := {
    cat(name, '\n')
    pkgarchive <- parse_apache_directory_listing(CRAN_page('Archive', name))
    list(as.character(min(pkgarchive$`Last modified`)), versions + nrow(pkgarchive))
}, by = name]

## rename cols
setnames(pkgs, 'date', 'first_release')

## order by date & alphabet
setorder(pkgs, first_release, name)
pkgs[, index := .I]
pkgs[c(250, 500, (1:13)*1000)]

##              name       first_release versions archived index
##  1:         gstat 2003-02-04 15:24:00      111     TRUE   250
##  2:       relsurv 2005-01-21 12:52:00       33     TRUE   500
##  3:      spsurvey 2007-01-24 11:07:00       16     TRUE  1000
##  4:          oosp 2009-08-20 13:48:00        6     TRUE  2000
##  5:  penalizedLDA 2011-03-29 18:20:00        2     TRUE  3000
##  6:          R330 2012-06-07 06:08:00        1    FALSE  4000
##  7:     lbiassurv 2013-03-11 06:39:00        2     TRUE  5000
##  8:      gconcord 2014-01-24 17:57:00        2     TRUE  6000
##  9:        segmag 2014-10-17 08:30:00        3     TRUE  7000
## 10:          BCEE 2015-06-24 16:22:00        3     TRUE  8000
## 11: ontologyIndex 2016-01-11 14:32:00        5     TRUE  9000
## 12:     europepmc 2016-07-13 08:19:00        7     TRUE 10000
## 13:      magicfor 2016-12-18 10:23:00        1    FALSE 11000
## 14:         wally 2017-05-17 07:50:00        2     TRUE 12000
## 15:          xSub 2017-10-11 17:27:00        2     TRUE 13000

## plot trend
library(ggplot2)

## This version looks better now as recent growth appears linear
ggplot(pkgs, aes(as.Date(first_release), index)) +
    geom_line(size = 2) +
    scale_x_date(date_breaks = '2 years', date_labels = '%Y') +
    scale_y_continuous(breaks = c(0,5000,10000,15000,20000,25000)) +
    ylab('Number of R packages ever published') + xlab('First publication') + theme_bw() +
    ggtitle('Number of R packages by first publication')
ggsave('number-of-submitted-packages-to-CRAN.png')

## Older version on a log scale
ggplot(pkgs, aes(as.Date(first_release), index)) +
    geom_line(size = 2) +
    scale_x_date(date_breaks = '2 years', date_labels = '%Y') +
    scale_y_continuous(breaks = c(10,100,1000,10000), trans="log") +
    ylab('Number of R packages ever published') + xlab('First publication') + theme_bw() +
    ggtitle('Number of R packages by first publication')
ggsave('number-of-submitted-packages-to-CRAN-log.png')

## store report
save(pkgs, file="pkgs.rda")
write.csv(pkgs, 'results.csv', row.names = FALSE)
