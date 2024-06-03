## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(
  results = "hide", fig.show = "hide",
  keep.source = TRUE, include = TRUE, eps = FALSE, prefix.string = "./graph/causal"
)


## ----beerdata_1, echo=TRUE----------------------------------------------------
bdat <- data.frame(sex = c(rep(0, 500), rep(1, 500)))
# a data frame with 500 females, 500 males
bdat$beer <- rbinom(1000, 1, 0.2 + 0.5 * bdat$sex)
bdat$weight <- 60 + 10 * bdat$sex + rnorm(1000, 0, 7)
bdat$bp <- 
  110 + 0.5 * bdat$weight + 10 * bdat$beer + rnorm(1000, 0, 10)


## ----beermodels_1, echo=FALSE-------------------------------------------------
library(Epi)
m1a <- lm(weight ~ beer, data = bdat)
m2a <- lm(weight ~ beer + sex, data = bdat)
m3a <- lm(weight ~ beer + sex + bp, data = bdat)
ci.lin(m1a)
ci.lin(m2a)
ci.lin(m3a)


## ----beerdata_2, echo=TRUE----------------------------------------------------
bdat$weight <- 
  60 + 10 * bdat$sex + 2 * bdat$beer + rnorm(1000, 0, 7)


## ----beermodels_2b, echo=FALSE------------------------------------------------
bdat$bp <- 
  110 + 0.5 * bdat$weight + 10 * bdat$beer + rnorm(1000, 0, 10) 
m1b <- lm(weight ~ beer, data = bdat)
m2b <- lm(weight ~ beer + sex, data = bdat)
m3b <- lm(weight ~ beer + sex + bp, data = bdat)
ci.lin(m1b)
ci.lin(m2b) # the correct model
ci.lin(m3b)


## ----bpmodel, echo=FALSE------------------------------------------------------
m1bp <- lm(bp ~ beer, data = bdat)
m2bp <- lm(bp ~ beer + weight + sex, data = bdat)
ci.lin(m1bp)
ci.lin(m2bp) # the correct model


## ----dagitty1, echo=TRUE------------------------------------------------------
if (!("dagitty" %in% installed.packages())){
  install.packages("dagitty")
}
library(dagitty)


## ----dagitty2, echo = TRUE, message = FALSE, fig.show=FALSE,results=FALSE, fig.keep='none'----
g <- dagitty("dag {
    C <- S -> Y -> U -> D
    C -> Z <- Y
    Z -> D
    C <- X -> D
    C -> Q
    W -> D
  }")
plot(g)


## ----dagitty3, echo=TRUE, warning=FALSE, message=FALSE, fig.show=TRUE, fig.width=4, fig.height=3----
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


## ----dagitty4, echo=TRUE------------------------------------------------------
paths(g, "C", "D")$paths


## ----dagitty5, echo=TRUE------------------------------------------------------
adjustmentSets(
  g, exposure = "C", outcome = "D", effect = "direct"
)
adjustmentSets(
  g, exposure = "C", outcome = "D", effect = "total"
)


## ----dagitty6, echo=FALSE-----------------------------------------------------
bg <- dagitty("dag {
  SEX -> BEER -> BP
  SEX -> WEIGHT -> BP
  }")
coordinates(bg) <- 
  list(
    x = c(BEER = 1, SEX = 2, BP = 2, WEIGHT = 3), 
    y = c(SEX = 1, BEER = 2, WEIGHT = 2, BP = 3)
  )
plot(bg)


## ----dagitty7, echo=FALSE-----------------------------------------------------
paths(bg, "BEER", "WEIGHT")


## ----dagitty8, echo=FALSE-----------------------------------------------------
adjustmentSets(bg, exposure = "BEER", outcome = "WEIGHT")


## ----threedags, echo=TRUE, fig.width=8, fig.height=3, fig.show=TRUE-----------
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


## ----gendata, echo=TRUE, results=TRUE-----------------------------------------
source("gendata.r")
head(dat)


## ----mrdat1, echo=TRUE--------------------------------------------------------
n <- 10000
mrdat <- data.frame(G = rbinom(n, 2, 0.2))
table(mrdat$G)


## ----mrdat2, echo=TRUE--------------------------------------------------------
mrdat$U <- rnorm(n)


## ----mrdat3, echo=T-----------------------------------------------------------
mrdat$BMI <- with(mrdat, 25 + 0.7 * G + 2 * U + rnorm(n))


## ----mrdat4, echo=TRUE--------------------------------------------------------
mrdat$Y <- 
  with(mrdat, 3 + 0.1 * BMI - 1.5 * U + rnorm(n, 0, 0.5))


## ----mrmod1, echo=F-----------------------------------------------------------
mxy <- lm(Y ~ BMI, data = mrdat)
ci.lin(mxy)


## ----mrmod2, echo=F-----------------------------------------------------------
mxyg <- lm(Y ~ G + BMI, data = mrdat)
ci.lin(mxyg)


## ----mrmod3, echo=T-----------------------------------------------------------
mgx <- lm(BMI ~ G, data = mrdat)
ci.lin(mgx) # check the instrument effect
bgx <- mgx$coef[2] # save the 2nd coefficient (coef of G)
mgy <- lm(Y ~ G, data = mrdat)
ci.lin(mgy)
bgy <- mgy$coef[2]
causeff <- bgy / bgx
causeff # closer to 0.1?


## ----mrsim, echo=TRUE---------------------------------------------------------
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


## ----mrsim2, echo=T-----------------------------------------------------------
summary(mr)


## ----mrsim3, echo=TRUE--------------------------------------------------------
mrdat$Y <- 
  with(
    mrdat, 
    3 + 0.1 * BMI - 1.5 * U + 0.05 * G + rnorm(n, 0, 0.5)
  )


## ----tsls, echo=TRUE----------------------------------------------------------
if (!("sem" %in% installed.packages())) install.packages("sem")
library(sem)
summary(tsls(Y ~ BMI, ~G, data = mrdat))

