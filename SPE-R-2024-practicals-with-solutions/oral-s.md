---
output:
  html_document: default
  pdf_document: default
---



# Survival analysis with competing risks: Oral cancer patients


## Description of the data

File `oralca2.txt`, that you may
access from a url address to be given in the practical, contains data from 338
patients having an oral squamous cell carcinoma diagnosed and treated
in one tertiary level oncological clinic in Finland since 1985, followed-up
for mortality until 31 December 2008. 

The dataset contains the following variables:

| Variable | Description                                               |
| :------- | :-------------------------------------------------------- |
| `sex`    | sex, a factor with categories; `1 = "Female", 2 = "Male"` |
| `age`    | age (years) at the date of diagnosing the cancer |
| `stage`  | TNM stage of the tumour (factor): `1 = "I", ..., 4 = "IV", 5 = "unkn"` |
| `time`   | follow-up time (in years) since diagnosis until death or censoring |
| `event`  | event ending the follow-up (numeric): `0 = censoring alive, 1 = death from oral cancer, 2 = death from other causes.` |


## Loading the packages and the data


-  Load the R packages `Epi`, and `survival` needed in this exercise.


``` r
library(Epi)
library(survival)
cB8  <- c("#000000", "#E69F00", "#56B4E9", "#009E73", 
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7") #colors chosen
options(digits=3)
```

-  Read the datafile `oralca2.txt` from
a website, whose precise address  will be given in the practical,
 into an R data frame named `orca`.
Look at the head, structure and the summary of the data frame.
Using function `table()` count the numbers of censorings
as well as deaths from oral cancer and other causes, respectively,
 from the `event` variable.

``` r
orca <-  read.table(file = 'https://raw.githubusercontent.com/SPE-R/SPE/master/pracs/data/oralca2.txt', header = TRUE, sep = " ",row.names = 1 )
head(orca)
```

```
##      sex  age stage  time event
## 1   Male 65.4  unkn 5.081     0
## 2 Female 83.1   III 0.419     1
## 3   Male 52.6    II 7.915     2
## 4   Male 77.1     I 2.480     2
## 5   Male 80.3    IV 2.500     1
## 6 Female 82.6    IV 0.167     2
```

``` r
orca$stage<-as.factor(orca$stage)
orca$sex<-factor(orca$sex,levels=c("Male","Female"))
str(orca)
```

```
## 'data.frame':	338 obs. of  5 variables:
##  $ sex  : Factor w/ 2 levels "Male","Female": 1 2 1 1 1 2 1 1 2 1 ...
##  $ age  : num  65.4 83.1 52.6 77.1 80.3 ...
##  $ stage: Factor w/ 5 levels "I","II","III",..: 5 3 2 1 4 4 2 5 4 2 ...
##  $ time : num  5.081 0.419 7.915 2.48 2.5 ...
##  $ event: int  0 1 2 2 1 2 0 1 1 0 ...
```

``` r
summary(orca)
```

```
##      sex           age        stage         time           event      
##  Male  :186   Min.   :15.2   I   :50   Min.   : 0.09   Min.   :0.000  
##  Female:152   1st Qu.:53.2   II  :77   1st Qu.: 1.33   1st Qu.:0.000  
##               Median :64.9   III :72   Median : 3.87   Median :1.000  
##               Mean   :63.5   IV  :68   Mean   : 5.66   Mean   :0.994  
##               3rd Qu.:74.3   unkn:71   3rd Qu.: 8.42   3rd Qu.:2.000  
##               Max.   :92.2             Max.   :23.26   Max.   :2.000
```


## Total mortality: Kaplan--Meier analyses


-  We start our analysis of total mortality pooling the two causes of death into
a single outcome.
First, construct a *survival object* `orca$suob` from
the event variable and the follow-up time using function `Surv()`.
Look at the structure and summary of `!orca$suob!` .

``` r
suob <- Surv(orca$time, 1 * (orca$event > 0))
str(orca$suob)
```

```
##  NULL
```

``` r
summary(orca$suob)
```

```
## Length  Class   Mode 
##      0   NULL   NULL
```

-  Create a `survfit` object `s.all`, which does the
default calculations for a Kaplan--Meier
analysis of the overall (marginal) survival curve.

``` r
s.all <- survfit(suob ~ 1, data = orca)
```

See the structure of this object and apply `print()` method on it, too.
Look at the results; what do you find?
% Try also `summary()` and see the outcome.

``` r
s.all
```

```
## Call: survfit(formula = suob ~ 1, data = orca)
## 
##        n events median 0.95LCL 0.95UCL
## [1,] 338    229   5.42    4.33    6.92
```

``` r
str(s.all)
```

```
## List of 16
##  $ n        : int 338
##  $ time     : num [1:251] 0.085 0.162 0.167 0.17 0.246 0.249 0.252 0.329 0.334 0.413 ...
##  $ n.risk   : num [1:251] 338 336 334 330 328 327 326 323 322 321 ...
##  $ n.event  : num [1:251] 2 2 4 2 1 1 3 1 1 1 ...
##  $ n.censor : num [1:251] 0 0 0 0 0 0 0 0 0 0 ...
##  $ surv     : num [1:251] 0.994 0.988 0.976 0.97 0.967 ...
##  $ std.err  : num [1:251] 0.0042 0.00595 0.00847 0.0095 0.00998 ...
##  $ cumhaz   : num [1:251] 0.00592 0.01187 0.02385 0.02991 0.03295 ...
##  $ std.chaz : num [1:251] 0.00418 0.00593 0.00843 0.00946 0.00994 ...
##  $ type     : chr "right"
##  $ logse    : logi TRUE
##  $ conf.int : num 0.95
##  $ conf.type: chr "log"
##  $ lower    : num [1:251] 0.986 0.977 0.96 0.953 0.949 ...
##  $ upper    : num [1:251] 1 1 0.993 0.989 0.987 ...
##  $ call     : language survfit(formula = suob ~ 1, data = orca)
##  - attr(*, "class")= chr "survfit"
```

- 
The `summary` method for
 a  `survfit` object would return a lengthy life table.
However, the `plot` method with default
arguments offers the Kaplan--Meier curve
for a conventional illustration of the survival experience in the whole patient group.
 Alternatively, instead of graphing survival proportions,
one can draw a curve describing their complements: the cumulative mortality proportions. This curve is drawn together with the survival curve as the
 result of the second command line below.


``` r
plot(s.all,main="KM estimate of the survival
     and cum. mortality proportions",
     xlab="years", ylab="Survival")
```

![](oral-s_files/figure-epub3/survcdf1-1.png)<!-- -->

``` r
plot(s.all)
lines(s.all, fun = "event", mark.time = F, conf.int = FALSE)
```

![](oral-s_files/figure-epub3/survcdf1-2.png)<!-- -->

The effect of option `mark.time=F` is to omit
marking the times when censorings occurred.


## Total mortality by stage

Tumour stage is an important prognostic factor in cancer survival.

- stage I: cancer hasn't spread to lymph nodes or other tissue (local),\
stage II: cancer has grown but not spread \
stage III:cancer has grown larger but not spread \
stage IV cancer has spread to other organs or areas

-  Plot separate cumulative mortality curves for the different stage groups
marking them with different colors, the order which you may define yourself.
Also find the median survival time for each stage.

``` r
s.stg <- survfit(suob ~ stage, data = orca)
col5 <- cB8[1:5]
plot(s.stg, col = col5, fun = "event", main="Cum. mortality by stage",mark.time = FALSE)
legend(15, 0.6, title="stage",legend=levels(orca$stage),col = col5,lty=rep(1,5))
```

![](oral-s_files/figure-epub3/cdfstage-1.png)<!-- -->

- Create now two parallel plots of which the first one describes the
cumulative hazards
and the second one graphs the log-cumulative hazards against log-time
for the different stages. Compare the two presentations
with each other and with the one in the previous item.

``` r
par(mfrow = c(1, 2))
plot(s.stg, col = col5, fun = "cumhaz", main = "Cumulative hazards")
legend(1, 3.5, title="stage",legend=levels(orca$stage),col = col5,lty=rep(1,5), cex=0.8)
plot(s.stg, col = col5, fun = "cloglog",main = "cloglog: log cum.haz")
legend(3, -2, title="stage",legend=levels(orca$stage),col = col5,lty=rep(1,5), cex=0.7)
```

![](oral-s_files/figure-epub3/chstage-1.png)<!-- -->

-  If the survival times were *exponentially*
 distributed in a given (sub)population
 the corresponding cloglog-curve should follow an approximately linear pattern.
Could this be the case here in the different stages?

-  Also, if the survival distributions of the different subpopulations would
obey the *proportional hazards* model, the vertical distance between the
cloglog-curves should be approximately constant over the time axis.
Do these curves indicate serious deviation from the proportional hazards assumption?

-  In the lecture handouts it was observed that
the crude contrast between males and females in total mortality appears
unclear, but the age-adjustment in the Cox model provided a more
expected hazard ratio estimate.
We shall examine the confounding by age somewhat closer.
First categorize the continuous age variable
into, say, three categories by function `cut()`
using suitable breakpoints, like 55 and 75 years, and
cross-tabulate sex and age group:

``` r
orca$agegr <- cut(orca$age, br = c(0, 55, 75, 95))
stat.table(list(sex, agegr), list(count(), percent(agegr)),
  margins = TRUE, 
  data = orca
)
```

```
##  ----------------------------------------- 
##          --------------agegr-------------- 
##  sex       (0,55] (55,75] (75,95]   Total  
##  ----------------------------------------- 
##  Male          71      86      29     186  
##              38.2    46.2    15.6   100.0  
##                                            
##  Female        29      74      49     152  
##              19.1    48.7    32.2   100.0  
##                                            
##                                            
##  Total        100     160      78     338  
##              29.6    47.3    23.1   100.0  
##  -----------------------------------------
```
Male patients are clearly younger than females in these data.

Now, plot Kaplan--Meier curves jointly classified by sex and age.


``` r
s.agrx <- survfit(suob ~ agegr + sex, data=orca)
par(mfrow=c(1,1))
plot(s.agrx, fun="event", main="Cumulative mortality (KM) by age and sex",xlab="Time since oral cancer diagnosis (years)",ylab="Cum. mortality",mark.time=F, xlim = c(0,15), lwd=2,
             col=rep(c(cB8[7], cB8[6]),3), lty=c(2,2, 1,1, 5,5), pch=c(1,1,2,2,4,4), xaxs="i",yaxs="i")
legend(12,0.35, legend=c("(0,55] Female "," (0,55] Male",
                       "(55,75] Female "," (55,75] Male",
                       "(75,95] Female "," (75,95] Male" ),
       col=rep(c(cB8[7], cB8[6]),3), lty=c(2,2, 1,1, 5,5),
       pch=c(1,1,2,2,4,4),cex=0.65)
```

![](oral-s_files/figure-epub3/cdfsexage-1.png)<!-- -->

In each age band the mortality curve for males is on a higher level
than that for females.

## Event-specific cumulative mortality curves

We move on to analysing cumulative mortalities for the
 two causes of death separately, first overall and then
 by prognostic factors.

- Use the `survfit`-function in `survival` package with option `type="mstate"`. 


``` r
library(survival)
cif1 <- survfit(Surv(time, event, type = "mstate") ~ 1,
  data = orca
)
str(cif1)
```

```
## List of 23
##  $ n           : int 338
##  $ time        : num [1:251] 0.085 0.162 0.167 0.17 0.246 0.249 0.252 0.329 0.334 0.413 ...
##  $ n.risk      : num [1:251, 1:3] 338 336 334 330 328 327 326 323 322 321 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ n.event     : num [1:251, 1:3] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ n.censor    : num [1:251, 1:3] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ pstate      : num [1:251, 1:3] 0.994 0.988 0.976 0.97 0.967 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ n.transition: num [1:251, 1:2] 2 2 2 1 1 0 2 1 1 1 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:2] "1.2" "1.3"
##  $ n.id        : int 338
##  $ cumhaz      : num [1:251, 1:2] 0.00592 0.01187 0.01786 0.02089 0.02394 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:2] "1.2" "1.3"
##  $ p0          : Named num [1:3] 1 0 0
##   ..- attr(*, "names")= chr [1:3] "(s0)" "1" "2"
##  $ std.err     : num [1:251, 1:3] 0.00417 0.00588 0.00827 0.00922 0.00965 ...
##  $ std.chaz    : num [1:251, 1:2] 0.00417 0.00592 0.00727 0.00787 0.00844 ...
##  $ std.auc     : num [1:251, 1:3] 0 0.000321 0.000343 0.000356 0.000934 ...
##  $ logse       : logi FALSE
##  $ transitions : 'table' int [1:3, 1:3] 122 0 0 107 0 0 109 0 0
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ from: chr [1:3] "(s0)" "1" "2"
##   .. ..$ to  : chr [1:3] "1" "2" "(censored)"
##  $ lower       : num [1:251, 1:3] 0.986 0.977 0.96 0.953 0.949 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ upper       : num [1:251, 1:3] 1 1 0.993 0.989 0.987 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ conf.type   : chr "log"
##  $ conf.int    : num 0.95
##  $ states      : chr [1:3] "(s0)" "1" "2"
##  $ type        : chr "mright"
##  $ t0          : num 0
##  $ call        : language survfit(formula = Surv(time, event, type = "mstate") ~ 1, data = orca)
##  - attr(*, "class")= chr [1:2] "survfitms" "survfit"
```

- One could apply here the plot method of the survfit object to plot the 
cumulative incidences for each cause. However, we suggest that you use 
instead a simple function `plotCIF()` found in the `Epi` package.
The main arguments are

|         |                                             |
| :------ | :------------------------------------------ |
| `data ` | data frame created by function }`survfit()` |
| `event` | indicator for the event: values 1 or 2.     |

Other arguments are like in the ordinary `plot()` function.

- Draw two parallel plots describing
the overall cumulative incidence curves for both causes of death

``` r
par(mfrow = c(1, 2))
plotCIF(cif1, 1, main = "Cancer death",xlab="Time since oral cancer diagnosis (years)")
plotCIF(cif1, 2, main = "Other deaths",xlab="Time since oral cancer diagnosis (years)")
```

![](oral-s_files/figure-epub3/plotcif1-1.png)<!-- -->

- Compute the estimated
cumulative incidences by stage for both causes of death.
Now you have to add variable `stage` to survfit-function. 

See the structure of the resulting object, in which you should
observe strata variable containing the stage grouping variable. Plot the pertinent curves in two parallel graphs.
Cut the $y$-axis for a more efficient graphical presentation


``` r
col5 <- col5
cif2 <- survfit(Surv(time, event, type = "mstate") ~ stage,
  data = orca
)
str(cif2)
```

```
## List of 24
##  $ n           : int [1:5] 50 77 72 68 71
##  $ time        : num [1:307] 0.17 0.498 0.665 0.832 1.166 ...
##  $ n.risk      : num [1:307, 1:3] 50 49 48 47 46 45 44 43 42 41 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ n.event     : num [1:307, 1:3] 0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ n.censor    : num [1:307, 1:3] 0 0 0 0 0 0 1 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ pstate      : num [1:307, 1:3] 0.98 0.96 0.94 0.92 0.9 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ n.transition: num [1:307, 1:2] 0 1 1 0 1 1 0 1 1 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:2] "1.2" "1.3"
##  $ n.id        : int [1:5] 50 77 72 68 71
##  $ cumhaz      : num [1:307, 1:2] 0 0.0204 0.0412 0.0412 0.063 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:2] "1.2" "1.3"
##  $ p0          : num [1:5, 1:3] 1 1 1 1 1 0 0 0 0 0 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:5] "stage=I" "stage=II" "stage=III" "stage=IV" ...
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ strata      : Named int [1:5] 49 75 62 58 63
##   ..- attr(*, "names")= chr [1:5] "stage=I" "stage=II" "stage=III" "stage=IV" ...
##  $ std.err     : num [1:307, 1:3] 0.0198 0.0277 0.0336 0.0384 0.0424 ...
##  $ std.chaz    : num [1:307, 1:2] 0 0.0202 0.0289 0.0289 0.036 ...
##  $ std.auc     : num [1:307, 1:3] 0 0.00649 0.01028 0.01484 0.02589 ...
##  $ logse       : logi FALSE
##  $ transitions : 'table' int [1:3, 1:3] 122 0 0 107 0 0 109 0 0
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ from: chr [1:3] "(s0)" "1" "2"
##   .. ..$ to  : chr [1:3] "1" "2" "(censored)"
##  $ lower       : num [1:307, 1:3] 0.942 0.907 0.876 0.848 0.821 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ upper       : num [1:307, 1:3] 1 1 1 0.998 0.987 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : NULL
##   .. ..$ : chr [1:3] "(s0)" "1" "2"
##  $ conf.type   : chr "log"
##  $ conf.int    : num 0.95
##  $ states      : chr [1:3] "(s0)" "1" "2"
##  $ type        : chr "mright"
##  $ t0          : num 0
##  $ call        : language survfit(formula = Surv(time, event, type = "mstate") ~ stage, data = orca)
##  - attr(*, "class")= chr [1:2] "survfitms" "survfit"
```

``` r
par(mfrow = c(1, 2))
plotCIF(cif2, 1,
  main = "Cancer death by stage",
  col = col5, ylim = c(0, 0.7)
)
plotCIF(cif2, 2,
  main = "Other deaths by stage",
  col = col5, ylim = c(0, 0.7)
)

legend(3, 0.7, title="stage",legend=levels(orca$stage),col = col5,lty=rep(1,5), cex=0.7)
```

![](oral-s_files/figure-epub3/plotcif2-1.png)<!-- -->

Compare the two plots. What would you conclude about the
effect of stage on the two causes of death?

-  Using another function `stackedCIF()` in `Epi` you can 
put the two cumulative incidence curves in one graph but stacked upon one another such that
the lower curve is for the cancer deaths and the upper curve is for total mortality,
and the vertical difference between the two curves describes the
cumulative mortality from other causes. You can also add some colours for the different zones: 


``` r
par(mfrow=c(1,1),xaxs="i", yaxs="i") # make plot start 0,0
stackedCIF(cif1,xlim=c(0,20),
           col = c("black"),
           fill=c(cB8[6],cB8[8],cB8[2])) #choosing some colors 
text( 10, 0.10, "Oral ca death ", pos = 4)
text( 10, 0.5, " Other death ", pos = 4)
text( 10, 0.80, " Alive ", pos = 4)
```

![](oral-s_files/figure-epub3/stackedcif1-1.png)<!-- -->

## Regression modelling of overall mortality.

- Fit the semiparametric proportional hazards
 regression model, a.k.a. the Cox model, on all deaths including
 sex, age and stage as covariates. Use function
 `coxph()` in package `survival`.
 It is often useful to center and scale
continuous covariates like `age` here.
The estimated rate ratios and their confidence intervals
can also here be displayed  by applying `ci.lin()`
on the fitted model object.

``` r
options(show.signif.stars = FALSE)
m1 <- coxph(suob ~ sex + I((age - 65) / 10) + stage, data = orca)
summary(m1)
```

```
## Call:
## coxph(formula = suob ~ sex + I((age - 65)/10) + stage, data = orca)
## 
##   n= 338, number of events= 229 
## 
##                     coef exp(coef) se(coef)     z Pr(>|z|)
## sexFemale        -0.3514    0.7037   0.1414 -2.49  0.01295
## I((age - 65)/10)  0.4160    1.5159   0.0564  7.37  1.6e-13
## stageII           0.0349    1.0355   0.2467  0.14  0.88742
## stageIII          0.3454    1.4126   0.2457  1.41  0.15971
## stageIV           0.8854    2.4240   0.2427  3.65  0.00026
## stageunkn         0.5844    1.7939   0.2512  2.33  0.02002
## 
##                  exp(coef) exp(-coef) lower .95 upper .95
## sexFemale            0.704      1.421     0.533     0.928
## I((age - 65)/10)     1.516      0.660     1.357     1.693
## stageII              1.036      0.966     0.639     1.679
## stageIII             1.413      0.708     0.873     2.286
## stageIV              2.424      0.413     1.506     3.901
## stageunkn            1.794      0.557     1.096     2.935
## 
## Concordance= 0.674  (se = 0.02 )
## Likelihood ratio test= 86.8  on 6 df,   p=<2e-16
## Wald test            = 80.5  on 6 df,   p=3e-15
## Score (logrank) test = 82.9  on 6 df,   p=9e-16
```

``` r
round(ci.exp(m1),3)
```

```
##                  exp(Est.)  2.5% 97.5%
## sexFemale            0.704 0.533 0.928
## I((age - 65)/10)     1.516 1.357 1.693
## stageII              1.036 0.639 1.679
## stageIII             1.413 0.873 2.286
## stageIV              2.424 1.506 3.901
## stageunkn            1.794 1.096 2.935
```

Look at the results. What are the main findings?


-  Check whether the data are sufficiently consistent with the
assumption of proportional hazards with respect to each of
the variables separately
as well as globally, using the `cox.zph()` function.

``` r
cox.zph(m1)
```

```
##                  chisq df    p
## sex              0.275  1 0.60
## I((age - 65)/10) 1.706  1 0.19
## stage            3.648  4 0.46
## GLOBAL           5.144  6 0.53
```

- No evidence against proportionality assumption could apparently be found.
Moreover, no difference can be observed between stages I and II in the estimates.
 On the other hand, the
group with stage unknown is a complex mixture of patients from various
true stages. Therefore, it may be prudent to exclude these subjects from the data
and to pool the first two stage groups into one. After that fit a model in
the reduced data with the new stage variable.

``` r
orca2 <- subset(orca, stage != "unkn")
orca2$st3 <- Relevel(orca2$stage, list(1:2, 3, 4:5))
levels(orca2$st3) <- c("I-II", "III", "IV")
m2 <- coxph(Surv(orca2$time, 1 * (orca2$event > 0)) ~ sex + I((age - 65) / 10) + st3, data = orca2)
summary(m2)
```

```
## Call:
## coxph(formula = Surv(orca2$time, 1 * (orca2$event > 0)) ~ sex + 
##     I((age - 65)/10) + st3, data = orca2)
## 
##   n= 267, number of events= 184 
## 
##                     coef exp(coef) se(coef)     z Pr(>|z|)
## sexFemale        -0.2839    0.7528   0.1571 -1.81    0.071
## I((age - 65)/10)  0.3810    1.4637   0.0622  6.13  8.8e-10
## st3III            0.3117    1.3657   0.1827  1.71    0.088
## st3IV             0.8713    2.3900   0.1786  4.88  1.1e-06
## 
##                  exp(coef) exp(-coef) lower .95 upper .95
## sexFemale            0.753      1.328     0.553      1.02
## I((age - 65)/10)     1.464      0.683     1.296      1.65
## st3III               1.366      0.732     0.955      1.95
## st3IV                2.390      0.418     1.684      3.39
## 
## Concordance= 0.673  (se = 0.022 )
## Likelihood ratio test= 64.8  on 4 df,   p=3e-13
## Wald test            = 62.3  on 4 df,   p=1e-12
## Score (logrank) test = 64.3  on 4 df,   p=4e-13
```

``` r
#m2 <- update(m1, . ~ . - stage + st3, data = orca2) #do not work
round(ci.exp(m2), 3)
```

```
##                  exp(Est.)  2.5% 97.5%
## sexFemale            0.753 0.553  1.02
## I((age - 65)/10)     1.464 1.296  1.65
## st3III               1.366 0.955  1.95
## st3IV                2.390 1.684  3.39
```

- Plot the predicted cumulative mortality curves by stage,
jointly stratified by sex and age, focusing
only on 40 and 80 year old patients, respectively,
based on the fitted model `m2`.
You need to create a new artificial data frame
containing the desired values for the covariates.

``` r
newd <- data.frame(
  sex = c(rep("Male", 6), rep("Female", 6)),
  age = rep(c(rep(40, 3), rep(80, 3)), 2),
  st3 = rep(levels(orca2$st3), 4)
)
newd
```

```
##       sex age  st3
## 1    Male  40 I-II
## 2    Male  40  III
## 3    Male  40   IV
## 4    Male  80 I-II
## 5    Male  80  III
## 6    Male  80   IV
## 7  Female  40 I-II
## 8  Female  40  III
## 9  Female  40   IV
## 10 Female  80 I-II
## 11 Female  80  III
## 12 Female  80   IV
```

``` r
col3 <- cB8[1:3] #pre-setting color palette
leg<-levels(interaction(levels(factor(orca2$sex)),levels(orca2$st3))) #legend labels by sex and stage
```

```
## Warning in ans * length(l) + if1: longer object length is not a multiple of
## shorter object length
```

``` r
par(mfrow = c(1, 2))
plot(
  survfit(m2, newdata = subset(newd, sex == "Male" & age == 40)),
  col = col3, 
  lty= 1,
  fun = "event", mark.time = FALSE,
  main="Cum. mortality for M and F \n age 40"
  )
lines(
  survfit(m2, newdata = subset(newd, sex == "Female" & age == 40)),
  col = col3, lty=c(2,2,2),fun = "event", mark.time = FALSE
)
legend(0, 0.95, title="stage",legend=leg,
       col = c(col3[1],col3[1],col3[2],col3[2],col3[3],col3[3]),
        ,lty=c(2,1,2,1,2,1), cex=0.6)
plot(
  survfit(m2, newdata = subset(newd, sex == "Male" & age == 80)),
  ylim = c(0, 1), col = col3, fun = "event", mark.time = FALSE,
   main="Cum. mortality for M and F \n age 80"
)
lines(
  survfit(m2, newdata = subset(newd, sex == "Female" & age == 80)  ),
  col = col3, fun = "event", lty = 2, mark.time = FALSE
)
legend(10, 0.5, title="stage",legend=leg,
       col = c(col3[1],col3[1],col3[2],col3[2],col3[3],col3[3]),
        ,lty=c(2,1,2,1,2,1), cex=0.7)
```

![](oral-s_files/figure-epub3/cox2cll-1.png)<!-- -->



## Modelling event-specific hazards

- Fit the Cox model for the cause-specific hazard of cancer deaths
with the same covariates as above. In this case
only cancer deaths are counted as events and deaths from other causes
are included into censorings.

``` r
m2haz1 <- 
  coxph(
    Surv(time, event == 1) ~ sex + I((age - 65) / 10) + st3, 
    data = orca2
  )
round(ci.exp(m2haz1), 4)
```

```
##                  exp(Est.)  2.5% 97.5%
## sexFemale            0.983 0.642  1.51
## I((age - 65)/10)     1.426 1.204  1.69
## st3III               1.514 0.901  2.54
## st3IV                3.181 1.985  5.10
```

``` r
cox.zph(m2haz1)
```

```
##                   chisq df     p
## sex              0.0724  1 0.788
## I((age - 65)/10) 5.7620  1 0.016
## st3              3.4195  2 0.181
## GLOBAL           9.1216  4 0.058
```
Compare the results with those of model `m2`. What are the major differences?

- Fit a similar model for deaths from other causes and compare the results.

``` r
m2haz2 <- 
  coxph(
    Surv(time, event == 2) ~ sex + I((age - 65) / 10) + st3, 
    data = orca2
  )
round(ci.exp(m2haz2), 4)
```

```
##                  exp(Est.)  2.5% 97.5%
## sexFemale            0.552 0.352 0.868
## I((age - 65)/10)     1.488 1.249 1.772
## st3III               1.230 0.749 2.021
## st3IV                1.641 0.952 2.827
```

``` r
cox.zph(m2haz2)
```

```
##                   chisq df    p
## sex              0.4071  1 0.52
## I((age - 65)/10) 0.2435  1 0.62
## st3              0.0443  2 0.98
## GLOBAL           0.6444  4 0.96
```

<!-- % -  -->
<!-- % Finally, fit the Fine--Gray model for the hazard of the subdistribution -->
<!-- % for cancer deaths with the same covariates as above. For this you have to -->
<!-- % first load package `cmprsk`, containing the necessary function -->
<!-- % `crr()`, and attach the data frame. -->
<!-- % ```{r fg1, echo=T,eval=TRUE} -->
<!-- % library(cmprsk) -->
<!-- % attach(orca2) -->
<!-- % m2fg1 <- crr(time, event, cov1 = model.matrix(m2), failcode=1) -->
<!-- % summary(m2fg1, Exp=T) -->
<!-- % @ -->
<!-- %  -->
<!-- % Compare the results with those of model `m2` and `m2haz1`. -->
<!-- %  -->
<!-- % -  -->
<!-- %  Fit a similar model for deaths from other causes and compare the results. -->
<!-- % ```{r fg2, echo=T,eval=TRUE} -->
<!-- % m2fg2 <- crr(time, event, cov1 = model.matrix(m2), failcode=2) -->
<!-- % summary(m2fg2, Exp=T) -->
<!-- % @ -->




## Lexis object with multi-state set-up

Before entering to multi-state analyses, it might be instructive to apply some Lexis tools to illustrate the competing-risks set-up.
More detailed explanation of these tools will be given by Bendix later.

- Form a `Lexis` object from the data frame and
print a summary of it. We shall name the main (and only) time axis
in this object as `stime`.

``` r
orca.lex <- Lexis(
  exit = list(stime = time),
  exit.status = factor(event,
    labels = c("Alive", "Oral ca. death", "Other death")
  ),
  data = orca
)
```

```
## NOTE: entry.status has been set to "Alive" for all.
## NOTE: entry is assumed to be 0 on the stime timescale.
```

``` r
summary(orca.lex)
```

```
##        
## Transitions:
##      To
## From    Alive Oral ca. death Other death  Records:  Events: Risk time:
##   Alive   109            122         107       338      229       1914
##        
## Transitions:
##      To
## From     Persons:
##   Alive       338
```

-  Draw a box diagram of the two-state set-up of competing transitions. Run first th e following command line

``` r
boxes(orca.lex,boxpos = TRUE)
```

![](oral-s_files/figure-epub3/lexis-1.png)<!-- -->
Now, move the cursor to the point in the graphics window, at which you wish to put the box for *Alive*, and click. Next, move
the cursor to the point at which you wish to have the  box for *Oral ca. death*, and click. Finally, do the same with the box for *Other death*.
If you are not happy with the outcome, run the command line again and repeat the necessary mouse moves and clicks.


## Optional: Poisson regression as an alternative to Cox model

It can be shown that the Cox model with an unspecified form for the
baseline hazard $\lambda_0(t)$ is mathematically equivalent
to the following kind of Poisson regression model.
Time is treated as a categorical factor with
a dense division of the time axis
into disjoint intervals or *timebands* such that
only one outcome event occurs in each timeband.
The model formula contains this time factor plus the desired
explanatory terms.

A sufficient division of time axis is obtained by
first setting the break points
between adjacent timebands to be those time points at which an outcome event has been observed to occur. Then,
the pertinent `lexis` object is created
and after that it will be split according to those breakpoints.
Finally, the Poisson regression model is fitted
on the splitted `lexis` object using function `glm()` with appropriate specifications.

We shall now demonstrate the numerical equivalence of the Cox model
`m2haz1` for oral cancer mortality that was fitted above,
 and the corresponding Poisson regression.




-  First we form the necessary `lexis` object by just taking
 the relevant subset of the already available `orca.lex` object.
 Upon that the three-level stage factor `st3` is created
 as above.
 

``` r
orca2.lex <- subset(orca.lex, stage != "unkn")
orca2.lex$st3 <- Relevel(orca2.lex$stage, list(1:2, 3, 4:5))
levels(orca2.lex$st3) <- c("I-II", "III", "IV")
```
 Then, the break points of time axis are taken from
 the sorted event times, and the `lexis` object is
 split by those breakpoints. The `timeband` factor
 is defined according to the splitted survival times
 stored in variable `stime`.


``` r
cuts <- sort(orca2.lex$time[orca2.lex$event == 1])
orca2.spl <- 
  splitLexis(orca2.lex, br = cuts, time.scale = "stime")
orca2.spl$timeband <- as.factor(orca2.spl$stime)
```

As a result we now have an expanded
 `lexis` object in which each subject has several rows;
 as many rows as there are such timebands
 during which he/she is still at risk.
 The outcome status `lex.Xst` has value 0 in all those
 timebands, over which the subject stays alive, but assumes
 the value 1 or 2 at his/her last interval ending at the time of death.
 -- See now the structure of the splitted object.


``` r
str(orca2.spl)
```

```
## Classes 'Lexis' and 'data.frame':	12637 obs. of  13 variables:
##  $ lex.id  : int  2 2 2 2 2 2 3 3 3 3 ...
##  $ stime   : num  0 0.085 0.162 0.252 0.329 0.413 0 0.085 0.162 0.252 ...
##  $ lex.dur : num  0.085 0.077 0.09 0.077 0.084 0.006 0.085 0.077 0.09 0.077 ...
##  $ lex.Cst : Factor w/ 3 levels "Alive","Oral ca. death",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ lex.Xst : Factor w/ 3 levels "Alive","Oral ca. death",..: 1 1 1 1 1 2 1 1 1 1 ...
##  $ sex     : Factor w/ 2 levels "Male","Female": 2 2 2 2 2 2 1 1 1 1 ...
##  $ age     : num  83.1 83.1 83.1 83.1 83.1 ...
##  $ stage   : Factor w/ 5 levels "I","II","III",..: 3 3 3 3 3 3 2 2 2 2 ...
##  $ time    : num  0.419 0.419 0.419 0.419 0.419 ...
##  $ event   : int  1 1 1 1 1 1 2 2 2 2 ...
##  $ agegr   : Factor w/ 3 levels "(0,55]","(55,75]",..: 3 3 3 3 3 3 1 1 1 1 ...
##  $ st3     : Factor w/ 3 levels "I-II","III","IV": 2 2 2 2 2 2 1 1 1 1 ...
##  $ timeband: Factor w/ 72 levels "0","0.085","0.162",..: 1 2 3 4 5 6 1 2 3 4 ...
##  - attr(*, "breaks")=List of 1
##   ..$ stime: num [1:71] 0.085 0.162 0.252 0.329 0.413 0.419 0.496 0.498 0.504 0.58 ...
##  - attr(*, "time.scales")= chr "stime"
##  - attr(*, "time.since")= chr ""
```

``` r
head(orca2.spl)
```

```
##  lex.id stime lex.dur lex.Cst        lex.Xst    sex  age stage  time event
##       2  0.00    0.09   Alive          Alive Female 83.1   III 0.419     1
##       2  0.09    0.08   Alive          Alive Female 83.1   III 0.419     1
##       2  0.16    0.09   Alive          Alive Female 83.1   III 0.419     1
##       2  0.25    0.08   Alive          Alive Female 83.1   III 0.419     1
##       2  0.33    0.08   Alive          Alive Female 83.1   III 0.419     1
##       2  0.41    0.01   Alive Oral ca. death Female 83.1   III 0.419     1
##    agegr st3 timeband
##  (75,95] III        0
##  (75,95] III    0.085
##  (75,95] III    0.162
##  (75,95] III    0.252
##  (75,95] III    0.329
##  (75,95] III    0.413
```


-  We are ready to fit the desired Poisson model for oral cancer death
as the outcome. The splitted person-years are contained in `lex.dur`,
and the explanatory variables are the same as in model `m2haz1`.
-- This fitting may take some time ....

``` r
m2pois1 <- glm(
  1 * (lex.Xst == "Oral ca. death") ~
    -1 + timeband + sex + I((age - 65) / 10) + st3,
  family = poisson, offset = log(lex.dur), data = orca2.spl
)
```
We shall display the estimation results graphically for the baseline hazard (per 1000 person-years)  and numerically for the rate ratios associated with the covariates.
Before doing that it is useful to count the length `ntb` of the
 block occupied by baseline hazard in the whole vector of estimated parameters.
However, owing to how the splitting to timebands was done, the last regression
coefficient is necessarily
zero and better be omitted when displaying the results. Also, as each timeband
is quantitatively
named accoding to its leftmost point, it is good to compute the midpoint values `tbmid`
for the timebands

``` r
tb <- as.numeric(levels(orca2.spl$timeband))
ntb <- length(tb)
tbmid <- (tb[-ntb] + tb[-1]) / 2 # midpoints of the intervals
round(ci.exp(m2pois1), 3)
```

```
##                  exp(Est.)  2.5%  97.5%
## timeband0            0.049 0.012  0.208
## timeband0.085        0.028 0.004  0.202
## timeband0.162        0.024 0.003  0.180
## timeband0.252        0.029 0.004  0.214
## timeband0.329        0.027 0.004  0.198
## timeband0.413        1.508 0.529  4.296
## timeband0.419        0.030 0.004  0.223
## timeband0.496        2.352 0.561  9.861
## timeband0.498        0.396 0.054  2.905
## timeband0.504        0.031 0.004  0.231
## timeband0.58         0.799 0.109  5.863
## timeband0.583        0.804 0.109  5.899
## timeband0.586        0.809 0.110  5.936
## timeband0.589        0.064 0.015  0.268
## timeband0.665        0.408 0.056  2.997
## timeband0.671        0.032 0.004  0.239
## timeband0.747        0.836 0.114  6.135
## timeband0.75         0.419 0.057  3.074
## timeband0.756        0.068 0.016  0.286
## timeband0.83         1.300 0.177  9.528
## timeband0.832        0.064 0.015  0.267
## timeband0.914        1.798 0.430  7.518
## timeband0.917        0.067 0.016  0.279
## timeband0.999        0.102 0.031  0.333
## timeband1.081        6.652 2.934 15.080
## timeband1.084        0.110 0.034  0.359
## timeband1.166        1.012 0.138  7.408
## timeband1.169        0.075 0.018  0.312
## timeband1.251        0.038 0.005  0.279
## timeband1.333        1.066 0.146  7.805
## timeband1.336        0.084 0.020  0.349
## timeband1.413        1.319 0.316  5.501
## timeband1.418        1.130 0.155  8.260
## timeband1.421        0.021 0.003  0.156
## timeband1.58         0.017 0.004  0.070
## timeband1.999        0.053 0.007  0.387
## timeband2.067        0.037 0.005  0.271
## timeband2.166        1.838 0.251 13.445
## timeband2.168        1.234 0.169  9.029
## timeband2.171        0.023 0.003  0.171
## timeband2.33         0.044 0.006  0.322
## timeband2.415        0.089 0.021  0.373
## timeband2.5          0.025 0.003  0.181
## timeband2.661        0.044 0.006  0.324
## timeband2.752        0.017 0.002  0.122
## timeband2.998        0.013 0.002  0.094
## timeband3.329        0.716 0.098  5.243
## timeband3.335        0.026 0.004  0.193
## timeband3.502        0.056 0.008  0.410
## timeband3.581        0.740 0.101  5.420
## timeband3.587        0.019 0.003  0.137
## timeband3.833        0.014 0.002  0.103
## timeband4.17         0.030 0.004  0.220
## timeband4.331        0.009 0.001  0.064
## timeband4.914        0.034 0.005  0.250
## timeband5.079        0.015 0.002  0.108
## timeband5.503        0.007 0.001  0.050
## timeband6.587        0.049 0.007  0.363
## timeband6.749        0.051 0.007  0.373
## timeband6.913        2.910 0.397 21.316
## timeband6.916        0.022 0.003  0.161
## timeband7.329        0.023 0.003  0.171
## timeband7.748        0.045 0.006  0.328
## timeband7.984        0.010 0.001  0.075
## timeband9.084        0.015 0.002  0.113
## timeband9.919        0.031 0.004  0.223
## timeband10.42        0.013 0.002  0.098
## timeband11.671       0.241 0.033  1.761
## timeband11.748       0.015 0.002  0.106
## timeband13.166       0.136 0.019  0.992
## timeband13.333       0.062 0.008  0.448
## timeband13.755       0.000 0.000    Inf
## sexFemale            0.985 0.644  1.509
## I((age - 65)/10)     1.423 1.201  1.685
## st3III               1.509 0.898  2.535
## st3IV                3.178 1.983  5.093
```

``` r
par(mfrow = c(1, 1))
plot(tbmid, 1000 * exp(coef(m2pois1)[1:(ntb - 1)]),
  ylim = c(5, 3000), log = "xy", type = "l"
)
```

![](oral-s_files/figure-epub3/poissonresults-1.png)<!-- -->

Compare the regression coefficients and their error margins
to those model `m2haz1`. Do you find any differences?
How does the estimated baseline hazard look like?

-  The estimated baseline looks quite ragged when based on 71 separate
parameters. A smoothed estimate may be obtained by spline modelling using the tools
contained in package `splines` (see the practical of Saturday 25 May afternoon).
With the following code you will be able to fit a
reasonable spline model for the baseline hazard and
draw the estimated curve (together with a band of the 95%
confidence limits about the fitted values).
From the same model you should also obtain quite familiar results for the
rate ratios of interest.

``` r
library(splines)
m2pspli <- 
  update(
    m2pois1, 
    . ~ ns(stime, df = 6, intercept = FALSE) +
      sex + I((age - 65) / 10) + st3)
round(ci.exp(m2pspli), 3)
```

```
##                                       exp(Est.)  2.5%  97.5%
## (Intercept)                               0.028 0.008  0.103
## ns(stime, df = 6, intercept = FALSE)1     6.505 1.776 23.823
## ns(stime, df = 6, intercept = FALSE)2     2.678 0.560 12.803
## ns(stime, df = 6, intercept = FALSE)3     0.976 0.227  4.187
## ns(stime, df = 6, intercept = FALSE)4     0.423 0.105  1.699
## ns(stime, df = 6, intercept = FALSE)5     1.567 0.082 29.939
## ns(stime, df = 6, intercept = FALSE)6     0.434 0.121  1.558
## sexFemale                                 0.980 0.640  1.500
## I((age - 65)/10)                          1.431 1.208  1.696
## st3III                                    1.514 0.901  2.543
## st3IV                                     3.185 1.988  5.104
```

``` r
news <- data.frame(
  stime = seq(0, 25, length = 301), 
  lex.dur = 1000, 
  sex = "Female",
  age = 65, 
  st3 = "I-II"
)
blhaz <- 
  predict(m2pspli, newdata = news, se.fit = TRUE, type = "link")
blh95 <- cbind(blhaz$fit, blhaz$se.fit) %*% ci.mat()
par(mfrow = c(1, 1))
matplot(news$stime, exp(blh95),
  type = "l", lty = c(1, 1, 1), lwd = c(2, 1, 1),
  col = rep("black", 3), log = "xy", ylim = c(5, 3000)
)
```

```
## Warning in xy.coords(x, y, xlabel, ylabel, log = log, recycle = TRUE): 3 x
## values <= 0 omitted from logarithmic plot
```

```
## Warning in xy.coords(x, y, xlabel, ylabel, log): 1 x value <= 0 omitted from
## logarithmic plot
```

![](oral-s_files/figure-epub3/poissonspline-1.png)<!-- -->
