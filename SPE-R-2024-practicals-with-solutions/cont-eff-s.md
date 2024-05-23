




# Poisson regression & analysis of curved effects

This exercise deals with modelling incidence rates
using Poisson regression. Our special interest is in
estimating and reporting  curved effects of continuous
explanatory variables on the theoretical rate

We analyse the `testisDK` data found in the
`Epi` package.
<!-- % already introduced and analyzed in the previous lecture,  -->
It contains the numbers of cases of testis cancer and mid-year
populations (person-years) in 1-year age groups in Denmark during
1943-96. In this analysis age and calendar time
are first treated as categorical
but finally, a penalized spline model is fitted. 


## Testis cancer: Data input and housekeeping

Load the packages and the data set, and inspect its structure:

- There are nearly 5000 observations from 90 one-year age groups
  and 54 calendar years. To get a clearer picture of what's going on,
  we do some housekeeping. The age range will be limited to 15-79
  years, and age and period are both categorized into 5-year intervals
  - according to the time-honoured practice in epidemiology.



## Some descriptive analysis

Computation and tabulation of incidence rates

-  Tabulate numbers of cases and person-years, and compute the
  incidence rates (per 100,000 y) in each 5 y $\times$ 5 y cell using
  `stat.table()`

Look at the incidence rates in the column margin and in the row
margin.  In which age group is the marginal age-specific rate highest?
Do the period-specific marginal rates have any trend over time?

-  From the saved table object `tab` you can plot an
  age-incidence curve for each period separately, after you have
  checked the structure of the table, so that you know the relevant
  dimensions in it. There is a function `rateplot()` in `Epi`
  that does default plotting of tables of rates (see the help page of
 `rateplot`)
 


Is there any common pattern in the age-incidence curves across the periods?

## Age and period as categorical factors

We shall first  fit a Poisson regression model with log link
on age and period model in the traditional way,
in which both factors are treated as categorical.
The model is additive on the log-rate scale.
It is useful to scale the person-years to be expressed in $10^5$ y.
In fitting the model we utilize the `poisreg` family object
found in package `Epi`. 


What do the estimated rate ratios tell about the age and period effects? 

-  A graphical inspection of point estimates and confidence
  intervals can be obtained as follows. In the beginning it is useful
  to define shorthands for the pertinent mid-age and mid-period values
  of the different intervals

-  In the fitted model the reference category for each factor was
  the first one.  As age is the dominating factor, it may be more
  informative to remove the intercept from the model.  As a
  consequence the age effects describe fitted rates at the reference
  level of the period factor. For the latter one could choose the
  middle period 1968-72.

We shall plot just the point estimates from the latter model



## Generalized additive model with penalized splines

It is obvious that the age effect on the log-rate scale is highly
non-linear. Yet, it is less clear whether the true period effect
deviates from linearity. Nevertheless, there are good reasons to
try fitting smooth continuous functions for both time scales. 

-  As the next task we fit a generalized additive model for the
  log-rate on continuous age and period applying penalized splines
  with default settings of function `gam()` in package
  `mgcv`. In this fitting an *optimal* value for the penalty
  parameter is chosen based on an AIC-like criterion known as UBRE.

The summary is quite brief, and the only estimated coefficient is the
intercept, which sets the baseline level for the log-rates, against
which the relative age effects and period effects will be contrasted.
On the rate scale the baseline level 5.53 per 100000 y is obtained by
`exp(1.7096)`.

-  See also the default plot for the fitted curves (solid lines)
  describing the age and the period effects which are interpreted as
  contrasts to the baseline level on the log-rate scale.

The dashed lines describe the 95% confidence band for the pertinent
curve.  One could get the impression that year 1968 would be some kind
of reference value for the period effect, like period 1968-72 
chosen as the reference  in the categorical
model previously fitted. This is not the case, however, because 
`gam()` by default parametrizes the spline effects such that the
reference level, at which the spline effect is nominally zero, is the
overall *grand mean* value of the log-rate in the data. This
corresponds to the principle of *sum contrasts* (`contr.sum`)
for categorical explanatory factors.

<!-- % The confidence band indicates, namely, that there is uncertainty -->
<!-- % about the true age effect curve about the overall (*grand mean*) -->
<!-- % log-rate both in vertical and in horizontal direction, and there is -->
<!-- % no fixed reference level. -->

From the summary you will also find that the degrees of freedom value
required for the age effect is nearly the same as the default
dimension $k-1 = 9$ of the part of the model matrix (or basis)
initially allocated for each smooth function. (Here $k$ refers to the
relevant argument that determines the basis dimension when specifying
a smooth term by `s()` in the model formula).  On the other
hand the period effect takes just about 3 df.

-  It is a good idea to do some diagnostic checking of the fitted
  model

The four diagnostic plots are analogous to some of those used in
the context of linear models for Gaussian responses, but not all of them
may be as easy to interpret. - Pay attention to the note
given in the printed output about the value of `k`.

- Let us refit the model but now with an increased `k` for age:

With this choice of `k` the df value for age became about 11,
which is well below $k-1 = 19$. Let us plot the fitted curves from
this fitting, too

There does not seem to have happened any essential changes from the
previously fitted curves, so maybe 8 df could, after all, be quite
enough for the age effect.

-  Graphical presentation of the effects using `plot.gam()`
 can be improved. For instance, we may present the
  age effect to describe the *mean* incidence rates by age, averaged
  over the whole time span of 54 years. This is obtained by adding 
  the estimated intercept
  to the estimated smooth curve for the age effect and showing
  the antilogarithms of the ordinates of the curve.
  For that purpose we need to extract the intercept and modify the
  labels of the $y$-axis accordingly. The estimated period curve 
  can also be expressed in terms of
 relative indidence rates in relation to the fitted baseline rate, 
 as determined  by the model intercept.


**Homework** 
You could continue the analysis of these data by fitting an age-cohort
model as an alternative to the age-period model, as well as an
age-cohort-period model utilizing function `apc.fit()` in
`Epi`. See (http://bendixcarstensen.com/APC/) for details.