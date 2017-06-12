### R code from vignette source 'cont-eff-s.rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: bweight by gestwks, linear model fitted
###################################################
library(Epi)
data(births)
par(mfrow=c(1,1))
with(births, plot(gestwks, bweight))
mlin <- lm(bweight ~ gestwks, data = births )
abline(mlin)


###################################################
### code chunk number 2: diagnostics of the linear model
###################################################
par(mfrow=c(2,2))
plot(mlin)


###################################################
### code chunk number 3: bweight-gestwks, natural splines with 5 knots
###################################################
library(splines)
mNs5 <- lm( bweight ~ Ns( gestwks, 
        knots = c(28,34,38,40,43)), data = births)
round(ci.lin(mNs5)[ , c(1,5,6)], 1)


###################################################
### code chunk number 4: Natural splines with 5 knots: predictions
###################################################
nd <- data.frame(gestwks = seq(24, 45, by = 0.25) ) 
fit.Ns5 <- predict( mNs5, newdata=nd, interval="conf" )
pred.Ns5 <- predict( mNs5, newdata=nd, interval="pred" )
par(mfrow=c(1,1))
with(births, plot(bweight ~ gestwks, xlim=c(23, 46),cex.axis= 1.5,cex.lab = 1.5 ) )
matlines( nd$gestwks, fit.Ns5, lty=1, lwd=c(3,2,2), col=c('red','blue','blue') )
matlines( nd$gestwks, pred.Ns5, lty=1, lwd=c(3,2,2), col=c('red','green','green') )


###################################################
### code chunk number 5: Diagnostics of the 5 knots natural spline model
###################################################
par(mfrow=c(2,2))
plot(mNs5)


###################################################
### code chunk number 6: bweigth-gestwks: 10 knots splines, predictions
###################################################
mNs10 <- lm( bweight ~ Ns( gestwks, 
        knots = seq(25, 43, by = 2)), data = births)
round(ci.lin(mNs10)[ , c(1,5,6)], 1)
fit.Ns10 <- predict( mNs10, newdata=nd, interval="conf" )
pred.Ns10 <- predict( mNs10, newdata=nd, interval="pred" )
par(mfrow=c(1,1))
with( births, plot( bweight ~ gestwks, xlim = c(23, 46), cex.axis= 1.5, cex.lab = 1.5 )  )
matlines( nd$gestwks, fit.Ns10, lty=1, lwd=c(3,2,2), col=c('red','blue','blue') )
matlines( nd$gestwks, pred.Ns10, lty=1, lwd=c(3,2,2), col=c('red','green','green') )


###################################################
### code chunk number 7: bweight-gestwks: penalized splines model
###################################################
library(mgcv)
mPs <- gam( bweight ~ s(gestwks), data = births)		
summary(mPs)	


###################################################
### code chunk number 8: residual SD of penalized splines model
###################################################
mPs$sig2
sqrt(mPs$sig2)


###################################################
### code chunk number 9: bweight-gestwks: Plotting the fitted
###                      penalized spline with error margins
###################################################
pr.Ps <- predict( mPs, newdata=nd, se.fit=T)
par(mfrow=c(1,1))
with(births, plot(bweight ~ gestwks, xlim=c(24, 45), cex.axis=1.5, cex.lab=1.5) )
matlines( nd$gestwks, cbind(pr.Ps$fit, 
  pr.Ps$fit - 2*pr.Ps$se.fit, pr.Ps$fit + 2*pr.Ps$se.fit),  
  lty=1, lwd=c(3,2,2), col=c('red','blue','blue') )
matlines( nd$gestwks, cbind(pr.Ps$fit, 
  pr.Ps$fit - 2*sqrt( pr.Ps$se.fit^2 + mPs$sig2), 
  pr.Ps$fit + 2*sqrt( pr.Ps$se.fit^2 + mPs$sig2)),  
  lty=1, lwd=c(3,2,2), col=c('red','green','green')  )


###################################################
### code chunk number 10: Input of testis cancer data
###################################################
 library( Epi )
 data( testisDK )
 str( testisDK )
 summary( testisDK )
 head( testisDK )


###################################################
### code chunk number 11: Creating 5 y x 5 y grouping of age and period
###################################################
tdk <- subset(testisDK, A > 14 & A < 80)
tdk$Age <- cut(tdk$A, br = 5*(3:16), include.lowest=T, right=F)
nAge <- length(levels(tdk$Age))
tdk$P <- tdk$P - 1900
tdk$Per <- cut(tdk$P, br = seq(43, 98, by = 5),   
     include.lowest=T, right=F)
nPer <- length(levels(tdk$Per))


###################################################
### code chunk number 12: Tabulation of incidence by age and period
###################################################
tab <- stat.table(  index = list(Age, Per),
                 contents = list(D = sum(D), Y = sum(Y/1000),
                              rate = ratio(D, Y, 10^5) ),
     margins = TRUE, data = tdk )										
print(tab, digits=c(sum=0, ratio=1))	


###################################################
### code chunk number 13: Plotting the rates by age and period
###################################################
str(tab)
par(mfrow=c(1,1))
plot( c(15,80), c(1,30), type='n', log='y', cex.lab = 1.5, cex.axis = 1.5, 
   xlab = "Age (years)", ylab = "Incidence rate (per 100000 y)") 
for (p in 1:nPer)
   lines( seq(17.5, 77.5, by = 5), tab[3, 1:nAge, p], type = 'o', pch = 16 ,
	   lty = rep(1:6, 2)[p] )


###################################################
### code chunk number 14: Model with categorical age and period
###                       with default reference class (1st one)
###################################################
mCat <- glm( D ~ Age + Per, offset=log(Y/100000), family=poisson, data= tdk )
round( ci.exp( mCat ), 2)


###################################################
### code chunk number 15: Plotting the estimated rate ratios
###                       from the categorical model
###################################################
aMid <- seq(17.5, 77.5, by = 5)
pMid <- seq(45, 95, by = 5)
par(mfrow=c(1,2))
plot( c(15,80), c(0.6, 6), type='n', log='y', cex.lab = 1.5, cex.axis = 1.5, 
   xlab = "Age (years)", ylab = "Rate ratio") 
lines( aMid,  c( 1, ci.exp(mCat)[2:13, 1] ), type = 'o', pch = 16 )
segments( aMid[-1],  ci.exp(mCat)[2:13, 2], aMid[-1], ci.exp(mCat)[2:13, 3] ) 
plot( c(43, 98), c(0.6, 6), type='n', log='y', cex.lab = 1.5, cex.axis = 1.5, 
   xlab = "Calendar year - 1900", ylab = "Rate ratio") 
lines( pMid,  c( 1, ci.exp(mCat)[14:23, 1] ), type = 'o', pch = 16 )
segments( pMid[-1],  ci.exp(mCat)[14:23, 2], pMid[-1], ci.exp(mCat)[14:23, 3] ) 


###################################################
### code chunk number 16: Categorical model with intercept merged
###                       with age and a new reference to period
###################################################
tdk$Per70 <- Relevel(tdk$Per, ref = 6)
mCat2 <- glm( D ~ -1 + Age +Per70, offset=log(Y/100000), family=poisson, data= tdk )
round( ci.exp( mCat2 ), 2)


###################################################
### code chunk number 17: Plotting the estimated rate ratios
###                       from the second categorical model
###################################################
par(mfrow=c(1,2))
plot( c(15,80), c(2, 20), type='n', log='y', cex.lab = 1.5, cex.axis = 1.5, 
   xlab = "Age (years)", ylab = "Incidence rate (per 100000 y)") 
lines( aMid,  c(ci.exp(mCat2)[1:13, 1] ), type = 'o', pch = 16 )
plot( c(43, 98), c(0.4, 2), type='n', log='y', cex.lab = 1.5, cex.axis = 1.5, 
   xlab = "Calendar year - 1900", ylab = "Rate ratio") 
lines( pMid, c(ci.exp(mCat2)[14:18, 1], 1, ci.exp(mCat2)[19:23, 1]),  
   type = 'o', pch = 16 )


###################################################
### code chunk number 18: Penalized splines for age and period
###                       with default number of knots
###################################################
library(mgcv)
mPen <- gam( D ~ s(A) + s(P), offset = log(Y/100000), 
           family = poisson, data = tdk)
summary(mPen)					


###################################################
### code chunk number 19: Plotting the results 
###################################################
par(mfrow=c(1,2))
plot(mPen, seWithMean=T)
abline(v = 68, lty=3)
abline(h = 0, lty=3)


###################################################
### code chunk number 20: Checking the penalized spline model
###################################################
gam.check(mPen)					


###################################################
### code chunk number 21: Penalized splines for age and period
###                       with increased number of knots for age
###################################################
mPen2 <- gam( D ~ s(A, k=20) + s(P), offset = log(Y/100000), 
           family = poisson, data = tdk)
summary(mPen2)
gam.check(mPen2)					


###################################################
### code chunk number 22: Plotting the effects by the 
###                       plot.gam method
###################################################
par(mfrow=c(1,2))
plot(mPen2, seWithMean=T)
abline(v = 68, lty=3)
abline(h = 0, lty=3)


###################################################
### code chunk number 23: Plotting the effects by a 
###                       specially tailored script 
###################################################
source("http://www.bendixcarstensen.com/SPE/data/plotPenSplines.R")

