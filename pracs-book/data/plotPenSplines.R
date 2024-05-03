##  Source script that plots the fitted age+plus intercept
##  curve on the original rate scale as well as the
##  estimated curve for the period effect on the rate ratio scale

par(mfrow=c(1,2))
#   Age + intercept
X.A <- model.matrix(mPen2)[ 1:65, 1:20 ]
covA <- X.A %*% mPen2$Vp[1:20, 1:20] %*% t(X.A) 
seA <- sqrt( diag( covA) )
aa <- seq(15, 79, by = 1)
p68 <- rep(1968, length(aa))
fitA.AP <- predict(mPen2, 
        newdata=data.frame(A = aa, P = p68) )
matplot(aa,exp( cbind(fitA.AP, fitA.AP - 1.96*seA, fitA.AP + 1.96*seA)), 
     type="l", lty=1, log= "y", xlab= "Age (y)", cex.lab = 1.5, cex.axis=1.5,
     ylab="Fitted average rate (/100,000 y)", ylim = c(1,30),
      lwd=c(3,1.5,1.5), col=c('red','blue','blue') )
abline( h = 5, col = "gray")
#   Period effect about the intercept
X.P <- cbind( model.matrix(mPen2)[ seq(1, dim(tdk)[1], by = 65), 1], 
   matrix(0, nrow=54, ncol=19, byrow=T),
   model.matrix(mPen2)[ seq(1, dim(tdk)[1], by = 65), 21:29] )
covP <- X.P %*% mPen2$Vp %*% t(X.P)
seP <- sqrt(diag(covP))   
#
pp <- 1943:1996
mP.AP <- mPen2
mP.AP$coefficients[1:20] <- 0  # $
fitP.AP <- predict(mP.AP, 
    newdata = data.frame(A = rep(47, length(pp)), P = pp) )
matplot(pp, exp( cbind(fitP.AP, fitP.AP - 1.96*seP, fitP.AP + 1.96*seP) ) ,  
	ylim = c(0.4, 1.8),  
  type="l", lty=1, log= "y", xlab= "Year", cex.lab = 1.5, cex.axis=1.5,
  ylab="Rate ratio",  
  lwd=c(3,1.5,1.5), col=c('red','blue','blue') )
abline( h = 1, col = "gray")
abline( v = 1968, col = 'gray')