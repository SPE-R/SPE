---
output:
  pdf_document: default
  html_document: default
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
str(orca)
summary(orca)
```


## Total mortality: Kaplan--Meier analyses


-  We start our analysis of total mortality pooling the two causes of death into
a single outcome.
First, construct a *survival object* `suob` from
the event variable and the follow-up time using function `Surv()`.
Look at the structure and summary of `suob` .

``` r
suob <- Surv(orca$time, 1 * (orca$event > 0))
str(suob)
summary(suob)
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
str(s.all)
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
plot(s.all)
lines(s.all, fun = "event", mark.time = F, conf.int = FALSE)
```

The effect of option `mark.time=F` is to omit
marking the times when censorings occurred.


## Total mortality by stage

Tumour stage is an important prognostic factor in cancer survival studies.

-  Plot separate cumulative mortality curves for the different stage groups
marking them with different colours, the order which you may define yourself.
Also find the median survival time for each stage.

``` r
s.stg <- survfit(suob ~ stage, data = orca)
col5 <- cB8[1:5]
plot(s.stg, col = col5, fun = "event", mark.time = FALSE)
legend(15, 0.5, legend=levels(factor(orca$stage)),
       col=col5, lty=1, cex=0.8,
       title="Stage", text.font=4, bg='white')
s.stg
```

- Create now two parallel plots of which the first one describes the
cumulative hazards
and the second one graphs the log-cumulative hazards against log-time
for the different stages. Compare the two presentations
with each other and with the one in the previous item.

``` r
par(mfrow = c(1, 2))
plot(s.stg, col = col5, fun = "cumhaz", main = "cum. hazards")
plot(
  s.stg, 
  col = col5, 
  fun = "cloglog", 
  main = "cloglog: log cum.haz"
)
legend(2, -2, legend=levels(factor(orca$stage)),
       col=col5, lty=1, cex=0.8,
       title="Stage", text.font=4, bg='white')
```

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
Male patients are clearly younger than females in these data.

Now, plot Kaplan--Meier curves jointly classified by sex and age.

``` r
s.agrx <- survfit(suob ~ agegr + sex, data = orca)
par(mfrow = c(1, 1))
plot(s.agrx,
  fun = "event", mark.time = FALSE, xlim = c(0, 15),
  col = rep(c(cB8[8], cB8[6]), 3), lty = c(2, 2, 1, 1, 5, 5),lwd=2
)
```

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
plotCIF(cif1, 1, main = "Cancer death")
plotCIF(cif1, 2, main = "Other deaths")
```

- Compute the estimated
cumulative incidences by stage for both causes of death.
Now you have to add variable `stage` to survfit-function. 

See the structure of the resulting object, in which you should
observe strata variable containing the stage grouping variable. Plot the pertinent curves in two parallel graphs.
Cut the $y$-axis for a more efficient graphical presentation


``` r
cif2 <- survfit(Surv(time, event, type = "mstate") ~ stage,
  data = orca
)
str(cif2)

par(mfrow = c(1, 2))
plotCIF(cif2, 1,
  main = "Cancer death by stage",
  col = cB8[1:5], ylim = c(0, 0.7)
)

plotCIF(cif2, 2,
  main = "Other deaths by stage",
  col = cB8[1:5], ylim = c(0, 0.7)
)

legend(0, 0.6, legend=levels(factor(orca$stage)), col=col5, lty=1, cex=0.5,
       title="Stage", text.font=4, bg='white')
```

Compare the two plots. What would you conclude about the
effect of stage on the two causes of death?

-  Using another function `stackedCIF()` in `Epi` you can 
put the two cumulative incidence curves in one graph but stacked upon one another such that
the lower curve is for the cancer deaths and the upper curve is for total mortality,
and the vertical difference between the two curves describes the
cumulative mortality from other causes. You can also add some colours for the different zones: 

``` r
par(mfrow = c(1, 1))
stackedCIF(cif1, colour = c("gray70", "gray85"))
```

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
m1 <- coxph(Surv(time, 1 * (event > 0)) ~ sex + I((age - 65) / 10) + stage, data = orca)
summary(m1)
round(ci.exp(m1), 3)
```

Look at the results. What are the main findings?


-  Check whether the data are sufficiently consistent with the
assumption of proportional hazards with respect to each of
the variables separately
as well as globally, using the `cox.zph()` function.

``` r
cox.zph(m1)
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
m2 <- update(m1, . ~ . - stage + st3, data = orca2)
round(ci.exp(m2), 3)
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
col3 <- cB8[1:3]
par(mfrow = c(1, 2))
plot(
  survfit(
    m2, newdata = subset(newd, sex == "Male" & age == 40)
  ),
  col = col3, fun = "event", mark.time = FALSE, 
  main="Cum. mortality by sex and stage \n age 40", ylim=c(0,1)
)
lines(
  survfit(
    m2, newdata = subset(newd, sex == "Female" & age == 40)
  ),
  col = col3, fun = "event", lty = 2, mark.time = FALSE
)
plot(
  survfit(
    m2, newdata = subset(newd, sex == "Male" & age == 80)),
  ylim = c(0, 1), col = col3, fun = "event", mark.time = FALSE,
  main="Cum. mortality by sex and stage \n age 80")
lines(
  survfit(
    m2, newdata = subset(newd, sex == "Female" & age == 80)
  ),
  col = col3, fun = "event", lty = 2, mark.time = FALSE
)

legend(10, 0.4, legend=levels(interaction(levels(factor(newd$st3)),
                                          levels(factor(newd$sex)))),       col=col3, lty=c(2,2,2,1,1,1), cex=0.5,
       title="Stage and sex", text.font=4, bg='white')
```



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
cox.zph(m2haz1)
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
cox.zph(m2haz2)
```

<!-- % -  -->
<!-- % Finally, fit the Fine--Gray model for the hazard of the subdistribution -->
<!-- % for cancer deaths with the same covariates as above. For this you have to -->
<!-- % first load package `cmprsk`, containing the necessary function -->
<!-- % `crr()`, and attach the data frame. -->
<!-- % ```{r fg1, echo=TRUE,eval=FALSE} -->
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
<!-- % ```{r fg2, echo=TRUE,eval=FALSE} -->
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
summary(orca.lex)
```

-  Draw a box diagram of the two-state set-up of competing transitions. Run first th e following command line

``` r
boxes(orca.lex,boxpos=T)
```
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
orca2.lex$st3 <- Relevel(orca2$stage, list(1:2, 3, 4:5))
levels(orca2.lex$st3) <- c("I-II", "III", "IV")
```
 Then, the break points of time axis are taken from
 the sorted event times, and the `lexis` object is
 split by those breakpoints. The `timeband` factor
 is defined according to the splitted survival times
 stored in variable `stime`.


``` r
cuts <- sort(orca2$time[orca2$event == 1])
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
orca2.spl[1:20, ]
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
We shall display the estimation results graphically
 for the baseline hazard (per 1000 person-years)
 and numerically for the rate ratios associated with the covariates.
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
par(mfrow = c(1, 1))
plot(tbmid, 1000 * exp(coef(m2pois1)[1:(ntb - 1)]),
  ylim = c(5, 3000), log = "xy", type = "l"
)
```

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
