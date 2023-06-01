### R code from vignette source '/home/runner/work/SPE/SPE/build/cont-eff-s.rnw'

###################################################
### code chunk number 1: cont-eff-s.rnw:3-6
###################################################
options( width=90,
         SweaveHooks=list( fig=function()
         par(mar=c(3,3,1,1),mgp=c(3,1,0)/1.6,las=1,bty="n") ) )


###################################################
### code chunk number 2: data-input
###################################################
library( Epi )
library(mgcv)
   data( testisDK )
    str( testisDK )
summary( testisDK )
   head( testisDK )


###################################################
### code chunk number 3: housekeeping
###################################################
tdk <- subset(testisDK, A > 14 & A < 80)
tdk$Age <- cut(tdk$A, br = 5*(3:16), include.lowest=TRUE, right=FALSE)
   nAge <- length(levels(tdk$Age))
tdk$Per <- cut(tdk$P, br = seq(1943,1998,by=5), 
               include.lowest=TRUE, right=FALSE)
   nPer <- length(levels(tdk$Per))


###################################################
### code chunk number 4: tabulation
###################################################
tab <- stat.table(  index = list(Age, Per),
                 contents = list(D = sum(D), 
                                 Y = sum(Y/1000),
                              rate = ratio(D, Y, 10^5) ),
                  margins = TRUE, 
                     data = tdk ) 
print(tab, digits=c(sum=0, ratio=1))	


###################################################
### code chunk number 5: plot-rates
###################################################
str(tab)
par(mfrow=c(1,1))
rateplot( rates=tab[3, 1:nAge, 1:nPer], which="ap", ylim=c(1,30), 
           age=seq(15, 75, 5), per=seq(1943, 1993, 5), 
           col=heat.colors(16), ann=TRUE )


###################################################
### code chunk number 6: mCat
###################################################
tdk$Y <- tdk$Y/100000
mCat <- glm( cbind(D,Y) ~ Age + Per, 
             family=poisreg(link=log), data= tdk )
round( ci.exp( mCat ), 2)


###################################################
### code chunk number 7: mCat-est
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
### code chunk number 8: mCat2-new-ref
###################################################
tdk$Per70 <- Relevel(tdk$Per, ref = 6)
mCat2 <- glm( cbind(D,Y) ~ -1 + Age +Per70, 
              family=poisreg(link=log), data= tdk )
round( ci.exp( mCat2 ), 2)


###################################################
### code chunk number 9: mCat2-plot
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
### code chunk number 10: mPen
###################################################
library(mgcv)
mPen <- gam( cbind(D, Y) ~ s(A) + s(P),  
           family = poisreg(link=log), data = tdk)
summary(mPen)					


###################################################
### code chunk number 11: mPen-plot
###################################################
par(mfrow=c(1,2))
plot(mPen, seWithMean=TRUE)


###################################################
### code chunk number 12: mPen-check
###################################################
par(mfrow=c(2,2))
gam.check(mPen)					


###################################################
### code chunk number 13: mPen2
###################################################
mPen2 <- gam( cbind(D,Y) ~ s(A, k=20) + s(P),  
           family = poisreg(link=log), data = tdk)
summary(mPen2)
par(mfrow=c(2,2))
gam.check(mPen2)					


###################################################
### code chunk number 14: mPen2-plot
###################################################
par( mfrow=c(1,2) )
plot( mPen2, seWithMean=TRUE )
abline( v=1968, h=0, lty=3 )


###################################################
### code chunk number 15: mPen2-newplot
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


