

# Reading data into `R`

## Introduction

> *If you want to have rabbit stew, first catch the rabbit* -- Old saying, origin unknown

`R` is a language and environment for data analysis. If you
want to do something interesting with it, you need data.

For teaching purposes, data sets are often embedded in `R`
packages.  The base `R` distribution contains a whole package
dedicated to data which includes around 100 data sets.  This is
attached towards the end of the search path, and you can see its
contents with

``` r
objects("package:datasets")
```

```
##   [1] "ability.cov"           "airmiles"              "AirPassengers"        
##   [4] "airquality"            "anscombe"              "attenu"               
##   [7] "attitude"              "austres"               "beaver1"              
##  [10] "beaver2"               "BJsales"               "BJsales.lead"         
##  [13] "BOD"                   "cars"                  "ChickWeight"          
##  [16] "chickwts"              "co2"                   "CO2"                  
##  [19] "crimtab"               "discoveries"           "DNase"                
##  [22] "esoph"                 "euro"                  "euro.cross"           
##  [25] "eurodist"              "EuStockMarkets"        "faithful"             
##  [28] "fdeaths"               "Formaldehyde"          "freeny"               
##  [31] "freeny.x"              "freeny.y"              "HairEyeColor"         
##  [34] "Harman23.cor"          "Harman74.cor"          "Indometh"             
##  [37] "infert"                "InsectSprays"          "iris"                 
##  [40] "iris3"                 "islands"               "JohnsonJohnson"       
##  [43] "LakeHuron"             "ldeaths"               "lh"                   
##  [46] "LifeCycleSavings"      "Loblolly"              "longley"              
##  [49] "lynx"                  "mdeaths"               "morley"               
##  [52] "mtcars"                "nhtemp"                "Nile"                 
##  [55] "nottem"                "npk"                   "occupationalStatus"   
##  [58] "Orange"                "OrchardSprays"         "PlantGrowth"          
##  [61] "precip"                "presidents"            "pressure"             
##  [64] "Puromycin"             "quakes"                "randu"                
##  [67] "rivers"                "rock"                  "Seatbelts"            
##  [70] "sleep"                 "stack.loss"            "stack.x"              
##  [73] "stackloss"             "state.abb"             "state.area"           
##  [76] "state.center"          "state.division"        "state.name"           
##  [79] "state.region"          "state.x77"             "sunspot.month"        
##  [82] "sunspot.year"          "sunspots"              "swiss"                
##  [85] "Theoph"                "Titanic"               "ToothGrowth"          
##  [88] "treering"              "trees"                 "UCBAdmissions"        
##  [91] "UKDriverDeaths"        "UKgas"                 "USAccDeaths"          
##  [94] "USArrests"             "UScitiesD"             "USJudgeRatings"       
##  [97] "USPersonalExpenditure" "uspop"                 "VADeaths"             
## [100] "volcano"               "warpbreaks"            "women"                
## [103] "WorldPhones"           "WWWusage"
```
A description of all of these objects is available using the `help()`
function. For example

``` r
help(Titanic)
```
gives an explanation of the `Titanic` data set, along with
references giving the source of the data.

The `Epi` package also contains some data sets. These are not
available automatically when you load the `Epi` package, but
you can make a copy in your workspace using the `data()`
function. For example

``` r
library(Epi)
data(bdendo)
```
will create a data frame called `bdendo` in your workspace
containing data from a case-control study of endometrial cancer.
Datasets in the `Epi` package also have help pages: type
`help(bdendo)` for further information.

To go back to the cooking analogy, these data sets are the equivalent
of microwave ready meals, carefully packaged and requiring minimal
work by the consumer.  Your own data will never be able in this form
and you must work harder to read it in to `R`. 

This exercise introduces you to the basics of reading external data
into `R`. It consists of reading the same data from different
formats.  Although this may appear repetitive, it allows you to see
the many options available to you, and should allow you to recognize
when things go wrong.


> **getting the data** You will need to download the zip file `data.zip` from the course web site (https://github.com/SPE-R/SPE/raw/gh-spe-material/SPE-all-material.zip) and unpack this in your working directory. This will create a sub-directory `data` containing (among other things) the files `fem.dat`, `fem-dot.dat`, `fem.csv`, and `fem.dta` (Reminder: use `setwd()` to set
your working directory).


## Data sources

Sources of data can be classified into three groups:

-  Data in human readable form, which can be inspected with a text editor.
-  Data in binary format, which can only be read by a program that
understands that format (SAS, SPSS, Stata, Excel, ...).
-  Online data from a database management system (DBMS)

This exercise will deal with the first two forms of
data. Epidemiological data sets are rarely large enough to justify
being kept in a DBMS.  If you want further details on this topic, you
can consult the *R Data Import/Export* manual that comes with
`R`.

## Data in text files

Human-readable data files are generally kept in a rectangular format,
with individual records in single rows and variables in columns.  Such
data can be read into a data frame in `R`.

Before reading in the data, you should inspect the file in a text
editor and ask three questions:

-  How are columns in the table separated?
-  How are missing values represented?
-  Are variable names included in the file?


The file `fem.dat` contains data on 118 female psychiatric
patients. The data set contains nine variables.

| Name    | Description                                       |
| :------ | :------------------------------------------------ |
| ID      | Patient identifier                                |
| AGE     | Age in years                                      |
| IQ      | Intelligence Quotient (IQ) score                  |
| ANXIETY | Anxiety (1=none, 2=mild, 3=moderate,4=severe)     |
| DEPRESS | Depression (1=none, 2=mild, 3=moderate or severe) |
| SLEEP   | Sleeping normally (1=yes, 2=no)                   |
| SEX     | Lost interest in sex (1=yes, 2=no)                |
| LIFE    | Considered suicide (1=yes, 2=no)                  |
| WEIGHT  | Weight change (kg) in previous 6 months           |


Inspect the file `fem.dat` with a text editor to answer the
questions above.

The most general function for reading in free-format data is
`read.table()`.  This function reads a text file and returns a
data frame. It tries to guess the correct format of each variable in
the data frame (integer, double precision, or text).

Read in the table with:

``` r
fem <- read.table("./data/fem.dat", header = TRUE)
```
Note that you must assign the result of `read.table()` to an
object.  If this is not done, the data frame will be printed to the
screen and then lost.

You can see the names of the variables with

``` r
names(fem)
```

```
## [1] "ID"      "AGE"     "IQ"      "ANXIETY" "DEPRESS" "SLEEP"   "SEX"    
## [8] "LIFE"    "WEIGHT"
```
The structure of the data frame can be seen with

``` r
str(fem)
```

```
## 'data.frame':	118 obs. of  9 variables:
##  $ ID     : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ AGE    : int  39 41 42 30 35 44 31 39 35 33 ...
##  $ IQ     : int  94 89 83 99 94 90 94 87 -99 92 ...
##  $ ANXIETY: int  2 2 3 2 2 NA 2 3 3 2 ...
##  $ DEPRESS: int  2 2 3 2 1 1 2 2 2 2 ...
##  $ SLEEP  : int  2 2 2 2 1 2 NA 2 2 2 ...
##  $ SEX    : int  1 1 1 1 1 2 1 1 1 1 ...
##  $ LIFE   : int  1 1 1 1 2 2 1 2 1 1 ...
##  $ WEIGHT : num  2.23 1 1.82 -1.18 -0.14 0.41 -0.68 1.59 -0.55 0.36 ...
```
You can also inspect the top few rows with

``` r
head(fem)
```

```
##   ID AGE IQ ANXIETY DEPRESS SLEEP SEX LIFE WEIGHT
## 1  1  39 94       2       2     2   1    1   2.23
## 2  2  41 89       2       2     2   1    1   1.00
## 3  3  42 83       3       3     2   1    1   1.82
## 4  4  30 99       2       2     2   1    1  -1.18
## 5  5  35 94       2       1     1   1    2  -0.14
## 6  6  44 90      NA       1     2   2    2   0.41
```
Note that the IQ of subject 9 is -99, which is an illegal value:
nobody can have a negative IQ. In fact -99 has been used in this file
to represent a missing value. In `R` the special value
`NA` (*Not Available*) is used to represent missing values. All
`R` functions recognize `NA` values and will handle them
appropriately, although sometimes the appropriate response is to stop
the calculation with an error message.

You can recode the missing values with

``` r
fem$IQ[fem$IQ == -99] <- NA
```
Of course it is much better to handle special missing value codes
when reading in the data. This can be done with the
`na.strings` argument of the `read.table()`
function. See below.

## Things that can go wrong

Sooner or later when reading data into `R`, you will make a
mistake.  The frustrating part of reading data into `R` is that
most mistakes are not fatal: they simply cause the function to return
a data frame that is *not what you wanted.*  There are three
common mistakes, which you should learn to recognize.

## Forgetting the headers

The first row of the file `fem.dat` contains the variable names.
The `read.table()` function does not assume this by default so
you have to specify this with the argument `header=TRUE`.  See
what happens when you forget to include this option:

``` r
fem2 <- read.table("data/fem.dat")
str(fem2)
```

```
## 'data.frame':	119 obs. of  9 variables:
##  $ V1: chr  "ID" "1" "2" "3" ...
##  $ V2: chr  "AGE" "39" "41" "42" ...
##  $ V3: chr  "IQ" "94" "89" "83" ...
##  $ V4: chr  "ANXIETY" "2" "2" "3" ...
##  $ V5: chr  "DEPRESS" "2" "2" "3" ...
##  $ V6: chr  "SLEEP" "2" "2" "2" ...
##  $ V7: chr  "SEX" "1" "1" "1" ...
##  $ V8: chr  "LIFE" "1" "1" "1" ...
##  $ V9: chr  "WEIGHT" "2.23" "1" "1.82" ...
```

``` r
head(fem2)
```

```
##   V1  V2 V3      V4      V5    V6  V7   V8     V9
## 1 ID AGE IQ ANXIETY DEPRESS SLEEP SEX LIFE WEIGHT
## 2  1  39 94       2       2     2   1    1   2.23
## 3  2  41 89       2       2     2   1    1      1
## 4  3  42 83       3       3     2   1    1   1.82
## 5  4  30 99       2       2     2   1    1  -1.18
## 6  5  35 94       2       1     1   1    2  -0.14
```
and compare the resulting data frame with `fem`. 
 - What are the names of the variables in the data frame? 
 - What is the class of the variables?


>  **Explanation:** Remember that `read.table()` tries to guess
  the mode of the variables in the text file. Without the
  `header = TRUE` option it reads the first row, containing the
  variable names, as data, and guesses that all the variables are
  character, not numeric. By default, all character variables are
  coerced to factors by `read.table`. The result is a data frame
  consisting entirely of factors. (You can prevent the conversion of
  character variables to factors with the argument `as.is = TRUE`).

If the variable names are not specified in the file, then they are
given default names `V1`, `V2`, ... . You will soon realise this
mistake if you try to access a variable in the data frame by, for
example

``` r
fem2$IQ
```

```
## NULL
```
as the variable will not exist

There is one case where omitting the `header = TRUE` option is
harmless (apart from the situation where there is no header line,
obviously).  When the first row of the file contains **one less**
value than subsequent lines, `read.table()` infers that the first
row contains the variable names, and the first column of every
subsequent row contains its **row name**.

## Using the wrong separator

By default, `read.table` assumes that data values are separated
by any amount of white space. Other possibilities can be specified
using the `sep` argument. See what happens when you assume the
wrong separator, in this case a tab, which is specified using the
escape sequence `"\t"`

``` r
fem3 <- read.table("data/fem.dat", sep = "\t")
str(fem3)
```

```
## 'data.frame':	119 obs. of  1 variable:
##  $ V1: chr  "ID AGE IQ ANXIETY DEPRESS SLEEP SEX LIFE WEIGHT" "1 39 94 2 2 2 1 1 2.23" "2 41 89 2 2 2 1 1 1" "3 42 83 3 3 2 1 1 1.82" ...
```

- How many variables are there in the data set?

> **Explanation:** If you mis-specify the separator,
> `read.table()` reads the whole line as a single character
> variable. Once again, character variables are coerced to factors, so
>   you get a data frame with a single factor variable.


## Mis-specifying the representation of missing values

The file `fem-dot.dat` contains a version of the FEM dataset in
which all missing values are represented with a dot. This is a common
way of representing missing values, but is not recognized by default
by the `read.table()` function, which assumes that missing values
are represented by *NA*.

Inspect the file with a text editor, and then see what happens when
you read the file in incorrectly:

``` r
fem4 <- read.table("data/fem-dot.dat", header = TRUE)
str(fem4)
```

```
## 'data.frame':	118 obs. of  9 variables:
##  $ ID     : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ AGE    : int  39 41 42 30 35 44 31 39 35 33 ...
##  $ IQ     : chr  "94" "89" "83" "99" ...
##  $ ANXIETY: chr  "2" "2" "3" "2" ...
##  $ DEPRESS: chr  "2" "2" "3" "2" ...
##  $ SLEEP  : chr  "2" "2" "2" "2" ...
##  $ SEX    : chr  "1" "1" "1" "1" ...
##  $ LIFE   : chr  "1" "1" "1" "1" ...
##  $ WEIGHT : chr  "2.23" "1" "1.82" "-1.18" ...
```
You should have enough clues by now to work out what went wrong.

You can read the data correctly using the `na.strings` argument

``` r
fem4 <- 
  read.table(
    "data/fem-dot.dat", 
    header = TRUE, 
    na.strings = "."
  )
```

## Spreadsheet data

Spreadsheets have become a common way of exchanging data. All
spreadsheet programs can save a single sheet in *comma-separated
variable* (CSV) format, which can then be read into `R`.  There
are two functions in `R` for reading in CSV data:
`read.csv()` and `read.csv2()`.

Both of these are wrappers around the `read.table()` function,
*i.e.* the `read.table()` function is still doing the work
of reading in the data but the `read.csv()` function provides
default argument values for reading in CSV file so all you need to
do is specify the file name.

You can see what these default arguments are with the `args()`
function.

``` r
args(read.csv)
```

```
## function (file, header = TRUE, sep = ",", quote = "\"", dec = ".", 
##     fill = TRUE, comment.char = "", ...) 
## NULL
```

``` r
args(read.csv2)
```

```
## function (file, header = TRUE, sep = ";", quote = "\"", dec = ",", 
##     fill = TRUE, comment.char = "", ...) 
## NULL
```

See if you can spot the difference between `read.csv` and 
`read.csv2`.


>  **Explanation:** The CSV format is not a single standard.  The
  file format depends on the *locale* of your computer -- the
  settings that determine how numbers are represented.  In some
  countries, the decimal separator is a point *.* and the variable
  separator in a CSV file is a comma *,*.  In other countries, the
  decimal separator is a comma *,* and the variable separator is a
  semi-colon *;*. This is reflected in the different default values
  for the arguments `sep` and `dec`.  The
  `read.csv()` function is used for the first format and the
  `read.csv2()` function is used for the second format.

The file `fem.csv` contains the FEM dataset in CSV format.
Inspect the file to work out which format is used, and read it into
`R`.

## Reading data from the Internet

You can also read in data from a remote web site. The `file`
argument of `read.table()` does not need to be a local file on
your computer; it can be a Uniform Resource Locator (URL), *i.e.*
a web address.

A copy of the file `fem.dat` is held at
(https://www.bendixcarstensen.com/SPE/data/fem.dat). You can
read it in with


``` r
fem6 <- 
  read.table(
    "http://www.bendixcarstensen.com/SPE/data/fem.dat",
    header = TRUE
  )
str(fem6)
```

```
## 'data.frame':	118 obs. of  9 variables:
##  $ ID     : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ AGE    : int  39 41 42 30 35 44 31 39 35 33 ...
##  $ IQ     : int  94 89 83 99 94 90 94 87 -99 92 ...
##  $ ANXIETY: int  2 2 3 2 2 NA 2 3 3 2 ...
##  $ DEPRESS: int  2 2 3 2 1 1 2 2 2 2 ...
##  $ SLEEP  : int  2 2 2 2 1 2 NA 2 2 2 ...
##  $ SEX    : int  1 1 1 1 1 2 1 1 1 1 ...
##  $ LIFE   : int  1 1 1 1 2 2 1 2 1 1 ...
##  $ WEIGHT : num  2.23 1 1.82 -1.18 -0.14 0.41 -0.68 1.59 -0.55 0.36 ...
```

## Reading from the clipboard

On Microsoft Windows, you can copy values directly from an open Excel
spreadsheet using the clipboard. Highlight the cells you want to copy
in the spread sheet and select copy from the pull-down edit menu. Then
type `read.table(file = "clipboard")` to read the data in.

There are two reasons why this is a bad idea

-  It is not reproducible. In order to read the data in again you
  need to complete exactly the same sequence of mouse moves and clicks,
  and there is no record of what you did before.
-  Copying from the clipboard loses precision. If you have a value
  `1.23456789` in your spreadsheet, but have formatted the cell so it
  is displayed to two decimal places, then the value read into
  `R` will be the truncated value `1.23`.


## Binary data

The `foreign` package allows you to read data in binary formats
used by other statistical packages. Since `R` is an open source
project, it can only read binary formats that are themselves *open*,
in the sense that the standards for reading and writing data are
well-documented.  For example, there is a function in the
`foreign` package for reading SAS XPORT files, a format that
has been adopted as a standard by the US Food and Drug Administration
((http://www.sas.com/govedu/fda/faq.html)).  However, there is no
function in the `foreign` package for reading native SAS
binaries (`SAS7BDAT` files). Other packages are available from
CRAN ((http://cran.r-project.org)) that offer the possibility of
reading SAS binary files: see the `haven` and `sas7bdat`
packages.

The file `fem.dta` contains the FEM dataset in the format
used by Stata. Read it into `R` with

``` r
library(foreign)
fem5 <- read.dta("data/fem.dta")
head(fem5)
```

```
##   id age iq  anxiety            depress sleep sex life weight
## 1  1  39 94     mild               mild    no yes  yes   2.23
## 2  2  41 89     mild               mild    no yes  yes   1.00
## 3  3  42 83 moderate moderate or severe    no yes  yes   1.82
## 4  4  30 99     mild               mild    no yes  yes  -1.18
## 5  5  35 94     mild               none   yes yes   no  -0.14
## 6  6  44 90     <NA>               none    no  no   no   0.41
```
The Stata data set contains value and variable labels.
Stata variables with value labels are automatically converted to
factors.

There is no equivalent of variable labels in an `R` data frame,
but the original variable labels are not lost. They are still attached
to the data frame as an invisible *attribute*, which you can see
with

``` r
attr(fem5, "var.labels")
```

```
## [1] "Patient ID"                             
## [2] "Age in years"                           
## [3] "IQ score"                               
## [4] "Anxiety"                                
## [5] "Depression"                             
## [6] "Sleeping normally"                      
## [7] "Lost interest in sex"                   
## [8] "Considered suicide"                     
## [9] "Weight change (kg) in previous 6 months"
```
A lot of *meta-data* is attached to the data in the form of
attributes. You can see the whole list of attributes with

``` r
attributes(fem5)
```

```
## $datalabel
## [1] "Data on 118 female psychiatric patients"
## 
## $time.stamp
## [1] " 1 Jun 2006 12:36"
## 
## $names
## [1] "id"      "age"     "iq"      "anxiety" "depress" "sleep"   "sex"    
## [8] "life"    "weight" 
## 
## $formats
## [1] "%8.0g"  "%8.0g"  "%8.0g"  "%8.0g"  "%18.0g" "%8.0g"  "%8.0g"  "%8.0g" 
## [9] "%9.0g" 
## 
## $types
## [1] 252 251 252 251 251 251 251 251 254
## 
## $val.labels
## [1] ""        ""        ""        "anxiety" "depress" "yesno"   "yesno"  
## [8] "yesno"   ""       
## 
## $var.labels
## [1] "Patient ID"                             
## [2] "Age in years"                           
## [3] "IQ score"                               
## [4] "Anxiety"                                
## [5] "Depression"                             
## [6] "Sleeping normally"                      
## [7] "Lost interest in sex"                   
## [8] "Considered suicide"                     
## [9] "Weight change (kg) in previous 6 months"
## 
## $row.names
##   [1] "1"   "2"   "3"   "4"   "5"   "6"   "7"   "8"   "9"   "10"  "11"  "12" 
##  [13] "13"  "14"  "15"  "16"  "17"  "18"  "19"  "20"  "21"  "22"  "23"  "24" 
##  [25] "25"  "26"  "27"  "28"  "29"  "30"  "31"  "32"  "33"  "34"  "35"  "36" 
##  [37] "37"  "38"  "39"  "40"  "41"  "42"  "43"  "44"  "45"  "46"  "47"  "48" 
##  [49] "49"  "50"  "51"  "52"  "53"  "54"  "55"  "56"  "57"  "58"  "59"  "60" 
##  [61] "61"  "62"  "63"  "64"  "65"  "66"  "67"  "68"  "69"  "70"  "71"  "72" 
##  [73] "73"  "74"  "75"  "76"  "77"  "78"  "79"  "80"  "81"  "82"  "83"  "84" 
##  [85] "85"  "86"  "87"  "88"  "89"  "90"  "91"  "92"  "93"  "94"  "95"  "96" 
##  [97] "97"  "98"  "99"  "100" "101" "102" "103" "104" "105" "106" "107" "108"
## [109] "109" "110" "111" "112" "113" "114" "115" "116" "117" "118"
## 
## $version
## [1] 8
## 
## $label.table
## $label.table$anxiety
##     none     mild moderate   severe 
##        1        2        3        4 
## 
## $label.table$depress
##               none               mild moderate or severe 
##                  1                  2                  3 
## 
## $label.table$yesno
## yes  no 
##   1   2 
## 
## 
## $class
## [1] "data.frame"
```
or just the attribute names with

``` r
names(attributes(fem5))
```

```
##  [1] "datalabel"   "time.stamp"  "names"       "formats"     "types"      
##  [6] "val.labels"  "var.labels"  "row.names"   "version"     "label.table"
## [11] "class"
```

The `read.dta()` function can only read data from Stata
versions 5--12.  The R Core Team has not been able to keep up with
changes in the Stata format. You may wish to try the `haven`
package and the `readstata13` package, both available from
CRAN.

## Summary

In this exercise we have seen how to create a data frame in `R`
from an external text file. We have also reviewed some common mistakes
that result in garbled data.

The capabilities of the `foreign` package for reading binary
data have also been demonstrated with a sample Stata data set.


