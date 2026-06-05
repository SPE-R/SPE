## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(fig.show="hide", messages=FALSE, keep.source = TRUE, include = TRUE, eps = FALSE, prefix.string = "./graph/causInf2")


## ----packages-----------------------------------------------------------------
library(dagitty)
library(Epi)
library(stdReg2)
library(PSweight)


## ----dagitty, echo=TRUE, message=FALSE, warning=FALSE, results=TRUE, fig.show=TRUE----
diagram <-
  dagitty("dag {
  Z2 -> Z3 -> Y
  Z2 -> Z4 -> Y
  Z2 -> Y
  Z2 -> Z3 -> X
  Z2 -> Z4 -> X
  Z2 -> X
  Z1 -> Z3 -> Y
  Z1 -> Z4 -> Y
  Z1 -> Y
  Z1 -> Z3 -> X
  Z1 -> Z4 -> X
}")

coordinates(diagram) <-
  list(
    x = c(X = 1, Y = 5, Z1 = 5, Z2 = 1, Z3 = 4, Z4 = 2),
    y = c(X = 2, Y = 2, Z1 = 0, Z2 = 0, Z3 = 1, Z4 = 1)
  )

plot(diagram)


## ----suff sets----------------------------------------------------------------
adjustmentSets(diagram, exposure="X", outcome="Y")


## ----true models--------------------------------------------------------------
EX <- function(z2, z3, z4) {
  plogis(-5 + 0.05 * z2 + 0.25 * z3 + 0.5 * z4 + 0.4 * z2 * z4)
}
EY <- function(x, z1, z2, z3, z4) {
  plogis(-1 + x - 0.1 * z1 + 0.35 * z2 + 0.25 * z3 +
    0.20 * z4 + 0.15 * z2 * z4)
}


## ----data generation function-------------------------------------------------
genData <- function(N) {
  z1 <- rbinom(N, size = 1, prob = 0.5) # Bern(0.5)
  z2 <- rbinom(N, size = 1, prob = 0.65) # Bern(0.65)
  z3 <- trunc(runif(N, min = 1, max = 5), digits = 0) # DiscUnif(1,4)
  z4 <- trunc(runif(N, min = 1, max = 6), digits = 0) # DiscUnif(1,5)
  x <- rbinom(N, size = 1, prob = EX(z2, z3, z4))
  y <- rbinom(N, size = 1, prob = EY(x, z1, z2, z3, z4))
  data.frame(z1, z2, z3, z4, x, y)
}


## ----popdata generation-------------------------------------------------------
N <- 1000000
set.seed(7777)
pop <- genData(N)


## ----Contr function and associational contrasts-------------------------------
Contr <- function(mu1, mu0) {
  RD <- mu1 - mu0
  RR <- mu1 / mu0
  OR <- (mu1 / (1 - mu1)) / (mu0 / (1 - mu0))
  return(c(Risk1=mu1, Risk0=mu0, RD = RD, RR = RR, OR = OR))
}
Ey1fact <- with(pop, sum(y == 1 & x == 1) / sum(x == 1))
Ey0fact <- with(pop, sum(y == 1 & x == 0) / sum(x == 0))
round(Contr(Ey1fact, Ey0fact), 4)


## ----true contrasts-----------------------------------------------------------
pop <- transform(pop,
  EY1.ind = EY(x = 1, z1, z2, z3, z4),
  EY0.ind = EY(x = 0, z1, z2, z3, z4)
)
EY1pot <- mean(pop$EY1.ind)
EY0pot <- mean(pop$EY0.ind)
round(Contr(EY1pot, EY0pot), 4)


## ----sample-------------------------------------------------------------------
n <- 5000
samp <- pop[seq(1,N, by=N/n), ]
str(samp)
EY1pot.samp <- mean(samp$EY1.ind)
EY0pot.samp <- mean(samp$EY0.ind)
round(Contr(EY1pot.samp, EY0pot.samp), 4)


## ----cases by exposure--------------------------------------------------------
stat.table(index=list("Outcome"=factor(y), "Exposure"=factor(x)),
           contents=list(count(), percent(y)),
           margins=TRUE, data=samp  )


## ----outcome model------------------------------------------------------------
mY <- glm(y ~ x + z1 + z2 + z3 + z4, family = binomial, data = pop)
round(ci.lin(mY, Exp = TRUE)[, c(1, 5:7)], 4)


## ----fitted risks and predicted potential risks-------------------------------
pop$yh <- predict(mY, type = "response")  #  fitted risk
pop$yp1 <- predict(mY, newdata = data.frame(
  x = rep(1, N),      # predicted risk assuming x=1, i.e. "if exposed"
  pop[, c("z1", "z2", "z3", "z4")]
), type = "response")
pop$yp0 <- predict(mY, newdata = data.frame(
  x = rep(0, N),      # predicted risk assuming x=0, i.e. "if unexposed"
  pop[, c("z1", "z2", "z3", "z4")]
), type = "response")


## ----causal contrasts---------------------------------------------------------
EY1pot.g <- mean(pop$yp1)
EY0pot.g <- mean(pop$yp0)
round(Contr(EY1pot.g, EY0pot.g), 4)


## ----stdReg2------------------------------------------------------------------
mY.std <- standardize_glm(
 formula = y ~ x + z1 + z2 + z3 + z4,
 family = "binomial",
 data = samp,
 values = list(x = 0:1),
 contrasts = c("difference", "ratio"),
 reference = 0
)
mY.std


## ----exposure model-----------------------------------------------------------
mX <- glm(x ~ z2 + z3 + z4 + z2:z4,
  family = binomial(link = logit), data = pop)
round(ci.lin(mX, Exp = TRUE)[, c(1, 5)], 4)


## ----propScore, fig=FALSE-----------------------------------------------------
pop$PS <- predict(mX, type = "response")
tapply(pop$PS, pop$x, summary)


## ----ipw weights--------------------------------------------------------------
pop$w <- ifelse(pop$x == 1, 1 / pop$PS, 
                            1 / (1 - pop$PS))
with(pop, tapply(w, x, sum))


## ----ipw-estimate-------------------------------------------------------------
EY1pot.w <- sum(pop$x * pop$w * pop$y) / sum(pop$x * pop$w)
EY0pot.w <- sum((1 - pop$x) * pop$w * pop$y) / sum((1 - pop$x) * pop$w)
round(Contr(EY1pot.w, EY0pot.w), 4)


## ----PSweight, fig=FALSE------------------------------------------------------
mX2 <- glm(x ~ z1 + z2 + z3 + z4, family = binomial, data = samp)
round(ci.lin(mX2, Exp = TRUE)[, c(1:2, 5:7)], 3)
psw2 <- SumStat(
  ps.formula = mX2$formula, data = samp,
  weight = c("IPW", "treated", "overlap")
)


## ----distributions of the scores, fig=FALSE-----------------------------------
plot(psw2, type = "density")


## ----check balance, fig=FALSE-------------------------------------------------
plot(psw2, type = "balance")


## ----ipw-estimation-----------------------------------------------------------
ipw2est <- PSweight(ps.formula = mX2, yname = "y", data = samp, 
                    weight = "IPW")
ipw2est
summary(ipw2est, type="DIF")  # risk difference
(logRR.ipw2 <- summary(ipw2est, type = "RR"))  # log(risk ratio)
round(exp(logRR.ipw2$estimates[c(1, 4, 5)]), 3) # risk ratio
round(exp(summary(ipw2est, type = "OR")$estimates[c(1, 4, 5)]), 3) # OR


## ----g-formula-att------------------------------------------------------------
EY1att.g <- mean(subset(pop, x == 1)$yp1)
EY0att.g <- mean(subset(pop, x == 1)$yp0)
round(Contr(EY1att.g, EY0att.g), 4)


## ----true among exposed-------------------------------------------------------
EY1att <- mean(subset(pop, x == 1)$EY1.ind)
EY0att <- mean(subset(pop, x == 1)$EY0.ind)
round(Contr(EY1att, EY0att), 4)


## ----ps-estimation-att--------------------------------------------------------
psatt <- PSweight(ps.formula = mX2, yname = "y", 
                  data = samp, weight = "treated")
psatt
round(summary(psatt)$estimates, 4)
round(exp(summary(psatt, type = "RR")$estimates), 3)


## ----aipw---------------------------------------------------------------------
EY1pot.a <- EY1pot.g + mean( 1*(pop$x==1) * pop$w * (pop$y - pop$yp1) )
EY0pot.a <- EY0pot.g + mean( 1*(pop$x==0) * pop$w * (pop$y - pop$yp0) )
round(Contr(EY1pot.a, EY0pot.a), 4)


## ----AIPW by PSweight---------------------------------------------------------
aipw.psw <- PSweight(ps.formula = mX, out.formula = mY, yname = "y",
                     data = samp, weight = "IPW")
aipw.psw
round(summary(aipw.psw)$estimates, 4)
round(exp(summary(aipw.psw, type = "RR")$estimates), 3)


## ----aipw by stdReg2----------------------------------------------------------
dr.std <- standardize_glm_dr(
          formula_outcome = y ~ x + z1 + z2 + z3 + z4, 
          formula_exposure = x ~ z2 + z3 + z4 + z2:z4,
          data = samp,
          family_outcome = "binomial", 
          family_exposure = "binomial",
          values = list(x = 0:1), 
          contrasts = c("difference", "ratio"), reference = 0)
dr.std


## ----clever covariates--------------------------------------------------------
pop$H1 <- pop$x / pop$PS
pop$H0 <- (1 - pop$x) / (1 - pop$PS)


## ----model with clever covariates---------------------------------------------
epsmod <- glm(y ~ -1 + H0 + H1 + offset(qlogis(yh)),
  family = binomial(link = logit), data = pop)
eps <- coef(epsmod)
eps


## ----tmle predictions---------------------------------------------------------
pop$ypred0.H <- plogis(qlogis(pop$yp0) + eps[1] / (1 - pop$PS))
pop$ypred1.H <- plogis(qlogis(pop$yp1) + eps[2] / pop$PS)


## ----tmle-estimates-----------------------------------------------------------
EY0pot.t <- mean(pop$ypred0.H)
EY1pot.t <- mean(pop$ypred1.H)
round(Contr(EY1pot.t, EY0pot.t), 4)

