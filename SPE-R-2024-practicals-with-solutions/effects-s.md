

# Estimation of effects: simple and more complex

This exercise deals with analysis of metric and binary 
response variables. 
We start with simple estimation of effects of a binary, categorical or
a numeric explanatory variable, the explanatory or exposure variable of interest. 
Then evaluation of potential  modification and/or confounding by other variables
is considered by stratification by and adjustment/control for these variables.
For such tasks we utilize functions `lm()` and `glm()`
which can be used for more
general linear and generalized linear models.  Finally, more complex 
spline modelling for the effect of a numeric exposure variable is
illustrated.


## Response and explanatory variables 


Identifying the *response* or *outcome variable* correctly is the key
to analysis. The main types are:

-  Metric or continuous (a measurement with units).
-  Binary ("yes" vs. "no", coded 1/0), or proportion.
-  Failure in person-time, or incidence rate. 

All these response variable are numeric.

Variables on which the response may depend are called *explanatory
variables* or *regressors*. They can be categorical factors or numeric variables.
A further important aspect of explanatory variables is the role they will play in the analysis.


-  Primary role: exposure.
-  Secondary role: confounder and/or effect-measure modifier.



The word **effect** 
is used here as a general term referring to ways of
contrasting or comparing the expected values of the response variable at
different levels of an explanatory 
variable. The main comparative measures or effect measures are:

-  Differences in means for a metric response.
-  Ratios of odds for a binary response.
-  Ratios of rates for a failure or count response.


Other kinds of *contrasts* between exposure groups
include (a) ratios of geometric means for positive-valued  
metric outcomes,
(b) differences and ratios between proportions 
(risk difference and risk ratio), and (c)
differences between incidence or mortality rates.

Note that in spite of using the causally loaded word *effect*,
we treat *outcome regression* modelling
here primarily with descriptive or predictive aims in mind. 
Traditionally, these types of models have also been used
to estimate *causal effects* of exposure variables
from the pertinent regression coefficients. 
More serious causal analysis is introduced in the lecture and practical
on Tuesday morning, and modern approaches 
to estimate causal effects will be  considered
on Thursday afternoon.  

## Data set `births`

We shall use the `births` data to illustrate 
different aspects in estimating effects of various exposures on a metric response variable
`bweight` = birth weight, recorded in grams.
<!-- % To save too much typing these commands are in the -->
<!-- % leaning on the same housekeeping file `births-house.r` as in the tabulation exercise.  -->
<!-- % which can be run with the command `source("./data/births-house.r")` (or from your editor) -->

1. Load the packages needed in this exercise and the data set, and look at its content

```r
library(Epi)
library(mgcv)
data(births)
str(births)
```

```
## 'data.frame':	500 obs. of  8 variables:
##  $ id     : num  1 2 3 4 5 6 7 8 9 10 ...
##  $ bweight: num  2974 3270 2620 3751 3200 ...
##  $ lowbw  : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ gestwks: num  38.5 NA 38.2 39.8 38.9 ...
##  $ preterm: num  0 NA 0 0 0 0 0 0 0 0 ...
##  $ matage : num  34 30 35 31 33 33 29 37 36 39 ...
##  $ hyp    : num  0 0 0 0 1 0 0 0 0 0 ...
##  $ sex    : num  2 1 2 1 1 2 2 1 2 1 ...
```
2. We perform similar housekeeping tasks as in a previous exercise. 
<!-- %% Two of them are directly converted into factors. -->
<!-- %% Categorical versions of two continuous variables are  -->
<!-- %% created by function `cut()`. -->
<!-- %% Also, express birth weights in kilograms -->

```r
births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
births$sex <- factor(births$sex, labels = c("M", "F"))
births$maged <- cut(births$matage, breaks = c(22, 35, 44), right = FALSE)
births$gest4 <- cut(births$gestwks,
  breaks = c(20, 35, 37, 39, 45), right = FALSE)
```
3. Have a look at univariate summaries of the different 
variables in the data; especially
the location and dispersion of the distribution of  `bweight`.

```r
summary(births)
```

```
##        id           bweight         lowbw         gestwks         preterm      
##  Min.   :  1.0   Min.   : 628   Min.   :0.00   Min.   :24.69   Min.   :0.0000  
##  1st Qu.:125.8   1st Qu.:2862   1st Qu.:0.00   1st Qu.:37.94   1st Qu.:0.0000  
##  Median :250.5   Median :3188   Median :0.00   Median :39.12   Median :0.0000  
##  Mean   :250.5   Mean   :3137   Mean   :0.12   Mean   :38.72   Mean   :0.1286  
##  3rd Qu.:375.2   3rd Qu.:3551   3rd Qu.:0.00   3rd Qu.:40.09   3rd Qu.:0.0000  
##  Max.   :500.0   Max.   :4553   Max.   :1.00   Max.   :43.16   Max.   :1.0000  
##                                                NA's   :10      NA's   :10      
##      matage          hyp      sex         maged         gest4    
##  Min.   :23.00   normal:428   M:264   [22,35):270   [20,35): 31  
##  1st Qu.:31.00   hyper : 72   F:236   [35,44):230   [35,37): 32  
##  Median :34.00                                      [37,39):167  
##  Mean   :34.03                                      [39,45):260  
##  3rd Qu.:37.00                                      NA's   : 10  
##  Max.   :43.00                                                   
## 
```

```r
with(births, sd(bweight))
```

```
## [1] 637.4515
```

## Simple estimation with `lm()` and `glm()` 

We are ready to analyze the effect of maternal hypertension `hyp` on `bweight`.
A binary explanatory variable, like `hyp`, leads to an elementary
 two-group comparison of group
means for a metric response. 

1. Comparison of two groups is commonly done by the conventional $t$-test and
the associated confidence interval. 

```r
with(births, t.test(bweight ~ hyp, var.equal = TRUE))
```

```
## 
## 	Two Sample t-test
## 
## data:  bweight by hyp
## t = 5.455, df = 498, p-value = 7.729e-08
## alternative hypothesis: true difference in means between group normal and group hyper is not equal to 0
## 95 percent confidence interval:
##  275.5707 585.8210
## sample estimates:
## mean in group normal  mean in group hyper 
##             3198.904             2768.208
```
The $P$-value refers to the test
of the  null hypothesis that there is no effect of `shyp` on birth weight
 (somewhat implausible null hypothesis in itself!). 
 However, `t.test()` does not provide
the point estimate for the effect of `hyp`; only the test result and a confidence interval. -- The estimated effect of `hyp` on birth weight, 
measured as a difference in means between hypertensive and normotensive
mothers, 
is $3199-2768 = 431$ g.

2. The same task can easily be performed by `lm()` or by `glm()`. 
The main argument in both 
is the *model formula*, the left hand side being the response variable 
and the right hand side
after $\sim$ defines the explanatory variables and their 
joint effects on the response. Here the only
explanatory variable is the binary factor `hyp`. With `glm()` one specifies the
`family`, i.e. the assumed distribution of the response variable. However,
in case you use
`lm()`, this argument is not needed, because `lm()` fits only 
models for metric responses assuming Gaussian distribution.

```r
m1 <- glm(bweight ~ hyp, family = gaussian, data = births)
summary(m1)
```

```
## 
## Call:
## glm(formula = bweight ~ hyp, family = gaussian, data = births)
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  3198.90      29.96 106.768  < 2e-16 ***
## hyphyper     -430.70      78.95  -5.455 7.73e-08 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for gaussian family taken to be 384203.2)
## 
##     Null deviance: 202765853  on 499  degrees of freedom
## Residual deviance: 191333183  on 498  degrees of freedom
## AIC: 7852.4
## 
## Number of Fisher Scoring iterations: 2
```
3. Note the amount of output that `summary()` method produces.
The point estimate plus confidence limits can, though, be concisely obtained by function `ci.lin()` found in `Epi` package.  

```r
round(ci.lin(m1)[, c(1, 5, 6)], 1)
```

```
##             Estimate   2.5%  97.5%
## (Intercept)   3198.9 3140.2 3257.6
## hyphyper      -430.7 -585.4 -275.9
```


## Stratified effects, and interaction or effect-measure modification

We shall now examine whether and to what extent the 
*effect*  of `hyp`  on `bweight`, i.e. the 
 mean difference between hypertensive and normotensive mothers, 
 varies by `sex` without assigning 
 causal interpretation to the estimated contrasts.

1. The following *interaction plot*
shows how the mean `bweight` depends jointly on `hyp` and `gest4`

```r
par(mfrow = c(1, 1))
with(births, interaction.plot(sex, hyp, bweight))
```

At face value it appears that the mean difference in `bweight` between 
hypertensive and normotensive 
mothers is somewhat bigger in boys than in girls.

2. Let us get numerical values for the mean differences
in the two levels of `sex`. 
Stratified estimation of effects can be done by `lm()` as follows:

```r
m3 <- lm(bweight ~ sex / hyp, data = births)
round(ci.lin(m3)[, c(1, 5, 6)], 1)
```

```
##               Estimate   2.5%  97.5%
## (Intercept)     3310.7 3230.1 3391.4
## sexF            -231.2 -347.2 -115.3
## sexM:hyphyper   -496.4 -696.1 -296.6
## sexF:hyphyper   -379.8 -617.4 -142.2
```
The estimated effects of `hyp` in the two strata defined by `sex` thus
are $-496$ g in boys and $-380$ g among girls.
 The error margins of the two estimates are quite wide, though.

3. An equivalent model with an explicit *product term* or
*interaction term* between `sex` and `hyp` is
fitted as follows:

```r
m3I <- lm(bweight ~ sex + hyp + sex:hyp, data = births)
round(ci.lin(m3I)[, c(1, 4, 5, 6)], 2)
```

```
##               Estimate    P    2.5%   97.5%
## (Intercept)    3310.75 0.00 3230.14 3391.35
## sexF           -231.25 0.00 -347.15 -115.35
## hyphyper       -496.35 0.00 -696.07 -296.63
## sexF:hyphyper   116.58 0.46 -193.80  426.96
```
From this  output you would find a familiar estimate $-231$ g for girls
vs. boys among normotensive mothers and the estimate $-496$ g 
contrasting hypertensive and normotensive mothers in the
reference class of `sex`, i.e. among boys.
The remaining coefficient is the estimate of the interaction 
effect such that $116.6 = -379.8 -(-496.4)$ g 
describes the contrast in the effect of `hyp` on `bweight`
 between girls and boys. 
 
 The $P$-value $0.46$ as well 
 as the wide confidence interval about zero of this interaction
 parameter suggest good compatibility of the data with
 the null hypothesis of 
  no interaction between `hyp` and `sex`. Thus, 
  there is insufficient evidence against
  the possibility of *effect(-measure) modification* by
  `sex` on the effect of `hyp`.
On the other hand, this test is not very sensitive given
the small sample size. Thus, in spite of obtaining a "non-significant"
result, the possibility of a real effect-measure modification
cannot be ignored based on these data only.


## Estimating the effect of `hyp` adjusted for `sex`

The estimated effects of `hyp`: 
$-496$ in boys and $-380$ in girls, look quite
similar (and the $P$-value against no interaction was quite large, too).
Therefore, we may now proceed to estimate the overall effect of `hyp` 
 *controlling for* -- or *adjusting for* -- `sex`. 

1. Adjustment is done by adding `sex` to the model formula:

```r
m4 <- lm(bweight ~ sex + hyp, data = births)
ci.lin(m4)[, c(1, 5, 6)]
```

```
##              Estimate      2.5%     97.5%
## (Intercept) 3302.8845 3225.0823 3380.6867
## sexF        -214.9931 -322.4614 -107.5249
## hyphyper    -448.0817 -600.8911 -295.2723
```
The estimated effect of `hyp` on `bweight` 
adjusted for `sex` is thus $-448$ g, 
which is a weighted average of the sex-specific estimates. 
It is slightly different from the unadjusted estimate $-431$ g, indicating
that there was no essential confounding by `sex` in the
simple comparison of means.
Note also, that the model being fitted makes the assumption that
the estimated effect is the same for boys and girls.

Many people go straight ahead and control for variables which are likely to
confound the effect of exposure without bothering to stratify first, 
but often it is useful to examine the possibility of effect-measure 
modification before that.


## Numeric exposure, simple linear regression and checking assumptions  

If we wished to study the effect of gestation time on the baby's birth 
weight then  `gestwks` is a numeric exposure variable.  

1. Assuming that the relationship 
of the response with `gestwks` is roughly linear 
(for a continuous response), 
% or log-linear (for a binary or failure rate response) 
we can estimate the linear effect of `gestwks` with `lm()` as follows:

```r
m5 <- lm(bweight ~ gestwks, data = births)
ci.lin(m5)[, c(1, 5, 6)]
```

```
##               Estimate       2.5%      97.5%
## (Intercept) -4489.1398 -5157.2891 -3820.9905
## gestwks       196.9726   179.7482   214.1971
```
We have fitted a simple linear regression model and 
obtained estimates of the
two regression coefficient: `intercept` and `slope`.
The linear effect of `gestwks` is thus estimated by the
slope coefficient, which is $197$ g per each additional week of gestation.

At this stage it will be best to make some visual check concerning
our model assumptions using `plot()`. In particular, when the main argument
for the *generic function* `plot()` is a fitted `lm` object,
it will provide you some common diagnostic graphs.

2. To check whether `bweight` goes up linearly with `gestwks` try

```r
with(births, plot(gestwks, bweight))
abline(m5)
```

3. Moreover, take a look at the basic diagnostic plots for the fitted model.

```r
par(mfrow = c(2, 2))
plot(m5)
```
What can you say about the agreement with data of the assumptions of the 
simple linear regression model, 
like linearity of the systematic dependence, 
homoskedasticity and normality of the error terms? 



## Penalized spline model

We shall now continue the analysis such that the apparently curved effect
of `gestwks` is modelled by a *penalized spline*,
based on the recommendations of Martyn in his lecture today. 

You cannot fit a penalized spline model with `lm()` or
`glm()`. Instead, function `gam()` in package
`mgcv` can be used for this purpose. Make sure that you have loaded
this package.

1.  When calling `gam()`, the model formula contains
  expression '`s(X)`' for any explanatory variable `X`,
  for which you wish to fit a smooth function

```r
mPs <- mgcv::gam(bweight ~ s(gestwks), data = births)
summary(mPs)
```

```
## 
## Family: gaussian 
## Link function: identity 
## 
## Formula:
## bweight ~ s(gestwks)
## 
## Parametric coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  3138.01      20.11     156   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##              edf Ref.df     F p-value    
## s(gestwks) 3.321  4.189 124.7  <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.516   Deviance explained = 51.9%
## GCV = 1.9995e+05  Scale est. = 1.9819e+05  n = 490
```
From the output given by `summary()` you find that the
estimated intercept is equal to the overall mean birth
weight in the data.  The estimated residual variance is given by
`Scale est.`  or from subobject `sig2` of the fitted
`gam` object.  Taking square root you will obtain the estimated
residual standard deviation: $445.2$ g.

```r
mPs$sig2
```

```
## [1] 198186
```

```r
sqrt(mPs$sig2)
```

```
## [1] 445.1808
```
The degrees of freedom in this model are not computed as simply as in previous
models, and they typically are not integer-valued. However,
the fitted spline seems to consume only a little more degrees of freedom
as an 3rd degree polynomial model would take.

2.  A graphical presentation of the fitted curve together with the
  confidence and prediction intervals is more informative. 
 Let us first write a
  short function script to facilitate the task. We utilize function `matshade()` in `Epi`, which creates shaded areas, and function `matlines()` which draws 
  lines joining the pertinent end points over the $x$-values for which the
  predictions are computed.

```r
plotFitPredInt <- function(xval, fit, pred, ...) {
  matshade(xval, fit, lwd = 2, alpha = 0.2)
  matshade(xval, pred, lwd = 2, alpha = 0.2)
  matlines(xval, fit, lty = 1, lwd = c(3, 2, 2), col = c("black", "blue", "blue"))
  matlines(xval, pred, lty = 1, lwd = c(3, 2, 2), col = c("black", "brown", "brown"))
}
```

3.  Finally, create a vector of $x$-values and compute 
the fitted/predicted values as well
as the interval limits at these points from the fitted
model object utilizing
function `predict()`. 
This function creates a matrix of three columns: (1) fitted/predicted
values, (2) lower limits, (3) upper limits and 
make the graph:

```r
nd <- data.frame(gestwks = seq(24, 45, by = 0.25))
pr.Ps <- predict(mPs, newdata = nd, se.fit = TRUE)
str(pr.Ps) # with se.fit=TRUE, only two columns: fitted value and its SE
```

```
## List of 2
##  $ fit   : num [1:85(1d)] 350 385 421 456 491 ...
##   ..- attr(*, "dimnames")=List of 1
##   .. ..$ : chr [1:85] "1" "2" "3" "4" ...
##  $ se.fit: num [1:85(1d)] 324 309 293 278 264 ...
##   ..- attr(*, "dimnames")=List of 1
##   .. ..$ : chr [1:85] "1" "2" "3" "4" ...
```

```r
fit.Ps <- cbind(
  pr.Ps$fit,
  pr.Ps$fit - 2 * pr.Ps$se.fit,
  pr.Ps$fit + 2 * pr.Ps$se.fit
)
pred.Ps <- cbind(
  pr.Ps$fit, # must add residual variance to se.fit^2
  pr.Ps$fit - 2 * sqrt(pr.Ps$se.fit^2 + mPs$sig2),
  pr.Ps$fit + 2 * sqrt(pr.Ps$se.fit^2 + mPs$sig2)
)
par(mfrow = c(1, 1))
with(births, plot(bweight ~ gestwks,
  xlim = c(24, 45),
  cex.axis = 1.5, cex.lab = 1.5
))
plotFitPredInt(nd$gestwks, fit.Ps, pred.Ps)
```
Compare this with the graph on slide 20 of the lecture we had. 
Are you happy with the end result?


## Analysis of binary outcomes

Instead of investigating the distribution and determinants
of birth weight as such, it is common in perinatal 
epidemiology to consider
occurrence of low birth weight; whether birth weight is 
$< 2.5$ kg or not. Variable `lowbw` with values 1 and 0
in the `births` data represents that dichotomy.
Some analyses on `lowbw` were already conducted 
in a previous practical. Here we illustrate further
aspects of effect estimation
and modelling binary outcome.

1. We start with simple tabulation 
of the prevalence of `lowbw` by maternal hypertension

```r
stat.table(
  index = list(hyp, lowbw),
  contents = list(count(), percent(lowbw)),
  margins = TRUE, data = births
)
```

```
##  --------------------------------- 
##          ----------lowbw---------- 
##  hyp            0       1   Total  
##  --------------------------------- 
##  normal       388      40     428  
##              90.7     9.3   100.0  
##                                    
##  hyper         52      20      72  
##              72.2    27.8   100.0  
##                                    
##                                    
##  Total        440      60     500  
##              88.0    12.0   100.0  
##  ---------------------------------
```
It seems that the prevalence for hypertensive mothers
is about 18 percent points higher,
or about three times as high as that for normotensive mothers

2. The three comparative measures of prevalences can be 
estimated by `glm()` with different link functions:

```r
binRD <- glm(lowbw ~ hyp, family = binomial(link = "identity"), data = births)
round(ci.lin(binRD)[, c(1, 2, 5:6)], 3)
```

```
##             Estimate StdErr  2.5% 97.5%
## (Intercept)    0.093  0.014 0.066 0.121
## hyphyper       0.184  0.055 0.077 0.291
```

```r
binRR <- glm(lowbw ~ hyp, family = binomial(link = "log"), data = births)
round(ci.lin(binRR, Exp = TRUE)[, c(1, 2, 5:7)], 3)
```

```
##             Estimate StdErr exp(Est.)  2.5% 97.5%
## (Intercept)   -2.370  0.151     0.093 0.070 0.126
## hyphyper       1.089  0.242     2.972 1.848 4.780
```

```r
binOR <- glm(lowbw ~ hyp, family = binomial(link = "logit"), data = births)
round(ci.lin(binOR, Exp = TRUE)[, c(1, 2, 5:7)], 3)
```

```
##             Estimate StdErr exp(Est.)  2.5% 97.5%
## (Intercept)   -2.272  0.166     0.103 0.074 0.143
## hyphyper       1.317  0.311     3.731 2.027 6.865
```
Check that these results were quite compatible with the
"about" estimates given in the previous item.
How well is the odds ratio approximating the risk ratio here?

3. The prevalence of low birth weight is expected to be inversely related
to gestational age (weeks), as is evident from simple tabulation

```r
stat.table(
  index = list(gest4, lowbw),
  contents = list(count(), percent(lowbw)),
  margins = TRUE, data = births
)
```

```
##  ---------------------------------- 
##           ----------lowbw---------- 
##  gest4           0       1   Total  
##  ---------------------------------- 
##  [20,35)         6      25      31  
##               19.4    80.6   100.0  
##                                     
##  [35,37)        19      13      32  
##               59.4    40.6   100.0  
##                                     
##  [37,39)       149      18     167  
##               89.2    10.8   100.0  
##                                     
##  [39,45)       257       3     260  
##               98.8     1.2   100.0  
##                                     
##                                     
##  Total         440      60     500  
##               88.0    12.0   100.0  
##  ----------------------------------
```

4. Let's jump right away to spline modelling of this relationship

```r
binm1 <- mgcv::gam(lowbw ~ s(gestwks), family = binomial(link = "logit"), data = births)
summary(binm1)
```

```
## 
## Family: binomial 
## Link function: logit 
## 
## Formula:
## lowbw ~ s(gestwks)
## 
## Parametric coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -2.8665     0.2364  -12.12   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Approximate significance of smooth terms:
##             edf Ref.df Chi.sq p-value    
## s(gestwks) 1.01  1.021  68.86  <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## R-sq.(adj) =  0.425   Deviance explained = 42.9%
## UBRE = -0.57194  Scale est. = 1         n = 490
```

```r
plot(binm1)
```

Inspect the figure. Would you agree, that the logit of the prevalence
of outcome is almost linearly dependent on `gestwks`?

5. Encouraged by the result of the previous item, we continue the analysis
with `glm()` and assuming logit-linearity

```r
binm2 <- glm(lowbw ~ I(gestwks - 40), family = binomial(link = "logit"), data = births)
round(ci.lin(binm2, Exp = TRUE)[, c(1, 2, 5:7)], 3)
```

```
##                 Estimate StdErr exp(Est.)  2.5% 97.5%
## (Intercept)       -4.011  0.338     0.018 0.009 0.035
## I(gestwks - 40)   -0.896  0.108     0.408 0.330 0.505
```

Inspect the results. How do you interpret the estimated coefficients
and their exponentiated values?

6.  Instead of fitted logits, it can be more informative
to plot the fitted prevalences against `gestwks`,
in which we utilize the previously created data frame `nd`

```r
predm2 <- predict(binm2, newdata = nd, type = "response")
plot(nd$gestwks, predm2, type = "l")
```

 The curve seems to cover practically the whole range of
the outcome probability scale with a relatively 
steep slope between 33 to 37 weeks. 


