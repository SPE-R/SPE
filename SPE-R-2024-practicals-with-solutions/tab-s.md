

# Tabulation

## Introduction

`R` and its add-on packages provide several different
tabulation functions with different capabilities.  The appropriate function
to use depends on your goal. There are at least three different uses for
tables.

The first use is to create simple summary statistics that will be used
for further calculations in `R`. For example,
a two-by-two table created by the `table` function can be passed
to `fisher.test`, which will calculate odds ratios and confidence
intervals.  The appearance of these tables may, however, be quite basic,
as their principal goal is to create new objects for future calculations.

A quite different use of tabulation is to make *production quality*
tables for publication.  You may want to generate reports from for
publication in paper form, or on the World Wide Web.  The package
`xtable` provides this capability, but it is not covered by this course.

An intermediate use of tabulation functions is to create human-readable
tables for discussion within your work-group, but not for publication. The
`Epi` package provides a function `stat.table` for this purpose,
and this practical is designed to introduce this function.

## The births data

We shall use the births data which concern 500 mothers who had
singleton births in a large London hospital. The outcome of interest
is the birth weight of the baby, also dichotomised as normal or low
birth weight. These data are available in the Epi package:

``` r
library(Epi)
data(births)
names(births)
```

```
## [1] "id"      "bweight" "lowbw"   "gestwks" "preterm" "matage"  "hyp"    
## [8] "sex"
```

``` r
head(births)
```

```
##   id bweight lowbw gestwks preterm matage hyp sex
## 1  1    2974     0   38.52       0     34   0   2
## 2  2    3270     0      NA      NA     30   0   1
## 3  3    2620     0   38.15       0     35   0   2
## 4  4    3751     0   39.80       0     31   0   1
## 5  5    3200     0   38.89       0     33   1   1
## 6  6    3673     0   40.97       0     33   0   2
```
In order to work with this data set we need to transform some of the variables
into factors. This is done with the following commands:

``` r
births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
births$sex <- factor(births$sex, labels = c("M", "F"))
births$agegrp <- 
  cut(
    births$matage, 
    breaks = c(20, 25, 30, 35, 40, 45), 
    right = FALSE
  )
births$gest4 <- 
  cut(
    births$gestwks, 
    breaks = c(20, 35, 37, 39, 45), 
    right = FALSE
  )
```
Now use `str(births)` to examine the modified data frame. We have
transformed the binary variables `hyp` and `sex` into factors
with informative labels. This will help when displaying the tables. We
have also created grouped variables `agegrp` and `gest4` from
the continuous variables `matage` and `gestwks` so that they
can be tabulated.

## One-way tables

The simplest table one-way table is created by

``` r
stat.table(index = sex, data = births)
```

```
##  -------------- 
##  sex   count()  
##  -------------- 
##  M         264  
##  F         236  
##  --------------
```
This creates a count of individuals, classified by levels of the
factor `sex`.  Compare this table with the equivalent one produced
by the `table` function.  Note that `stat.table` has a 
`data` argument that allows you to use variables in a data frame without
specifying the frame.

You can display several summary statistics in the same table by
giving a list of expressions to the `contents` argument:

``` r
stat.table(
  index = sex, 
  contents = list(count(), percent(sex)), 
  data = births
)
```

```
##  --------------------------- 
##  sex   count() percent(sex)  
##  --------------------------- 
##  M         264         52.8  
##  F         236         47.2  
##  ---------------------------
```
Only a limited set of expressions are allowed: see the help page
for `stat.table` for details.

You can also calculate marginal tables by specifying `margin=TRUE`
in your call to `stat.table`.  Do this for the above table. Check
that the percentages add up to 100 and the total for `count()` is the
same as the number of rows of the data frame `births`.

```
##  ----------------------------- 
##  sex     count() percent(sex)  
##  ----------------------------- 
##  M           264         52.8  
##  F           236         47.2  
##                                
##  Total       500        100.0  
##  -----------------------------
```
To see how the mean birth weight changes with `sex`, try

``` r
stat.table(index = sex, contents = mean(bweight), data = births)
```

```
##  -------------------- 
##  sex   mean(bweight)  
##  -------------------- 
##  M           3229.90  
##  F           3032.83  
##  --------------------
```

Add the count to this table. Add also the margin with `margin=TRUE`. 

```
##  ------------------------------ 
##  sex     count() mean(bweight)  
##  ------------------------------ 
##  M           264       3229.90  
##  F           236       3032.83  
##                                 
##  Total       500       3136.88  
##  ------------------------------
```
As an alternative to `bweight` we can look at `lowbw` with

``` r
stat.table(index = sex, contents = percent(lowbw), data = births)
```

```
##  --------------------- 
##  sex   percent(lowbw)  
##  --------------------- 
##  M              100.0  
##  F              100.0  
##  ---------------------
```
All the percentages are 100! To use the `percent` function the variable `lowbw` must also be in the index, as in

``` r
stat.table(
  index = list(sex, lowbw), 
  contents = percent(lowbw), 
  data = births
)
```

```
##  ---------------------- 
##       ------lowbw------ 
##  sex         0       1  
##  ---------------------- 
##  M        89.8    10.2  
##  F        86.0    14.0  
##  ----------------------
```
The final column is the percentage of babies with low birth weight by different categories of gestation.


-  Obtain a table showing the frequency distribution of `gest4`.
-  Show how the mean birth weight changes with `gest4`.
-  Show how the percentage of low birth weight babies changes with `gest4`.


```
##  ------------------ 
##  gest4     count()  
##  ------------------ 
##  [20,35)        31  
##  [35,37)        32  
##  [37,39)       167  
##  [39,45)       260  
##  ------------------
```

```
##  ------------------------ 
##  gest4     mean(bweight)  
##  ------------------------ 
##  [20,35)         1733.74  
##  [35,37)         2590.31  
##  [37,39)         3093.77  
##  [39,45)         3401.26  
##  ------------------------
```

```
##  ---------------------------------------- 
##         --------------gest4-------------- 
##  lowbw   [20,35) [35,37) [37,39) [39,45)  
##  ---------------------------------------- 
##  0          19.4    59.4    89.2    98.8  
##  1          80.6    40.6    10.8     1.2  
##  ----------------------------------------
```

Another way of obtaining the percentage of low birth weight babies by
gestation is to use the ratio function:

``` r
stat.table(gest4, ratio(lowbw, 1, 100), data = births)
```

```
##  ----------------------- 
##  gest4     ratio(lowbw,  
##                 1, 100)  
##  ----------------------- 
##  [20,35)          80.65  
##  [35,37)          40.62  
##  [37,39)          10.78  
##  [39,45)           1.15  
##  -----------------------
```
This only works because `lowbw` is coded 0/1, with 1 for low birth
weight.

Tables of odds can be produced in the same way by using 
`ratio(lowbw, 1-lowbw)`. The `ratio` function is also very useful
for making tables of rates with (say) `ratio(D,Y,1000)` where 
`D` is the number of failures, and `Y` is the follow-up time. We
shall return to rates in a later practical.

## Improving the Presentation of Tables

The `stat.table` function provides default column headings based
on the `contents` argument, but these are not always very informative.
Supply your own column headings using *tagged* lists as the
value of the `contents` argument, within a `stat.table` call:

``` r
stat.table(gest4, contents = list(
  N = count(),
  "(%)" = percent(gest4)
), data = births)
```

```
##  -------------------------- 
##  gest4           N     (%)  
##  -------------------------- 
##  [20,35)        31     6.3  
##  [35,37)        32     6.5  
##  [37,39)       167    34.1  
##  [39,45)       260    53.1  
##  --------------------------
```
This improves the readability of the table.  It remains to give an
informative title to the index variable. You can do this in the same way:
instead of giving `gest4` as the `index` argument to `stat.table`,
use a named list:

``` r
stat.table(index = list("Gestation time" = gest4), data = births)
```

```
##  -------------------- 
##  Gestation   count()  
##  time                 
##  -------------------- 
##  [20,35)          31  
##  [35,37)          32  
##  [37,39)         167  
##  [39,45)         260  
##  --------------------
```

## Two-way Tables

The following call gives a $2\times 2$ table showing the mean birth weight
cross-classified by `sex` and `hyp`.

``` r
stat.table(
  list(sex, hyp), 
  contents = mean(bweight), 
  data = births
)
```

```
##  ---------------------- 
##       -------hyp------- 
##  sex    normal   hyper  
##  ---------------------- 
##  M     3310.75 2814.40  
##  F     3079.50 2699.72  
##  ----------------------
```
Add the count to this table and repeat the function call using `margin = TRUE` to calculate the
marginal tables.

```
##  -------------------------------- 
##         -----------hyp----------- 
##  sex      normal   hyper   Total  
##  -------------------------------- 
##  M           221      43     264  
##          3310.75 2814.40 3229.90  
##                                   
##  F           207      29     236  
##          3079.50 2699.72 3032.83  
##                                   
##                                   
##  Total       428      72     500  
##          3198.90 2768.21 3136.88  
##  --------------------------------
```
Use `stat.table` with the ratio function to obtain a $2\times 2$ table of percent low birth weight by `sex` and `hyp`.

```
##  -------------------------------- 
##         -----------hyp----------- 
##  sex      normal   hyper   Total  
##  -------------------------------- 
##  M           221      43     264  
##          3310.75 2814.40 3229.90  
##                                   
##  F           207      29     236  
##          3079.50 2699.72 3032.83  
##                                   
##                                   
##  Total       428      72     500  
##          3198.90 2768.21 3136.88  
##  --------------------------------
```

```
##  -------------------------------- 
##         -----------hyp----------- 
##  sex      normal   hyper   Total  
##  -------------------------------- 
##  M           221      43     264  
##             6.79   27.91   10.23  
##                                   
##  F           207      29     236  
##            12.08   27.59   13.98  
##                                   
##                                   
##  Total       428      72     500  
##             9.35   27.78   12.00  
##  --------------------------------
```
You can have fine-grained control over which margins to calculate by
giving a logical vector to the `margin` argument.  Use `margin=c(FALSE, TRUE)`
to calculate margins over `sex` but not
`hyp`. This might not be what you expect, but the `margin`
argument indicates which of the index variables are to be `marginalized out`, 
not which index variables are to remain.

## Printing

Just like every other `R` function, `stat.table` produces
an object that can be saved and printed later, or used for further
calculation.  You can control the appearance of a table with an explicit
call to `print()`

There are two arguments to the print method for `stat.table`. The
`width` argument which specifies the minimum column width, and the
`digits` argument which controls
the number of digits printed after the decimal point. This table

``` r
odds.tab <- 
  stat.table(
    gest4, 
    list("odds of low bw" = ratio(lowbw, 1 - lowbw)),
    data = births
)
print(odds.tab)
```

```
##  ------------------ 
##  gest4     odds of  
##             low bw  
##  ------------------ 
##  [20,35)      4.17  
##  [35,37)      0.68  
##  [37,39)      0.12  
##  [39,45)      0.01  
##  ------------------
```
shows a table of odds that the baby has low birth weight. Use
`width=15` and `digits=3` and see the difference.

```
##  -------------------------- 
##  gest4      odds of low bw  
##  -------------------------- 
##  [20,35)             4.167  
##  [35,37)             0.684  
##  [37,39)             0.121  
##  [39,45)             0.012  
##  --------------------------
```




