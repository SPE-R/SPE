### R code from vignette source '/home/runner/work/SPE/SPE/build/causInf2-s.rnw'

###################################################
### code chunk number 1: packages
###################################################
library(Epi)
library(stdReg)
library(PSweight)
library(SuperLearner)
library(tmle) 


###################################################
### code chunk number 2: true models
###################################################
EX <- function( z2, z3, z4) {
           plogis(-5 + 0.05*z2 + 0.25*z3 + 0.5*z4 + 0.4*z2*z4) } 
EY <- function(x, z1, z2, z3, z4) { 
           plogis(-1 + x - 0.1*z1 + 0.35*z2 + 0.25*z3 + 
                 0.20*z4 + 0.15*z2*z4) }


###################################################
### code chunk number 3: data generation function
###################################################
genData <- function(N) {
  z1 <- rbinom(N, size=1, prob=0.5)             # Bern(0.5)
  z2 <- rbinom(N, size=1, prob=0.65)            # Bern(0.65)
  z3 <- trunc(runif(N, min=1, max=5), digits=0) # DiscUnif(1,4)
  z4 <- trunc(runif(N, min=1, max=6), digits=0) # DiscUnif(1,5)
   x <- rbinom(N, size=1, prob=EX(z2, z3, z4) )        
   y <- rbinom(N, size=1, prob=EY(x, z1, z2, z3, z4) )
  data.frame(z1, z2, z3, z4, x, y)
}


###################################################
### code chunk number 4: popdata generation
###################################################
N <- 500000
set.seed(7777)
dd <- genData(N)


###################################################
### code chunk number 5: association
###################################################
Contr <- function(mu1, mu0) { 
   RD <- mu1 - mu0
   RR <- mu1/mu0
   OR <- (mu1/(1-mu1)) /(mu0/(1-mu0))
   return(c(mu1, mu0, RD=RD, RR=RR, OR=OR))
}
Ey1 <- with(dd, sum(y==1 & x==1)/sum(x==1) )
Ey0 <- with(dd, sum(y==1 & x==0)/sum(x==0) )
round(Contr(Ey1, Ey0), 4)


###################################################
### code chunk number 6: true contrasts
###################################################
dd <- transform(dd, EY1.ind = EY(1, z1, z2, z3, z4),
                    EY0.ind = EY(0, z1, z2, z3, z4) )
EY1 <- mean(dd$EY1.ind)
EY0 <- mean(dd$EY0.ind)
round(Contr(EY1, EY0), 4)


###################################################
### code chunk number 7: outcome model
###################################################
mY  <- glm(y ~ x + z1 + z2 + z3 + z4, family = binomial, data = dd)
round(ci.lin(mY, Exp=TRUE)[, c(1,5)], 3)


###################################################
### code chunk number 8: predict
###################################################
dd$yh <- predict(mY, type = "response")
dd$yp1 <- predict(mY, newdata=data.frame( x=rep(1,N), 
          dd[,c("z1","z2","z3","z4")]), type = "response")
dd$yp0 <- predict(mY, newdata=data.frame( x=rep(0,N), 
          dd[,c("z1","z2","z3","z4")]), type = "response")


###################################################
### code chunk number 9: causal contrasts
###################################################
EY1.g <- mean(dd$yp1)
EY0.g <- mean(dd$yp0)
round(Contr(EY1.g, EY0.g), 4)


###################################################
### code chunk number 10: stdReg
###################################################
mY.std <- stdGlm(fit=mY, data=dd, X="x")
summary(mY.std)
round(summary(mY.std, contrast = "difference", reference=0)$est.table, 4)
round(summary(mY.std, contrast = "ratio", reference=0)$est.table, 4)
round(summary(mY.std, transform="odds", 
           contrast = "ratio", reference=0)$est.table, 4)


###################################################
### code chunk number 11: g-formula-att
###################################################
EY1att.g <- mean(subset(dd, x==1)$yp1)
EY0att.g <- mean(subset(dd, x==1)$yp0)
round(Contr(EY1att.g, EY0att.g), 4)


###################################################
### code chunk number 12: true among exposed
###################################################
EY1att <- mean(subset(dd, x==1)$EY1.ind)
EY0att <- mean(subset(dd, x==1)$EY0.ind)
round(Contr(EY1att, EY0att), 4)


###################################################
### code chunk number 13: exposure model
###################################################
mX <- glm(x ~  z1 + z2 + z3 + z4,
     family = binomial(link=logit), data = dd)
round(ci.lin(mX, Exp=TRUE)[, c(1, 5)], 4)


###################################################
### code chunk number 14: propScore
###################################################
dd$PS = predict(mX, type = "response")
summary(dd$PS)
with( subset(dd, x==0), plot(density(PS), lty=2) )
with( subset(dd, x==1), lines(density(PS), lty=1) )


###################################################
### code chunk number 15: weights
###################################################
dd$w <- ifelse(dd$x==1, 1/dd$PS, 1/(1-dd$PS) )
with(dd, tapply(w, x, sum))


###################################################
### code chunk number 16: ipw-estimate
###################################################
EY1.w <- sum( dd$x * dd$w * dd$y ) / sum( dd$x *  dd$w)
EY0.w <- sum( (1-dd$x) * dd$w * dd$y ) / sum( (1-dd$x) * dd$w)
round(Contr(EY1.w, EY0.w), 4)


###################################################
### code chunk number 17: aipw
###################################################
EY1.a <- EY1.g + mean(dd$x *(dd$y - dd$yp1)*dd$w/sum(dd$x*dd$w) )
##  or   EY1.w - mean( ( ( dd$x*dd$w /sum(dd$x*dd$w) ) - 1 )*dd$yp1 ) 
EY0.a <- EY0.g + mean( (1 - dd$x)*(dd$y - dd$yp0)*dd$w/sum((1-dd$x)*dd$w) )
##  or   EY0.w - mean( ( ( (1-dd$x)*dd$w/sum((1-dd$x)*dd$w) ) - 1 )*dd$yp0 ) 
round(Contr(EY1.a, EY0.a), 4)


###################################################
### code chunk number 18: PSweight
###################################################
mX2 <- glm(x ~ (z2 + z3 + z4)^2, family=binomial, data=dd)
round(ci.lin(mX2, Exp=TRUE)[, c(1,5)], 3)
psw <- SumStat(ps.formula=mX2$formula, data=dd, 
      weight=c("IPW", "treated", "overlap"))
dd$PS2 <- psw$propensity[, 2]  # propensity scores extracted
plot(density(dd$PS2[dd$x==0]), lty=2  )
lines(density(dd$PS2[dd$x==1]), lty=1)  


###################################################
### code chunk number 19: check balance
###################################################
plot(psw, type="balance", metric="PSD")


###################################################
### code chunk number 20: ipw-estimation
###################################################
ipwest <- PSweight(ps.formula=mX2, yname="y", data = dd, weight= "IPW")
ipwest
summary(ipwest)
( logRR.ipw <- summary(ipwest, type="RR") )
round( exp(logRR.ipw$estimates[c(1,4,5)]), 3)
round( exp(summary(ipwest, type="OR")$estimates[c(1,4,5)]), 3)


###################################################
### code chunk number 21: ps-estimation-att
###################################################
psatt <- PSweight(ps.formula=mX2, yname="y", data = dd, weight= "treated")
psatt
round( summary(psatt)$estimates[1], 4)
round( exp(summary(psatt,type="RR")$estimates[1]), 3)
round( exp(summary(psatt, type="OR")$estimates[1]), 3)


###################################################
### code chunk number 22: clever covariates
###################################################
dd$H1 <- dd$x / dd$PS2           
dd$H0 <- (1-dd$x) / (1 - dd$PS2) 


###################################################
### code chunk number 23: model with clever covariates
###################################################
epsmod <- glm( y ~ -1 + H0 + H1 + offset(qlogis(yh)), 
   family = binomial(link=logit), data=dd ) 
eps <- coef(epsmod) 
eps


###################################################
### code chunk number 24: tmle estimates
###################################################
yp0.H <- plogis( qlogis(dd$yp0) +  eps[1] / (1 - dd$PS2) )
yp1.H <- plogis( qlogis(dd$yp1) +  eps[2] / dd$PS2 )


###################################################
### code chunk number 25: tmle-estimates
###################################################
EY0.t <- mean(yp0.H)
EY1.t <- mean(yp1.H)
round(Contr(EY1.t, EY0.t), 4)


###################################################
### code chunk number 26: sample
###################################################
set.seed(7622)
n <- 2000
sampind <- sample(N, n)
samp <- dd[sampind, ]


###################################################
### code chunk number 27: algorithms
###################################################
SL.library <- c("SL.glm" , "SL.step", "SL.step.interaction", 
               "SL.glm.interaction","SL.gam",
                "SL.randomForest", "SL.rpart") 


###################################################
### code chunk number 28: tmle SL
###################################################
tmlest <- tmle(Y = samp$y, A = samp$x, W = samp[,c("z1", "z2", "z3", "z4")], 
              family = "binomial", Q.SL.library = SL.library, 
              g.SL.library = SL.library)
summary(tmlest)


