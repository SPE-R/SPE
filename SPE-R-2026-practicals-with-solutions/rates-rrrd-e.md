




# Analysis of hazard rates, their ratios and differences and binary regression

This exercise is *very* prescriptive, so you should make an
effort to really understand everything you type into R. Consult the
relevant slides of the lecture on *Poisson and Binary regression ...*

## Hand calculations for a single rate

Let $\lambda$ be the true **hazard rate** or theoretical incidence rate of a given outcome event.
Its estimator is the empirical **incidence rate**
$\widehat\lambda = D/Y$ = no. cases/person-years.  Recall that the
standard error of the empirical rate is
SE$(\widehat\lambda) = \widehat\lambda/\sqrt{D}$.

The simplest approximate 95% confidence interval (CI) for $\lambda$
is given by
$$ \widehat\lambda \pm 1.96 \times SE(\widehat\lambda) $$



-  Suppose $15$ outcome events are observed during $5532$ person-years in a given study cohort. 
  Let's  use R as a simple desk calculator to estimate the underlying hazard rate $\lambda$ (in 1000
  person-years; therefore 5.532) and to get the first version of an approximate confidence
  interval:

``` r
library(Epi)
options(digits = 4) #  to cut down decimal points in the output
```

``` r
D <- 15
Y <- 5.532 # thousands of years!
rate <- D / Y
SE.rate <- rate / sqrt(D)
c(rate, SE.rate, rate + c(-1.96, 1.96) * SE.rate)
```

```
## [1] 2.7115 0.7001 1.3393 4.0837
```



## Poisson model for a single rate with logarithmic link

You are able to estimate the hazard rate $\lambda$ and compute its CI with a **Poisson regression model**, as described in the relevant slides in the lecture handout. 

Poisson regression is a **generalized linear model** in which the **family**, *i.e.* the distribution of the response variable, is assumed to be the Poisson distribution. The most commonly applied **link function**
in Poisson regression is the natural logarithm; log for short. 


- 
A family object `poisreg`, a modified version of the original `poisson` family object, is available
in package `Epi`. When using this, the response is defined as a *matrix* of two columns: numbers
of cases $D$ and person-years $Y$, these being combined into a matrix by `cbind(D,Y)`. No specification
of `offset` is needed.

``` r
mreg <- glm(cbind(D, Y) ~ 1, family = poisreg(link = log))
ci.exp(mreg)
```

```
##             exp(Est.)  2.5% 97.5%
## (Intercept)     2.711 1.635 4.498
```
-  If you want confidence interval for log rate

``` r
mreg <- glm(cbind(D, Y) ~ 1, family = poisreg(link = log))
ci.lin(mreg)[, c(1, 5, 6)]
```

```
## Estimate     2.5%    97.5% 
##   0.9975   0.4914   1.5036
```

In this course we endorse the use of family `poisreg` because of its advantages in more general settings.


## Poisson model for a single rate with identity link

The approach leaning on having the number of cases $D$ as the response and log$(Y)$ as an offset,
is limited only to models with log link. A major  advantage of the `poisreg` family is that it allows
a straighforward use of the *identity* link, too. With this link the response variable is the same, but
the parameters to be directly estimated are now the rates itself and their differences, not the log-rates
and their differences as with the log link.
	

-  Fit a Poisson model with identity link to our simple data, and 
use `ci.lin()` to produce the estimate and the
  confidence interval for the hazard rate from this model:

``` r
mid <- glm(cbind(D, Y) ~ 1, family = poisreg(link = "identity"))
ci.lin(mid)
```

```
##             Estimate StdErr     z         P  2.5% 97.5%
## (Intercept)    2.711 0.7001 3.873 0.0001075 1.339 4.084
```

``` r
ci.lin(mid)[, c(1, 5, 6)]
```

```
## Estimate     2.5%    97.5% 
##    2.711    1.339    4.084
```
How is the coefficient of this model interpreted?
Verify that you actually get the same rate estimate and CI as in section 1.6.1, item 1.


## Poisson model assuming the same rate for several periods

Now, suppose the events and person years are collected over  three distinct periods.


-  Read in the data and compute period-specific rates

``` r
Dx <- c(3, 7, 5)
Yx <- c(1.412, 2.783, 1.337)
Px <- 1:3
rates <- Dx / Yx
rates
```

```
## [1] 2.125 2.515 3.740
```
-  Using these data, 
fit the same model with log link as in section 1.6.2, assuming a common single hazard $\lambda$ 
  for the separate periods. Compare the result from the previous ones

``` r
m3 <- glm(cbind(Dx, Yx) ~ 1, family = poisreg(link = log))
ci.exp(m3)
```

```
##             exp(Est.)  2.5% 97.5%
## (Intercept)     2.711 1.635 4.498
```

-  Now test whether the rates are the same in the three periods:
  Try to fit a model with the period as a factor in the model:

``` r
mp <- glm(cbind(Dx, Yx) ~ factor(Px), family = poisreg(link = log))
ci.exp(mp)
```

```
##             exp(Est.)   2.5% 97.5%
## (Intercept)     2.125 0.6852 6.588
## factor(Px)2     1.184 0.3061 4.578
## factor(Px)3     1.760 0.4207 7.365
```
Compare the goodness-of-fit of the two models using `anova()` with the argument
`test="Chisq"`:

``` r
anova(m3, mp, test = "Chisq")
```

```
## Analysis of Deviance Table
## 
## Model 1: cbind(Dx, Yx) ~ 1
## Model 2: cbind(Dx, Yx) ~ factor(Px)
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
## 1         2        0.7                     
## 2         0        0.0  2      0.7      0.7
```
Compare the test statistic to the deviance of the model `mp`.
-- What is the deviance indicating?


## Analysis of rate ratio

We now switch to comparison of two rates $\lambda_1$ and $\lambda_0$, i.e.
the hazard in an exposed group vs. that in an unexposed one.

Consider first estimation of the **hazard ratio** or the underlying *true* rate ratio
$\rho = \lambda_1/\lambda_0$ between the groups.  Suppose we have
pertinent empirical data (cases and person-times) from both groups,
$(D_1,Y_1)$ and $(D_0,Y_0)$. The point estimate of $\rho$ is the
empirical **incidence rate ratio**
\[
\widehat{\rho} = RR = \frac{\widehat\lambda_1}{\widehat\lambda_0} = \frac{D_1/Y_1}{D_0/Y_0}
\]	


<!-- 
The variance of $\log(\RR)$, that is, the difference
of the log of the empirical rates,
$\log(\widehat\lambda_1) - \log(\widehat\lambda_0)$, is commonly estimated as
\begin{eqnarray*}
   {\mbox{var}}(\log(\RR)) 
    & = & {\mbox{var}}\{ \log( \widehat\lambda_1/\widehat\lambda_0 ) \} 
     =  \mbox{var}\{ \log( \widehat\lambda_1 ) \} + \mbox{var}\{ \log( \widehat \lambda_0 ) \} \\
    & = & 1/D_1 + 1/D_0
\end{eqnarray*}
Based on a similar argument as before, an approximate 95\CI for the
true rate ratio $\lambda_1/\lambda_0$ is then: 
\[
  \RR \td \exp\left(1.96\sqrt{\frac{1}{D_1}+
                              \frac{1}{D_0}}\,\right)
\]
 -->

Suppose you have $15$ events during $5532$ person-years in an
unexposed group and $28$ events during $4783$ person-years in an
exposed group:

-  Calculate the incidence rates in the two groups, their ratio, and the  CI of the true hazard ratio $\rho$ by direct application of the above formulae:

``` r
D0 <- 15
D1 <- 28
Y0 <- 5.532
Y1 <- 4.783
```

-  Now achieve this using a Poisson model. For that we first combine
the group-specific numbers into pertinent vectors and specify a factor to represent the contrast between the exposed and the unexposed group

``` r
D <- c(D0, D1)
Y <- c(Y0, Y1)
expos <- 0:1
mm <- glm(cbind(D, Y) ~ factor(expos), family = poisreg(link = log))
```
What do the parameters mean in this model?

-  You can extract the estimation results for exponentiated parameters in two ways, as before:

``` r
ci.exp(mm)
```

```
##                exp(Est.)  2.5% 97.5%
## (Intercept)        2.711 1.635 4.498
## factor(expos)1     2.159 1.153 4.042
```

``` r
ci.lin(mm, Exp = TRUE)[, 5:7]
```

```
##                exp(Est.)  2.5% 97.5%
## (Intercept)        2.711 1.635 4.498
## factor(expos)1     2.159 1.153 4.042
```


## Analysis of rate difference

For the **hazard difference** $\delta = \lambda_1 - \lambda_0$,
the  natural estimator is the **incidence rate difference**
$$ \widehat\delta = \widehat\lambda_1  - \widehat\lambda_0 = D_1/Y_1 - D_0/Y_0 = \mbox{RD} . $$ 
Its variance is just the sum of the variances of the two rates 
<!-- (since the latter are  based on independent samples): -->
$$ var(RD) = var(\widehat\lambda_1 ) + var( \widehat\lambda_0 ) =  D_1/Y_1^2 + D_0/Y_0^2 $$

-  Use this formula to compute the point estimate of the rate difference $\lambda$ and a 95\%   confidence interval for it:

``` r
R0 <- D0 / Y0
R1 <- D1 / Y1
RD <- diff(D / Y)
SED <- sqrt(sum(D / Y^2))
c(R1, R0, RD, SED, RD + c(-1, 1) * 1.96 * SED)
```

```
## [1] 5.8541 2.7115 3.1426 1.3092 0.5765 5.7087
```
-  Verify that this is the confidence interval you get when you fit
  an additive model (obtained by identity link) with exposure as a factor:

``` r
ma <- glm(cbind(D, Y) ~ factor(expos),
  family = poisreg(link = identity)
)
ci.lin(ma)[, c(1, 5, 6)]
```

```
##                Estimate   2.5% 97.5%
## (Intercept)       2.711 1.3393 4.084
## factor(expos)1    3.143 0.5765 5.709
```



## Binary regression

Explore the factors associated with risk of low birth weight 
in 500 singleton births in a London Hospital. Indicator (lowbw) for birth weight less than 2500 g. Data available from the Epi package. Factors of interest are
maternal hypertension (hyp), mother's age at birth over 35 years and sex of the baby.

Load the `Epi` package and the data set and look at its content

``` r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

``` r
library(Epi)
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

-  Because all variables are numeric we need first to do a little housekeeping. 
Two of them are directly converted into factors,
and categorical versions are created of two continuous variables by function `cut()`.
<!-- Also, express birth weights in kilograms -->

``` r
births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
births$sex <- factor(births$sex, labels = c("M", "F"))
births$gest4 <- cut(births$gestwks,
  breaks = c(20, 35, 37, 39, 45), right = FALSE
)
births$maged <- ifelse(births$matage < 35, 0, 1)
```


-  Cross tabulate (dplyr) counts of children by hypertension and low birth weight. 
calculate (mutate) proportions of low birth weigth children by hypertension.

``` r
births %>%
  count(hyp, lowbw) %>%
  group_by(hyp) %>% # now required with changes to dplyr::count()
  mutate(prop = prop.table(n))
```

```
## # A tibble: 4 × 4
## # Groups:   hyp [2]
##   hyp    lowbw     n   prop
##   <fct>  <dbl> <int>  <dbl>
## 1 normal     0   388 0.907 
## 2 normal     1    40 0.0935
## 3 hyper      0    52 0.722 
## 4 hyper      1    20 0.278
```


-  Estimate relative risk of low birth weight for mothers with hypertension compared to those without using binary regression.

``` r
m <- glm(lowbw ~ hyp, family = binomial(link = log), data = births)
ci.exp(m)
```

```
##             exp(Est.)    2.5%  97.5%
## (Intercept)   0.09346 0.06958 0.1255
## hyphyper      2.97222 1.84808 4.7802
```


-  Adjust relative risk of low birth and hypertension with the sex of children

``` r
m <- glm(lowbw ~ sex + hyp, family = binomial(link = log), data = births)
ci.exp(m)
```

```
##             exp(Est.)    2.5%  97.5%
## (Intercept)    0.0781 0.05242 0.1164
## sexF           1.4113 0.88609 2.2480
## hyphyper       3.0148 1.87400 4.8500
```



-  Adjust relative risk of low birth and hypertension with the sex of children and mother beeing over 35 years.

``` r
m <- glm(lowbw ~ maged + sex + hyp, family = binomial(link = log), data = births)
ci.exp(m)
```

```
##             exp(Est.)   2.5%  97.5%
## (Intercept)   0.07134 0.0443 0.1149
## maged         1.18711 0.7452 1.8912
## sexF          1.42652 0.8947 2.2744
## hyphyper      3.06590 1.8992 4.9493
```


## Optional/Homework: Hand calculations and calculations using matrix tools

> NB. This subsection requires some familiarity with matrix algebra. Do this only after you have done the other exercises of this session.

First some basic hand calculations.

-  Suppose $15$ outcome events are observed during $5532$ person-years in a given study cohort. 
  Let's  use R as a simple desk calculator to estimate the underlying hazard rate $\lambda$ (in 1000
  person-years; therefore 5.532) and to get the first version of an approximate confidence
  interval:

``` r
library(Epi)
options(digits = 4) #  to cut down decimal points in the output
```


``` r
D <- 15
Y <- 5.532 # thousands of years!
rate <- D / Y
SE.rate <- rate / sqrt(D)
c(rate, SE.rate, rate + c(-1.96, 1.96) * SE.rate)
```

```
## [1] 2.7115 0.7001 1.3393 4.0837
```

-  Compute now the approximate confidence interval using the method
based on log-transformation and compare the result with that in the previous item.

``` r
SE.logr <- 1 / sqrt(D)
EF <- exp(1.96 * SE.logr)
c(log(rate), SE.logr)
```

```
## [1] 0.9975 0.2582
```

``` r
c(rate, EF, rate / EF, rate * EF)
```

```
## [1] 2.711 1.659 1.635 4.498
```


-  Calculate the incidence rates in the two groups, their ratio, and the  
CI of the true hazard ratio $\rho$ by direct application of the above formulae:

``` r
D0 <- 15
D1 <- 28
Y0 <- 5.532
Y1 <- 4.783
R1 <- D1 / Y1
R0 <- D0 / Y0
RR <- R1 / R0
SE.lrr <- sqrt(1 / D0 + 1 / D1)
EF <- exp(1.96 * SE.lrr)
c(R1, R0, RR, RR / EF, RR * EF)
```

```
## [1] 5.854 2.711 2.159 1.153 4.042
```


-  Explore the function `ci.mat()`, which lets you use
  matrix multiplication (operator `'%*%'`
  in R) to produce a confidence interval from an estimate and its
  standard error (or CIs from whole columns of estimates and SEs):

``` r
ci.mat
```

```
## function (alpha = 0.05, df = Inf) 
## {
##     ciM <- rbind(c(1, 1, 1), qt(1 - alpha/2, df) * c(0, -1, 1))
##     colnames(ciM) <- c("Estimate", paste(formatC(100 * alpha/2, 
##         format = "f", digits = 1), "%", sep = ""), paste(formatC(100 * 
##         (1 - alpha/2), format = "f", digits = 1), "%", sep = ""))
##     ciM
## }
## <bytecode: 0x55722c36daf0>
## <environment: namespace:Epi>
```

``` r
ci.mat()
```

```
##      Estimate  2.5% 97.5%
## [1,]        1  1.00  1.00
## [2,]        0 -1.96  1.96
```
As you see, this function returns a $2\times 3$ matrix (2 rows, 3 columns) containing familiar numbers.

-  When you combine the single rate and its standard error into 
a row vector of length 2, i.e. a $1\times 2$ matrix, and multiply this 
by the $2\times 3$ matrix above, the computation returns 
a $1\times 3$ matrix containing the point estimate and the
confidence limit.

Apply this method to the single rate calculations in 1.6.1, first creating the $1 \times 2$ matrix and then performing the matrix multiplication.

``` r
rateandSE <- c(rate, SE.rate)
rateandSE
```

```
## [1] 2.7115 0.7001
```

``` r
rateandSE %*% ci.mat()
```

```
##      Estimate  2.5% 97.5%
## [1,]    2.711 1.339 4.084
```
-  When the confidence interval is based on the log-rate and its
  standard error, the result is obtained by appropriate application of
  the exp-function on the pertinent matrix product

``` r
lograndSE <- c(log(rate), SE.logr)
lograndSE
```

```
## [1] 0.9975 0.2582
```

``` r
exp(lograndSE %*% ci.mat())
```

```
##      Estimate  2.5% 97.5%
## [1,]    2.711 1.635 4.498
```
-  For computing the rate ratio and its CI as in 1.6.5, matrix
  multiplication with `ci.mat()` should give the same result as
  there:

``` r
exp(c(log(RR), SE.lrr) %*% ci.mat())
```

```
##      Estimate  2.5% 97.5%
## [1,]    2.159 1.153 4.042
```
-  The main argument in function `ci.mat()` is `alpha`,
  which sets the confidence level: $1 - \alpha$. The default value is
  `alpha = 0.05`, corresponding to the level $1 - 0.05$ = 95%. 
  If you wish to get the confidence interval for the rate ratio at
  the 90% level (= $1-0.1$), for instance, you may proceed as
  follows:

``` r
ci.mat(alpha = 0.1)
```

```
##      Estimate   5.0% 95.0%
## [1,]        1  1.000 1.000
## [2,]        0 -1.645 1.645
```

``` r
exp(c(log(RR), SE.lrr) %*% ci.mat(alpha = 0.1))
```

```
##      Estimate  5.0% 95.0%
## [1,]    2.159 1.275 3.654
```
-  Now achieve this using a Poisson model. For that we first combine
the group-specific numbers into pertinent vectors and specify a factor to represent the contrast between the exposed and the unexposed group

``` r
D <- c(D0, D1)
Y <- c(Y0, Y1)
expos <- 0:1
```

-  Look again to the model used to analyse the rate ratio in. Often one would like to get simultaneously both
  the rates and the ratio between them. This can be achieved in one go
  using the *contrast matrix* argument `ctr.mat` to
  `ci.lin()` or `ci.exp()`. Try:

``` r
CM <- rbind(c(1, 0), c(1, 1), c(0, 1))
rownames(CM) <- c("rate 0", "rate 1", "RR 1 vs. 0")
CM
```

```
##            [,1] [,2]
## rate 0        1    0
## rate 1        1    1
## RR 1 vs. 0    0    1
```

``` r
mm <- glm(D ~ factor(expos),
  family = poisson(link = log), offset = log(Y)
)
ci.exp(mm, ctr.mat = CM)
```

```
##            exp(Est.)  2.5% 97.5%
## rate 0         2.711 1.635 4.498
## rate 1         5.854 4.042 8.479
## RR 1 vs. 0     2.159 1.153 4.042
```
-  Use the same machinery to the additive model to get the rates
  and the rate-difference in one go. Note that the annotation of the
  resulting estimates are via the column-names of the contrast matrix.

``` r
rownames(CM) <- c("rate 0", "rate 1", "RD 1 vs. 0")
ma <- glm(cbind(D, Y) ~ factor(expos),
  family = poisreg(link = identity)
)
ci.lin(ma, ctr.mat = CM)[, c(1, 5, 6)]
```

```
##            Estimate   2.5% 97.5%
## rate 0        2.711 1.3393 4.084
## rate 1        5.854 3.6857 8.022
## RD 1 vs. 0    3.143 0.5765 5.709
```
