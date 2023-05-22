### R code from vignette source '/home/runner/work/SPE/SPE/build/cont-eff-s.rnw'

###################################################
### code chunk number 1: cont-eff-s.rnw:3-6
###################################################
options( width=90,
         SweaveHooks=list( fig=function()
         par(mar=c(3,3,1,1),mgp=c(3,1,0)/1.6,las=1,bty="n") ) )


###################################################
### code chunk number 2: data-births
###################################################
library(Epi)
data(births)
par(mfrow=c(1,1))
with(births, plot(gestwks, bweight))
mlin <- lm( bweight ~ gestwks, data = births )
abline( mlin )


###################################################
### code chunk number 3: diag-lin
###################################################
par( mfrow=c(2,2) )
plot( mlin )


###################################################
### code chunk number 4: bweight-gestwks-Ns5
###################################################
library(splines)
mNs5 <- lm( bweight ~ Ns( gestwks, knots = c(28,34,38,40,43)), 
            data = births )
round( ci.exp( mNs5, Exp=FALSE ), 1)


###################################################
### code chunk number 5: plotFitPredInt
###################################################
plotFitPredInt <- function( xval, fit, pred, ...)
{
    matshade( xval, fit,  lwd=2, alpha=0.2)
    matshade( xval, pred, lwd=2, alpha=0.2)
    matlines( xval, fit,  lty=1, lwd=c(3,2,2), col=c("red","blue","blue") )
    matlines( xval, pred, lty=1, lwd=c(3,2,2), col=c("red","green","green") )
}


###################################################
### code chunk number 6: Ns5-pred
###################################################
nd <- data.frame(gestwks = seq(24, 45, by = 0.25) ) 
fit.Ns5 <- predict( mNs5, newdata=nd, interval="conf" )
pred.Ns5 <- predict( mNs5, newdata=nd, interval="pred" )
par(mfrow=c(1,1))
with( births, plot(bweight ~ gestwks, xlim=c(23, 46), 
                   cex.axis=1.5, cex.lab=1.5 ) )
plotFitPredInt(xval=nd$gestwks, fit=fit.Ns5, pred=pred.Ns5)


###################################################
### code chunk number 7: cubic-diag
###################################################
par(mfrow=c(2,2))
plot(mNs5)


###################################################
### code chunk number 8: bweigth-gestwks-Ns10
###################################################
mNs10 <- lm( bweight ~ Ns( gestwks, 
        knots = seq(25, 43, by = 2)), data = births)
round(ci.lin(mNs10)[ , c(1,5,6)], 1)
fit.Ns10 <- predict( mNs10, newdata=nd, interval="conf" )
pred.Ns10 <- predict( mNs10, newdata=nd, interval="pred" )
par(mfrow=c(1,1))
with( births, plot( bweight ~ gestwks, xlim = c(23, 46), 
                    cex.axis= 1.5, cex.lab = 1.5 )  )
plotFitPredInt( nd$gestwks, fit.Ns10, pred.Ns10)


###################################################
### code chunk number 9: bweight-gestwks-mPs
###################################################
library(mgcv)
mPs <- gam( bweight ~ s(gestwks), data = births)		
summary(mPs)	


###################################################
### code chunk number 10: mPs-sig2
###################################################
mPs$sig2
sqrt(mPs$sig2)


###################################################
### code chunk number 11: bweight-gestwks-mPs-plot
###################################################
pr.Ps <- predict( mPs, newdata=nd, se.fit=TRUE )
str(pr.Ps) # with se.fit=TRUE, only two columns: fitted value and its SE
fit.Ps <- cbind(pr.Ps$fit, 
                pr.Ps$fit - 2*pr.Ps$se.fit, 
                pr.Ps$fit + 2*pr.Ps$se.fit)
pred.Ps <- cbind(pr.Ps$fit,  # must add residual variance to se.fit^2
                 pr.Ps$fit - 2*sqrt( pr.Ps$se.fit^2 + mPs$sig2), 
                 pr.Ps$fit + 2*sqrt( pr.Ps$se.fit^2 + mPs$sig2))
par(mfrow=c(1,1))
with(births, plot(bweight ~ gestwks, xlim=c(24, 45), 
                  cex.axis=1.5, cex.lab=1.5) )
plotFitPredInt(nd$gestwks, fit.Ps, pred.Ps)


###################################################
### code chunk number 12: data-input
###################################################
 library( Epi )
   data( testisDK )
    str( testisDK )
summary( testisDK )
   head( testisDK )


###################################################
### code chunk number 13: housekeeping
###################################################
tdk <- subset(testisDK, A > 14 & A < 80)
tdk$Age <- cut(tdk$A, br = 5*(3:16), include.lowest=TRUE, right=FALSE)
   nAge <- length(levels(tdk$Age))
tdk$Per <- cut(tdk$P, br = seq(1943,1998,by=5), 
               include.lowest=TRUE, right=FALSE)
   nPer <- length(levels(tdk$Per))


###################################################
### code chunk number 14: tabulation
###################################################
tab <- stat.table(  index = list(Age, Per),
                 contents = list(D = sum(D), 
                                 Y = sum(Y/1000),
                              rate = ratio(D, Y, 10^5) ),
                  margins = TRUE, 
                     data = tdk ) 
print(tab, digits=c(sum=0, ratio=1))	


###################################################
### code chunk number 15: plot-rates
###################################################
str(tab)
par(mfrow=c(1,1))
rateplot( rates=tab[3, 1:nAge, 1:nPer], which="ap", ylim=c(1,30), 
           age=seq(15, 75, 5), per=seq(1943, 1993, 5), 
           col=heat.colors(16), ann=TRUE )


###################################################
### code chunk number 16: mCat
###################################################
tdk$Y <- tdk$Y/100000
mCat <- glm( cbind(D,Y) ~ Age + Per, 
             family=poisreg(link=log), data= tdk )
round( ci.exp( mCat ), 2)


###################################################
### code chunk number 17: mCat-est
###################################################
aMid <- seq(17.5, 77.5, by = 5)
pMid <- seq(1945, 1995, by = 5)
par(mfrow=c(1,2))
plot( c(15,80), c(0.6, 6), type="n", log="y", 
      cex.lab = 1.5, cex.axis = 1.5, 
   xlab = "Age (years)", ylab = "Rate ratio") 
lines( aMid,  c( 1, ci.exp(mCat)[2:13, 1] ), type = "o", pch = 16 )
segments( aMid[-1],  ci.exp(mCat)[2:13, 2], 
          aMid[-1], ci.exp(mCat)[2:13, 3] ) 
plot( c(1943,1998), c(0.6, 6), type="n", log="y", 
      cex.lab = 1.5, cex.axis = 1.5, 
   xlab = "Calendar year - 1900", ylab = "Rate ratio") 
lines( pMid,c( 1, ci.exp(mCat)[14:23, 1] ), type = 'o', pch = 16 )
segments( pMid[-1],  ci.exp(mCat)[14:23, 2], 
          pMid[-1],  ci.exp(mCat)[14:23, 3] ) 


###################################################
### code chunk number 18: mCat2-new-ref
###################################################
tdk$Per70 <- Relevel(tdk$Per, ref = 6)
mCat2 <- glm( cbind(D,Y) ~ -1 + Age +Per70, 
              family=poisreg(link=log), data= tdk )
round( ci.exp( mCat2 ), 2)


###################################################
### code chunk number 19: mCat2-plot
###################################################
par(mfrow=c(1,2))
plot( c(15,80), c(2, 20), type="n", log="y", cex.lab = 1.5, cex.axis = 1.5, 
   xlab = "Age (years)", ylab = "Incidence rate (per 100000 y)") 
lines( aMid,  c(ci.exp(mCat2)[1:13, 1] ), type = "o", pch = 16) 
plot( c(1943,1998), c(0.4, 2), type="n", log="y", 
      cex.lab = 1.5, cex.axis = 1.5, 
   xlab = "Calendar year", ylab = "Rate ratio") 
lines( pMid, c(ci.exp(mCat2)[14:18, 1], 1, ci.exp(mCat2)[19:23, 1]),  
   type = "o", pch = 16 )
abline(h=1, col="gray")


###################################################
### code chunk number 20: mPen
###################################################
library(mgcv)
mPen <- gam( cbind(D, Y) ~ s(A) + s(P),  
           family = poisreg(link=log), data = tdk)
summary(mPen)					


###################################################
### code chunk number 21: mPen-plot
###################################################
par(mfrow=c(1,2))
plot(mPen, seWithMean=TRUE)


###################################################
### code chunk number 22: mPen-check
###################################################
par(mfrow=c(2,2))
gam.check(mPen)					


###################################################
### code chunk number 23: mPen2
###################################################
mPen2 <- gam( cbind(D,Y) ~ s(A, k=20) + s(P),  
           family = poisreg(link=log), data = tdk)
summary(mPen2)
par(mfrow=c(2,2))
gam.check(mPen2)					


###################################################
### code chunk number 24: mPen2-plot
###################################################
par( mfrow=c(1,2) )
plot( mPen2, seWithMean=TRUE )
abline( v=1968, h=0, lty=3 )


###################################################
### code chunk number 25: mPen2-newplot
###################################################
par( mfrow=c(1,2) )
icpt <- coef(mPen2)[1]  #  estimated intecept
plot( mPen2, seWithMean=TRUE, select=1, rug=FALSE,       
      yaxt="n", ylim= c(log(1),log(20)) - icpt, 
      xlab="Age (y)", ylab="Mean rate (/100000 y)" )
axis(2, at = log( c(1, 2, 5, 10, 20)) - icpt, labels=c(1, 2, 5, 10, 20) )
plot( mPen2, seWithMean=TRUE, select=2, rug=FALSE, 
      yaxt="n", ylim=c( log(0.4), log(2) ), 
      xlab="Calendat year", ylab="Relative rate")
axis(2, at=log( c(0.5, 0.75, 1, 1.5, 2)), labels = c(0.5, 0.75, 1, 1.5, 2))
abline( v=1968, h=0, lty=3 )


###################################################
### code chunk number 26: mNs
###################################################
mNs <- glm( cbind(D,Y) ~ Ns(A, knots = seq(15, 75, 10)) +
                Ns(P, knots = seq(1950, 1990, 10)),
                 family=poisreg, data=tdk )
summary( mNs)


###################################################
### code chunk number 27: cont-eff-s.rnw:491-507
###################################################
summary( mNs )
aa <- 15:79
pp <- 1943:1996
# for the prediction
ndp <- data.frame( A=aa, P=1970, Y=1 )
# for the RR between pp and 1970
ndx <- data.frame( A=50, P=pp  , Y=1 )
ndr <- data.frame( A=50, P=1970, Y=1 )
par(mfrow=c(1,2))
matplot( aa, ci.pred( mNs, ndp ),
          log="y", xlab="Age", ylab="Incidence rate (per 100000 y)",
          type="l", lty=1, lwd=c(3,1,1), col = c("red", "blue",  "blue") )
matplot( pp, ci.exp( mNs, list(ndx,ndr) ),
          log="y", xlab="Year", ylab="Rate ratio",
          type="l", lty=1, lwd=c(3,1,1), col= c("red", "blue",  "blue") )
abline( h=1,v=1970)


###################################################
### code chunk number 28: gamNs
###################################################
par(mfrow=c(1,2))
matplot( ndp$A, ci.pred( mNs, ndp ),
          log="y", xlab="Age", ylab="Incidence rate (per 100000 y)",
          type="l", lty=1, lwd=c(3,1,1), col = c("red", "blue",  "blue") )
matshade( ndp$A, ci.pred( mPen2, ndp ), lwd=2, lty=3 )
matplot( ndx$P, ci.exp( mNs, list(ndx,ndr) ),
          log="y", xlab="Year", ylab="Rate ratio",
          type="l", lty=1, lwd=c(3,1,1), col= c("red", "blue",  "blue") )
matshade( ndx$P, ci.exp( mPen2, list(ndx,ndr) ), lwd=2, lty=3 )
abline( h=1,v=1970)


###################################################
### code chunk number 29: all items
###################################################
 a.kn <- seq(15,75,10)
 p.kn <- seq(50,90,10)
 a.pt <- 15:75
 p.pt <- 45:95
 p.ref <- 70
 na <- length(a.pt)
 np <- length(p.pt)
 As <- Ns( a.pt, knots=a.kn )
 Ps <- Ns( p.pt, knots=p.kn )
 Prp <- Ns( rep(p.ref,np), knots=p.kn )
 Pra <- Ns( rep(p.ref,na), knots=p.kn )
 mAP <- glm( D ~ Ns(A,knots=a.kn) + Ns(P,knots=p.kn),
                 offset=log(Y), family=poisson, data= tdk )
 par( mfrow=c(1,2) )
 matplot( a.pt, ci.exp( mAP, ctr.mat=cbind(1,As,Pra) )*10^5,
          log="y", xlab="Age",
          ylab=paste( "Incidence (/100,000 y) in", p.ref ),
          type="l", lty=1, lwd=c(3,1,1), col="black",
          ylim=c(1,20) )
 matplot( p.pt, ci.exp( mAP, ctr.mat=Ps-Prp, subset="P" ),
          log="y", xlab="Age", ylab="Rate ratio",
          type="l", lty=1, lwd=c(3,1,1), col="black",
          ylim=c(1,20)/4 )
 abline( h=1, v=p.ref )


###################################################
### code chunk number 30: Age-cohort
###################################################
 tdk <- transform( tdk, B = P-A )
 # with( testisDK, hist( rep(B,D), breaks=100, col="black" ) )
 a.kn <- seq(15,75,5)
 b.kn <- seq(00,70,5)
 a.pt <- 10:75
 b.pt <- (-10):70
 b.ref <- 40
 na <- length(a.pt)
 nb <- length(b.pt)
 As <- Ns( a.pt, knots=a.kn )
 Bs <- Ns( b.pt, knots=b.kn )
 Brb <- Ns( rep(b.ref,nb), knots=b.kn )
 Bra <- Ns( rep(b.ref,na), knots=b.kn )
 mAB <- glm( D ~ Ns(A,knots=a.kn) + Ns(B,knots=b.kn),
                 offset=log(Y), family=poisson, data= tdk )
 par( mfrow=c(1,2) )
 matplot( a.pt, ci.exp( mAB, ctr.mat=cbind(1,As,Bra) )*10^5,
          log="y", xlab="Age",
          ylab=paste( "Incidence per 100,000 y, in", b.ref, "birth cohort"),
          type="l", lty=1, lwd=c(3,1,1), col= c("red", "blue",  "blue") ,
          ylim=c(1,20) )
 matplot( b.pt, ci.exp( mAB, ctr.mat=Bs-Brb, subset="B" ),
          log="y", xlab="Age", ylab="Rate ratio",
          type="l", lty=1, lwd=c(3,1,1),  col= c("red", "blue", "blue") ,
          ylim=c(1,20)/4 )
 abline( h=1, v=b.ref )


