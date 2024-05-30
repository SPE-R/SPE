## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(results = "markup", fig.show="hide", messages=FALSE, keep.source = TRUE, include = TRUE, eps = FALSE, prefix.string = "./graph/causInf2")


## ----dagitty, echo=TRUE, message=FALSE, warning=FALSE, results=TRUE, fig.show=TRUE----
library(dagitty)
d <-
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

dagitty::coordinates(d) <-
  list(
    x = c(X = 1, Y = 5, Z1 = 5, Z2 = 1, Z3 = 4, Z4 = 2),
    y = c(X = 2, Y = 2, Z1 = 0, Z2 = 0, Z3 = 1, Z4 = 1)
  )

plot(d)


## ----packages 2, message=FALSE------------------------------------------------
library(Epi)
library(stdReg)
library(PSweight)


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
N <- 500000
set.seed(7777)
dd <- genData(N)


## ----Contr function and associational contrasts-------------------------------
Contr <- function(mu1, mu0) {
  RD <- mu1 - mu0
  RR <- mu1 / mu0
  OR <- (mu1 / (1 - mu1)) / (mu0 / (1 - mu0))
  return(c(mu1, mu0, RD = RD, RR = RR, OR = OR))
}
Ey1fact <- with(dd, sum(y == 1 & x == 1) / sum(x == 1))
Ey0fact <- with(dd, sum(y == 1 & x == 0) / sum(x == 0))
round(Contr(Ey1fact, Ey0fact), 4)


## ----true contrasts-----------------------------------------------------------
dd <- transform(dd,
  EY1.ind = EY(x = 1, z1, z2, z3, z4),
  EY0.ind = EY(x = 0, z1, z2, z3, z4)
)
EY1pot <- mean(dd$EY1.ind)
EY0pot <- mean(dd$EY0.ind)
round(Contr(EY1pot, EY0pot), 4)


## ----outcome model------------------------------------------------------------
mY <- glm(y ~ x + z1 + z2 + z3 + z4, family = binomial, data = dd)
round(ci.lin(mY, Exp = TRUE)[, c(1, 5)], 3)


## ----fitted risks and predicted potential risks-------------------------------
dd$yh <- predict(mY, type = "response") #  fitted values
dd$yp1 <- predict(mY, newdata = data.frame(
  x = rep(1, N), # x=1
  dd[, c("z1", "z2", "z3", "z4")]
), type = "response")
dd$yp0 <- predict(mY, newdata = data.frame(
  x = rep(0, N), # x=0
  dd[, c("z1", "z2", "z3", "z4")]
), type = "response")


## ----causal contrasts---------------------------------------------------------
EY1pot.g <- mean(dd$yp1)
EY0pot.g <- mean(dd$yp0)
round(Contr(EY1pot.g, EY0pot.g), 4)


## ----stdReg-------------------------------------------------------------------
mY.std <- stdGlm(fit = mY, data = dd, X = "x")
summary(mY.std)
round(summary(mY.std, contrast = "difference", reference = 0)$est.table, 4)
round(summary(mY.std, contrast = "ratio", reference = 0)$est.table, 4)
round(summary(mY.std,
  transform = "odds",
  contrast = "ratio", reference = 0
)$est.table, 4)


## ----exposure model-----------------------------------------------------------
mX <- glm(x ~ z1 + z2 + z3 + z4,
  family = binomial(link = logit), data = dd
)
round(ci.lin(mX, Exp = TRUE)[, c(1, 5)], 4)


## ----propScore----------------------------------------------------------------
dd$PS <- predict(mX, type = "response")
summary(dd$PS)
with(subset(dd, x == 0), plot(density(PS), lty = 2))
with(subset(dd, x == 1), lines(density(PS), lty = 1))


## ----weights------------------------------------------------------------------
dd$w <- ifelse(dd$x == 1, 1 / dd$PS, 1 / (1 - dd$PS))
with(dd, tapply(w, x, sum))


## ----ipw-estimate-------------------------------------------------------------
EY1pot.w <- sum(dd$x * dd$w * dd$y) / sum(dd$x * dd$w)
EY0pot.w <- sum((1 - dd$x) * dd$w * dd$y) / sum((1 - dd$x) * dd$w)
round(Contr(EY1pot.w, EY0pot.w), 4)


## ----PSweight, fig=FALSE------------------------------------------------------
mX2 <- glm(x ~ (z2 + z3 + z4)^2, family = binomial, data = dd)
round(ci.lin(mX2, Exp = TRUE)[, c(1, 5)], 3)
psw2 <- SumStat(
  ps.formula = mX2$formula, data = dd,
  weight = c("IPW", "treated", "overlap")
)
dd$PS2 <- psw2$propensity[, 2] 
dd$w2 <- ifelse(dd$x == 1, 1 / dd$PS2, 1 / (1 - dd$PS2)) 
plot(density(dd$PS2[dd$x == 0]), lty = 2)
lines(density(dd$PS2[dd$x == 1]), lty = 1)


## ----check balance, fig=FALSE-------------------------------------------------
plot(psw2, type = "balance", metric = "PSD")


## ----ipw-estimation-----------------------------------------------------------
ipw2est <- PSweight(ps.formula = mX2, yname = "y", data = dd, weight = "IPW")
ipw2est
summary(ipw2est)
(logRR.ipw2 <- summary(ipw2est, type = "RR"))
round(exp(logRR.ipw2$estimates[c(1, 4, 5)]), 3)
round(exp(summary(ipw2est, type = "OR")$estimates[c(1, 4, 5)]), 3)


## ----g-formula-att------------------------------------------------------------
EY1att.g <- mean(subset(dd, x == 1)$yp1)
EY0att.g <- mean(subset(dd, x == 1)$yp0)
round(Contr(EY1att.g, EY0att.g), 4)


## ----true among exposed-------------------------------------------------------
EY1att <- mean(subset(dd, x == 1)$EY1.ind)
EY0att <- mean(subset(dd, x == 1)$EY0.ind)
round(Contr(EY1att, EY0att), 4)


## ----ps-estimation-att--------------------------------------------------------
psatt <- PSweight(ps.formula = mX2, yname = "y", data = dd, weight = "treated")
psatt
round(summary(psatt)$estimates[1], 4)
round(exp(summary(psatt, type = "RR")$estimates[1]), 3)
round(exp(summary(psatt, type = "OR")$estimates[1]), 3)


## ----aipw1--------------------------------------------------------------------
EY1pot.a <- EY1pot.g + mean( 1*(dd$x==1) * dd$w * (dd$y - dd$yp1) )
EY0pot.a <- EY0pot.g + mean( 1*(dd$x==0) * dd$w * (dd$y - dd$yp0) )
round(Contr(EY1pot.a, EY0pot.a), 4)


## ----aipw2--------------------------------------------------------------------
EY1pot.w2 <- ipw2est$muhat[2]
EY0pot.w2 <- ipw2est$muhat[1]
EY1pot.a2 <- EY1pot.w2 + mean( (1 - 1*(dd$x==1) * dd$w2) * dd$yp1 )
EY0pot.a2 <- EY0pot.w2 + mean( (1 - 1*(dd$x==0) * dd$w2) * dd$yp0 )
round(Contr(EY1pot.a2, EY0pot.a2), 4)


## ----clever covariates--------------------------------------------------------
dd$H1 <- dd$x / dd$PS2
dd$H0 <- (1 - dd$x) / (1 - dd$PS2)


## ----model with clever covariates---------------------------------------------
epsmod <- glm(y ~ -1 + H0 + H1 + offset(qlogis(yh)),
  family = binomial(link = logit), data = dd
)
eps <- coef(epsmod)
eps


## ----tmle predictions---------------------------------------------------------
ypred0.H <- plogis(qlogis(dd$yp0) + eps[1] / (1 - dd$PS2))
ypred1.H <- plogis(qlogis(dd$yp1) + eps[2] / dd$PS2)


## ----tmle-estimates-----------------------------------------------------------
EY0pot.t <- mean(ypred0.H)
EY1pot.t <- mean(ypred1.H)
round(Contr(EY1pot.t, EY0pot.t), 4)

