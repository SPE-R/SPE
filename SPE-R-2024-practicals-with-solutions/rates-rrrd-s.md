---
output:
  pdf_document: default
  html_document: default
---





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





## Poisson model for a single rate with logarithmic link

You are able to estimate the hazard rate $\lambda$ and compute its CI with a **Poisson regression model**, as described in the relevant slides in the lecture handout. 

Poisson regression is a **generalized linear model** in which the **family**, *i.e.* the distribution of the response variable, is assumed to be the Poisson distribution. The most commonly applied **link function**
in Poisson regression is the natural logarithm; log for short. 


- 
A family object `poisreg`, a modified version of the original `poisson` family object, is available
in package `Epi`. When using this, the response is defined as a *matrix* of two columns: numbers
of cases $D$ and person-years $Y$, these being combined into a matrix by `cbind(D,Y)`. No specification
of `offset` is needed.

-  If you want confidence interval for log rate


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

How is the coefficient of this model interpreted?
Verify that you actually get the same rate estimate and CI as in section 1.6.1, item 1.


## Poisson model assuming the same rate for several periods

Now, suppose the events and person years are collected over  three distinct periods.


-  Read in the data and compute period-specific rates

-  Using these data, 
fit the same model with log link as in section 1.6.2, assuming a common single hazard $\lambda$ 
  for the separate periods. Compare the result from the previous ones


-  Now test whether the rates are the same in the three periods:
  Try to fit a model with the period as a factor in the model:

Compare the goodness-of-fit of the two models using `anova()` with the argument
`test="Chisq"`:

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


-  Now achieve this using a Poisson model. For that we first combine
the group-specific numbers into pertinent vectors and specify a factor to represent the contrast between the exposed and the unexposed group

What do the parameters mean in this model?

-  You can extract the estimation results for exponentiated parameters in two ways, as before:



## Analysis of rate difference

For the **hazard difference** $\delta = \lambda_1 - \lambda_0$,
the  natural estimator is the **incidence rate difference**
$$ \widehat\delta = \widehat\lambda_1  - \widehat\lambda_0 = D_1/Y_1 - D_0/Y_0 = \mbox{RD} . $$ 
Its variance is just the sum of the variances of the two rates 
<!-- (since the latter are  based on independent samples): -->
$$ var(RD) = var(\widehat\lambda_1 ) + var( \widehat\lambda_0 ) =  D_1/Y_1^2 + D_0/Y_0^2 $$

-  Use this formula to compute the point estimate of the rate difference $\lambda$ and a 95\%   confidence interval for it:

-  Verify that this is the confidence interval you get when you fit
  an additive model (obtained by identity link) with exposure as a factor:




## Binary regression

Explore the factors associated with risk of low birth weight 
in 500 singleton births in a London Hospital. Indicator (lowbw) for birth weight less than 2500 g. Data available from the Epi package. Factor of interest is
maternal hypertension (hyp).

Load the `Epi` package and the data set and look at its content


-  Because all variables are numeric we need first to do a little housekeeping. 
Two of them are directly converted into factors,
and categorical versions are created of two continuous variables by function `cut()`.
<!-- Also, express birth weights in kilograms -->



-  Cross tabulate (dplyr) counts of children by hypertension and low birth weight. 
calculate (mutate) proportions of low birth weight children by hypertension.


-  Estimate *relative risk* of low birth weight for mothers with hypertension compared to those without using *twoby2()-function*.


-  Estimate *risk diffrence* of low birth weight for mothers with hypertension compared to those without using *binary regression*.


-  Estimate *relative risk* of low birth weight for mothers with hypertension compared to those without using *binary regression*.


<!-- -  Adjust relative risk of low birth and hypertension with the sex of children -->
<!-- ```{r eval=FALSE} -->
<!-- m <- glm(lowbw ~ sex + hyp, family = binomial(link = log), data = births) -->
<!-- ci.exp(m) -->
<!-- ``` -->



<!-- -  Adjust relative risk of low birth and hypertension with the sex of children and mother beeing over 35 years. -->
<!-- ```{r eval=FALSE} -->
<!-- m <- glm(lowbw ~ maged + sex + hyp, family = binomial(link = log), data = births) -->
<!-- ci.exp(m) -->
<!-- ``` -->


## Optional/Homework: Hand calculations and calculations using matrix tools

> NB. This subsection requires some familiarity with matrix algebra. Do this only after you have done the other exercises of this session.

First some basic hand calculations.

-  Suppose $15$ outcome events are observed during $5532$ person-years in a given study cohort. 
  Let's  use R as a simple desk calculator to estimate the underlying hazard rate $\lambda$ (in 1000
  person-years; therefore 5.532) and to get the first version of an approximate confidence
  interval:




-  Compute now the approximate confidence interval using the method
based on log-transformation and compare the result with that in the previous item.



-  Calculate the incidence rates in the two groups, their ratio, and the  
CI of the true hazard ratio $\rho$ by direct application of the above formulae:



-  Explore the function `ci.mat()`, which lets you use
  matrix multiplication (operator `'%*%'`
  in R) to produce a confidence interval from an estimate and its
  standard error (or CIs from whole columns of estimates and SEs):

As you see, this function returns a $2\times 3$ matrix (2 rows, 3 columns) containing familiar numbers.

-  When you combine the single rate and its standard error into 
a row vector of length 2, i.e. a $1\times 2$ matrix, and multiply this 
by the $2\times 3$ matrix above, the computation returns 
a $1\times 3$ matrix containing the point estimate and the
confidence limit.

Apply this method to the single rate calculations in 1.6.1, first creating the $1 \times 2$ matrix and then performing the matrix multiplication.

-  When the confidence interval is based on the log-rate and its
  standard error, the result is obtained by appropriate application of
  the exp-function on the pertinent matrix product

-  For computing the rate ratio and its CI as in 1.6.5, matrix
  multiplication with `ci.mat()` should give the same result as
  there:

-  The main argument in function `ci.mat()` is `alpha`,
  which sets the confidence level: $1 - \alpha$. The default value is
  `alpha = 0.05`, corresponding to the level $1 - 0.05$ = 95%. 
  If you wish to get the confidence interval for the rate ratio at
  the 90% level (= $1-0.1$), for instance, you may proceed as
  follows:

-  Now achieve this using a Poisson model. For that we first combine
the group-specific numbers into pertinent vectors and specify a factor to represent the contrast between the exposed and the unexposed group


-  Look again to the model used to analyse the rate ratio in. Often one would like to get simultaneously both
  the rates and the ratio between them. This can be achieved in one go
  using the *contrast matrix* argument `ctr.mat` to
  `ci.lin()` or `ci.exp()`. Try:

-  Use the same machinery to the additive model to get the rates
  and the rate-difference in one go. Note that the annotation of the
  resulting estimates are via the column-names of the contrast matrix.

