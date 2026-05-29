
# Causal inference

## Proper adjustment for confounding in regression models

The first exercise of this session will ask you to simulate some data
according to pre-specified causal structure (don't take the particular
example too seriously) and see how you should adjust the analysis to
obtain correct estimates of the causal effects.

Suppose one is interested in the effect of beer-drinking on body weight.
Let's *assume* that in addition to the potential effect of beer on weight, the following is true in reality:

-  Beer-drinking has an effect on the body weight.
-  Men drink more beer than women
-  Men have higher body weight than women
-  People with higher body weight tend to have higher blood pressure
-  Beer-drinking increases blood pressure


The task is to simulate a dataset in accordance with this model, and
subsequently analyse it to see, whether the results would allow us to
conclude the true association structure.


-  Sketch a DAG (not necessarily with R) to see, how should one generate the data
-  Suppose the actual effect sizes are following:

-  The probability of beer-drinking is 0.2 for females and 0.7 for males
-  Men weigh on average $10kg$ more than women.
-  One kg difference in body weight corresponds in
average to $0.5mmHg$ difference in (systolic) blood pressures.
-  Beer-drinking increases blood pressure by $10mmHg$ in average.
-  Beer-drinking has **no** effect on body weight.


The `R` commands to generate the data are:

``` r
bdat <- data.frame(sex = c(rep(0, 500), rep(1, 500)))
# a data frame with 500 females, 500 males
bdat$beer <- rbinom(1000, 1, 0.2 + 0.5 * bdat$sex)
bdat$weight <- 60 + 10 * bdat$sex + rnorm(1000, 0, 7)
bdat$bp <- 
  110 + 0.5 * bdat$weight + 10 * bdat$beer + rnorm(1000, 0, 10)
```
-  Now fit the following models for body weight as dependent
  variable and beer-drinking as independent variable. Look, what is
  the estimated effect size:

-  Unadjusted (just simple linear regression)
-  Adjusted for sex
-  Adjusted for sex and blood pressure


```
##              Estimate    StdErr          z            P     2.5%     97.5%
## (Intercept) 63.268034 0.3328823 190.061251 0.000000e+00 62.61560 63.920471
## beer         5.112309 0.5167336   9.893511 4.441719e-23  4.09953  6.125089
```

```
##               Estimate    StdErr            z            P      2.5%     97.5%
## (Intercept) 60.5512425 0.3197465 189.37266448 0.000000e+00 59.924551 61.177934
## beer        -0.0171005 0.5197817  -0.03289938 9.737548e-01 -1.035854  1.001653
## sex          9.6909922 0.5122158  18.91974344 7.843536e-80  8.687068 10.694917
```

```
##               Estimate     StdErr         z            P       2.5%      97.5%
## (Intercept) 28.9749583 2.79179719 10.378604 3.102781e-25 23.5031363 34.4467802
## beer        -2.2849352 0.52827920 -4.325242 1.523647e-05 -3.3203434 -1.2495270
## sex          8.8009014 0.48841212 18.019416 1.371831e-72  7.8436313  9.7581716
## bp           0.2240266 0.01969175 11.376673 5.464493e-30  0.1854315  0.2626217
```

-  What would be the conclusions on the effect of beer on weight, based on the three models? Do they agree? 
Which (if any) of the models gives an unbiased estimate of the
  actual causal effect of interest?

-  How can the answer be seen from the graph?

-  Now change the data-generation algorithm so, that in fact beer-drinking
  does increase the body weight by 2kg. Look, what are
  the conclusions in the above models now. 
Thus the data is generated as before, but the weight variable is computed as:

``` r
bdat$weight <- 
  60 + 10 * bdat$sex + 2 * bdat$beer + rnorm(1000, 0, 7)
```


```
##              Estimate    StdErr         z           P      2.5%     97.5%
## (Intercept) 62.757557 0.3382003 185.56328 0.00000e+00 62.094696 63.420417
## beer         7.128252 0.5249887  13.57792 5.41455e-42  6.099293  8.157211
```

```
##              Estimate    StdErr          z            P       2.5%     97.5%
## (Intercept) 59.934833 0.3221713 186.034055 0.000000e+00 59.3033886 60.566277
## beer         1.798836 0.5237235   3.434706 5.931970e-04  0.7723571  2.825316
## sex         10.068863 0.5161003  19.509509 9.115265e-85  9.0573250 11.080401
```

```
##               Estimate    StdErr         z            P       2.5%      97.5%
## (Intercept) 26.3393053 2.7653002  9.524935 1.651452e-21 20.9194164 31.7591941
## beer        -0.7777762 0.5321709 -1.461516 1.438739e-01 -1.8208120  0.2652595
## sex          8.9999099 0.4893950 18.389870 1.583602e-75  8.0407134  9.9591065
## bp           0.2399691 0.0196352 12.221376 2.390060e-34  0.2014848  0.2784534
```

-  Suppose one is interested in the effect of beer-drinking on blood pressure instead, and is fitting a) an unadjusted model  for blood pressure, with beer as an only covariate; b) a model with beer and sex as covariates. Would either a) or b) give an unbiased estimate for the effect? (You may double-check whether the simulated data is consistent with your answer).


```
##              Estimate    StdErr         z            P      2.5%     97.5%
## (Intercept) 141.24818 0.4400473 320.98413 0.000000e+00 140.38571 142.11066
## beer         13.09504 0.6830858  19.17042 6.537565e-82  11.75622  14.43387
```

```
##                Estimate     StdErr         z            P        2.5%
## (Intercept) 107.4291182 2.70313922 39.742355 0.000000e+00 102.1310626
## beer          9.7597302 0.73964960 13.195073 9.366444e-40   8.3100437
## weight        0.5434281 0.04446538 12.221376 2.390060e-34   0.4562775
## sex          -1.0171587 0.85176725 -1.194174 2.324097e-01  -2.6865918
##                   97.5%
## (Intercept) 112.7271737
## beer         11.2094168
## weight        0.6305786
## sex           0.6522745
```


## DAG tools in the package `dagitty`

There is a software *DAGitty* ([http://www.dagitty.net/](http://www.dagitty.net/)) and also an R package *dagitty* that can be helpful in dealing with DAGs. Let's try to get the answer to the previous exercise using this package. 

``` r
if (!("dagitty" %in% installed.packages())){
  install.packages("dagitty")
}
library(dagitty)
```

```
## 
## Attaching package: 'dagitty'
```

```
## The following object is masked from 'package:Epi':
## 
##     paths
```


Let's recreate the graph on the lecture slide 28 (but omitting the direct causal effect of interest, $C \rightarrow D$):

``` r
g <- dagitty("dag {
    C <- S -> Y -> U -> D
    C -> Z <- Y
    Z -> D
    C <- X -> D
    C -> Q
    W -> D
  }")
plot(g)
```

To get a more similar look as on the slide, we must supply the coordinates (x increases from left to right, y from top to bottom):


``` r
coordinates(g) <- 
  list(
    x = 
      c(
        S = 1, C = 1, Q = 1, Y = 2, Z = 2, 
        X = 2, U = 3, D = 3, W = 3
      ),
    y = 
      c(
        U = 1, Y = 1, S = 1, Z = 2, C = 3, 
        D = 3, X = 4, W = 4, Q = 4
      )
  )
plot(g)
```

![](causal-s_files/figure-epub3/dagitty3-1.png)<!-- -->

Let's look at all possible paths from $C$ to $D$:

``` r
paths(g, "C", "D")
```

```
## $paths
## [1] "C -> Z -> D"           "C -> Z <- Y -> U -> D" "C <- S -> Y -> U -> D"
## [4] "C <- S -> Y -> Z -> D" "C <- X -> D"          
## 
## $open
## [1]  TRUE FALSE  TRUE  TRUE  TRUE
```
As you see, one path contains a collider and is therefore a *closed* path and the others are *open*.   

Let's identify the minimal sets of variables needed to adjust the model for $D$ for, to obtain an unbiased estimate of the effect of $C$. You can specify, whether you want to estimate direct or total effect of $C$:


``` r
adjustmentSets(
  g, exposure = "C", outcome = "D", effect = "direct"
)
```

```
## { U, X, Z }
## { X, Y, Z }
```

``` r
adjustmentSets(
  g, exposure = "C", outcome = "D", effect = "total"
)
```

```
## { X, Y }
## { S, X }
```

Thus, for total effect estimation one should adjust for $X$ and either $Y$ or $S$, whereas for direct effect estimation, one would also need to adjust for $Z$.

You can verify that, these are the variables that will block all open paths from $C$ to $D$. 

**Now try to do the *beer-weight* exercise using *dagitty*: **

-  Create the DAG and plot it
![](causal-s_files/figure-epub3/dagitty6-1.png)<!-- -->
-  What are the paths from WEIGHT to BEER?

```
## $paths
## [1] "BEER -> BP <- WEIGHT"  "BEER <- SEX -> WEIGHT"
## 
## $open
## [1] FALSE  TRUE
```
-  Will you get the same recommendation for the adjustment variable selection as you found before?

```
## { SEX }
```

## Identifying the true DAG for the data
The following code creates three DAGs


``` r
par(mfrow=c(1,3))
g1 <- dagitty("dag {
	U -> Z -> Y 
	U -> X
	W -> Y
	Q -> W -> X
	Q -> Y
	}")
g2 <- dagitty("dag {
	U -> Z -> Y -> W 
	U -> X -> W 
	Q -> W
	Q -> Y
	}")
g3 <- dagitty("dag {
	U -> Z -> Y 
	U -> X -> W  -> Y
	Q -> W
	Q -> Y
	}")
coord <- 
  list( x = c(X=1, U = 1.3, W = 2, Z = 2.3, Q = 2.7, Y=3), 
        y = c(U=1,   Z=1.3, X=2, Y=2,   W=2.7,  Q=3)
  )
coordinates(g1)<-coordinates(g2)<-coordinates(g3)<-coord
plot(g1)
title("(a)")
plot(g2)
title("(b)")
plot(g3)
title("(c)")
```

![](causal-s_files/figure-epub3/threedags-1.png)<!-- -->

Now, the following script generates a dataset:


``` r
source("data/gendata.r")
head(dat)
```

```
##        Q      W      X      Z       Y
## 1 -0.397  1.056  0.199 -0.372  -4.198
## 2  0.460  2.393 -1.647 -3.004 -10.667
## 3  0.164 -0.364  0.205 -0.852  -1.830
## 4  1.584  3.285 -9.941  2.752  -4.121
## 5  1.048  1.637  0.783 -2.047  -4.378
## 6  1.895  3.272 -3.900 -2.313  -9.871
```

*Exercise:* Using linear models, try to identify, which of the three DAGs has been used to generate the data.  


``` r
adjustmentSets(g1,"X","Y", effect="direct")
```

```
## { W, Z }
## { U, W }
```

``` r
summary(lm(Y~X+W+Z,data=dat))
```

```
## 
## Call:
## lm(formula = Y ~ X + W + Z, data = dat)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.9888 -0.7441  0.0096  0.7657  3.5928 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  0.033168   0.024551   1.351    0.177    
## X           -0.001691   0.014877  -0.114    0.909    
## W           -2.599607   0.031987 -81.270   <2e-16 ***
## Z            1.014166   0.021197  47.846   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.097 on 1996 degrees of freedom
## Multiple R-squared:  0.9686,	Adjusted R-squared:  0.9686 
## F-statistic: 2.054e+04 on 3 and 1996 DF,  p-value: < 2.2e-16
```

``` r
# no X effect: this DAG is possible

adjustmentSets(g2,"X","Y", effect="direct")
```

```
## { Z }
## { U }
```

``` r
summary(lm(Y~X+Z,data=dat))
```

```
## 
## Call:
## lm(formula = Y ~ X + Z, data = dat)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -7.480 -1.568 -0.107  1.580  8.730 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  0.10067    0.05092   1.977   0.0482 *  
## X            1.13137    0.01077 105.040   <2e-16 ***
## Z            2.38032    0.02680  88.830   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.277 on 1997 degrees of freedom
## Multiple R-squared:  0.8648,	Adjusted R-squared:  0.8647 
## F-statistic:  6387 on 2 and 1997 DF,  p-value: < 2.2e-16
```

``` r
# X effect is significant: this DAG is not likely

adjustmentSets(g3,"X","Y", effect="direct")
```

```
## { Q, W, Z }
## { Q, U, W }
```

``` r
summary(lm(Y~X+Q+W+Z,data=dat))
```

```
## 
## Call:
## lm(formula = Y ~ X + Q + W + Z, data = dat)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.7210 -0.6425  0.0031  0.6596  3.1985 
## 
## Coefficients:
##              Estimate Std. Error t value Pr(>|t|)    
## (Intercept)  0.019576   0.022168   0.883    0.377    
## X           -0.006038   0.013429  -0.450    0.653    
## Q            1.071881   0.050242  21.335   <2e-16 ***
## W           -3.033392   0.035312 -85.903   <2e-16 ***
## Z            1.003544   0.019138  52.437   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.9903 on 1995 degrees of freedom
## Multiple R-squared:  0.9745,	Adjusted R-squared:  0.9744 
## F-statistic: 1.902e+04 on 4 and 1995 DF,  p-value: < 2.2e-16
```

``` r
# no X effect: this DAG is possible

adjustmentSets(g1,"Z","W")
```

```
##  {}
```

``` r
summary(lm(W~Z,data=dat))
```

```
## 
## Call:
## lm(formula = W ~ Z, data = dat)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -9.5057 -1.5539  0.0044  1.4534  8.0072 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)
## (Intercept) -0.02154    0.04919  -0.438    0.661
## Z            0.01908    0.02238   0.852    0.394
## 
## Residual standard error: 2.2 on 1998 degrees of freedom
## Multiple R-squared:  0.0003635,	Adjusted R-squared:  -0.0001368 
## F-statistic: 0.7266 on 1 and 1998 DF,  p-value: 0.3941
```

``` r
# no Z effect: this DAG is possible

adjustmentSets(g3,"Z","W")
```

```
## { X }
## { U }
```

``` r
summary(lm(W~Z+X,data=dat))
```

```
## 
## Call:
## lm(formula = W ~ Z + X, data = dat)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -2.5471 -0.4981  0.0016  0.5336  2.3622 
## 
## Coefficients:
##              Estimate Std. Error  t value Pr(>|t|)    
## (Intercept) -0.025965   0.017165   -1.513    0.131    
## Z           -0.525522   0.009033  -58.178   <2e-16 ***
## X           -0.435859   0.003631 -120.044   <2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.7676 on 1997 degrees of freedom
## Multiple R-squared:  0.8783,	Adjusted R-squared:  0.8782 
## F-statistic:  7208 on 2 and 1997 DF,  p-value: < 2.2e-16
```

``` r
# significant Z effect: this DAG is possible
```

If you have made your decision, you may check the script 'gendata.r' to see, whether your guess was right. 

## Instrumental variables estimation: Mendelian randomization
Suppose you want to estimate the effect of Body Mass Index (BMI) on blood glucose level (associated with the risk of diabetes).
 Let's conduct a simulation study to verify that when the exposure-outcome association is confounded, but there is a valid instrument (genotype), one obtains an unbiased estimate of the causal effect. 

-  Start by generating the genotype variable as *Binomial(2,p)*, with $p=0.2$ (and look at the resulting genotype frequencies):

``` r
n <- 10000
mrdat <- data.frame(G = rbinom(n, 2, 0.2))
table(mrdat$G)
```

```
## 
##    0    1    2 
## 6394 3243  363
```
-  Also generate the confounder variable U 

``` r
mrdat$U <- rnorm(n)
```

-  Generate a continuous (normally distributed) exposure variable $BMI$ so that it depends on $G$ and $U$. 
Check with linear regression, whether there is enough power to get significant parameter estimates.  
For instance:

``` r
mrdat$BMI <- with(mrdat, 25 + 0.7 * G + 2 * U + rnorm(n))
```
-  Finally generate $Y$ ("Blood glucose level") so that it depends on $BMI$ and $U$ (but not on $G$).

``` r
mrdat$Y <- 
  with(mrdat, 3 + 0.1 * BMI - 1.5 * U + rnorm(n, 0, 0.5))
```
-  Verify, that simple regression model for $Y$, with $BMI$ as a covariate, results in a biased 
estimate of the causal effect (parameter estimate is different from what was generated) 

```
##              Estimate      StdErr         z P       2.5%      97.5%
## (Intercept) 17.814562 0.097792556  182.1668 0 17.6228919 18.0062316
## BMI         -0.486091 0.003850138 -126.2529 0 -0.4936372 -0.4785449
```
How different is the estimate from 0.1?  

-   Estimate a regression model for $Y$ with two covariates, $G$ and $BMI$. Do you see a significant effect of $G$?
Could you explain analytically, why one may see a significant parameter estimate for $G$ there?

```
##               Estimate      StdErr          z             P       2.5%
## (Intercept) 18.0909026 0.094546402  191.34417  0.000000e+00 17.9055950
## G            0.4322114 0.015159003   28.51186 8.349696e-179  0.4025003
## BMI         -0.5037944 0.003754425 -134.18684  0.000000e+00 -0.5111529
##                  97.5%
## (Intercept) 18.2762101
## G            0.4619225
## BMI         -0.4964359
```

-  Find an IV (instrumental variables) estimate, using G as an instrument, by following the algorithm 
in the lecture notes (use two linear models and find a ratio of the parameter estimates). 
Does the estimate get closer to the generated effect size?

``` r
mgx <- lm(BMI ~ G, data = mrdat)
ci.lin(mgx) # check the instrument effect
```

```
##               Estimate     StdErr        z            P       2.5%     97.5%
## (Intercept) 25.0344094 0.02728767 917.4255 0.000000e+00 24.9809266 25.087892
## G            0.6677507 0.03982435  16.7674 4.226261e-63  0.5896964  0.745805
```

``` r
bgx <- mgx$coef[2] # save the 2nd coefficient (coef of G)
mgy <- lm(Y ~ G, data = mrdat)
ci.lin(mgy)
```

```
##               Estimate     StdErr          z            P       2.5%     97.5%
## (Intercept) 5.47870698 0.01714404 319.569267 0.0000000000 5.44510528 5.5123087
## G           0.09580235 0.02502046   3.828961 0.0001286856 0.04676316 0.1448416
```

``` r
bgy <- mgy$coef[2]
causeff <- bgy / bgx
causeff # closer to 0.1?
```

```
##         G 
## 0.1434702
```

-   A proper simulation study would require the analysis to be run several times, to see the extent of variability in the parameter estimates. 
A simple way to do it here would be using a `for`-loop. Modify the code as follows (exactly the same commands as executed so far, adding a few lines of code to the beginning and to the end):

``` r
n <- 10000
# initializing simulations:
# 30 simulations (change it, if you want more):
nsim <- 30
mr <- rep(NA, nsim) # empty vector for the outcome parameters
for (i in 1:nsim) { # start the loop
  ## Exactly the same commands as before:
  mrdat <- data.frame(G = rbinom(n, 2, 0.2))
  mrdat$U <- rnorm(n)
  mrdat$BMI <- 
    with(mrdat, 25 + 0.7 * G + 2 * U + rnorm(n))
  mrdat$Y <- 
    with(mrdat, 3 + 0.1 * BMI - 1.5 * U + rnorm(n, 0, 0.5))
  mgx <- lm(BMI ~ G, data = mrdat)
  bgx <- mgx$coef[2]
  mgy <- lm(Y ~ G, data = mrdat)
  bgy <- mgy$coef[2]
  # Save the i'th parameter estimate:
  mr[i] <- bgy / bgx
} # end the loop
```
Now look at the distribution of the parameter estimate:

``` r
summary(mr)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
## 0.03929 0.07114 0.09158 0.09942 0.12628 0.18344
```

-  (*optional*) Change the code of simulations so that the assumptions are violated: add a weak direct effect of the genotype G to the equation that generates $Y$:

``` r
mrdat$Y <- 
  with(
    mrdat, 
    3 + 0.1 * BMI - 1.5 * U + 0.05 * G + rnorm(n, 0, 0.5)
  )
```
Repeat the simulation study to see, what is the bias in the average estimated causal effect of $BMI$ on $Y$.

-  (*optional*) Using library `sem`  and function `tsls`, one can obtain a two-stage least squares estimate for the  
causal effect and also the proper standard error. Do you get the same estimate as before? 

``` r
if (!("sem" %in% installed.packages())) install.packages("sem")
library(sem)
summary(tsls(Y ~ BMI, ~G, data = mrdat))
```

```
## 
##  2SLS Estimates
## 
## Model Formula: Y ~ BMI
## 
## Instruments: ~G
## 
## Residuals:
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## -6.67516 -1.12096  0.01737  0.00000  1.14845  6.30438 
## 
##               Estimate Std. Error t value   Pr(>|t|)    
## (Intercept) 1.82986792 1.05930298 1.72743 0.08412200 .  
## BMI         0.14814836 0.04198705 3.52843 0.00041991 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 1.6870674 on 9998 degrees of freedom
```
(There are also several other R packages for IV estimation and Mendelian Randomization (*MendelianRandomization* for instance))




## Why are simulation exercises useful for causal inference?

If we simulate the data, we know the data-generating mechanism and the *true* causal effects. So this is a way to check, whether 
an analysis approach will lead to estimates that correspond to what is generated. One could expect to see similar phenomena in real
data analysis, if the data-generation mechanism is similar to what was used in simulations.


