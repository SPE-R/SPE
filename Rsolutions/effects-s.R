### R code from vignette source '/home/runner/work/SPE/SPE/build/effects-s.rnw'

###################################################
### code chunk number 1: Run births-house
###################################################
library(Epi)
library(mgcv)
data(births)
str(births)


###################################################
### code chunk number 2: effects-s.rnw:92-97
###################################################
births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
births$sex <- factor(births$sex, labels = c("M", "F"))
births$maged <- cut(births$matage, breaks=c(22,35,44), right=FALSE)
births$gest4 <- cut(births$gestwks, 
    breaks = c(20, 35, 37, 39, 45), right = FALSE)


###################################################
### code chunk number 3: summary
###################################################
summary(births)
with(births, sd(bweight) )


###################################################
### code chunk number 4: t test for sex on bweight
###################################################
with( births, t.test(bweight ~ sex, var.equal=TRUE) )


###################################################
### code chunk number 5: Effects of sex on bweight
###################################################
effx(response=bweight, type="metric", exposure=sex, data=births)


###################################################
### code chunk number 6: Table of mean birth weight by sex
###################################################
stat.table(sex, mean(bweight), data=births)


###################################################
### code chunk number 7: lm of bweight by sex
###################################################
m1 <- glm(bweight ~ sex, family=gaussian, data=births)
summary(m1)


###################################################
### code chunk number 8: ci.lin of bweight by sex
###################################################
round( ci.lin(m1)[ , c(1,5,6)] , 1)


###################################################
### code chunk number 9: Effects of hyp on bweight
###################################################
effx(response=bweight, type="metric", exposure=hyp, data=births)


###################################################
### code chunk number 10: Effects of gest4 (four levels) on bweight
###################################################
effx(response=bweight,typ="metric",exposure=gest4,data=births)


###################################################
### code chunk number 11: Table of mean bweight by gest4
###################################################
stat.table(gest4,mean(bweight),data=births)


###################################################
### code chunk number 12: lm of gest4 on bweight
###################################################
m2 <- lm(bweight ~ gest4, data = births)
round( ci.lin(m2)[ , c(1,5,6)] , 1)


###################################################
### code chunk number 13: bweight-by-hyp-gest4
###################################################
par(mfrow=c(1,1))
with( births, interaction.plot(gest4, hyp, bweight) )


###################################################
### code chunk number 14: Effect of hyp on bweight stratified by gest4
###################################################
effx(bweight, type="metric", exposure=hyp, strata=gest4,data=births)


###################################################
### code chunk number 15: lm for hyp on bweight stratified by gest4
###################################################
m3 <- lm(bweight ~ gest4/hyp, data = births)
round( ci.lin(m3)[ , c(1,5,6)], 1) 


###################################################
### code chunk number 16: lmI for hyp on bweight stratified by gest4
###################################################
m3I <- lm(bweight ~ gest4 + hyp + gest4:hyp, data = births)
round( ci.lin(m3I)[ , c(1,5,6)], 1) 


###################################################
### code chunk number 17: lmIb for hyp on bweight stratified by gest4b
###################################################
births$gest4b <- Relevel( births$gest4, ref = 4)
m3Ib <- lm(bweight ~ gest4b*hyp, data = births)
round( ci.lin(m3Ib)[ , c(1,5,6)], 1) 


###################################################
### code chunk number 18: lmI for hyp on bweight stratified by gest4
###################################################
m3M <- lm(bweight ~ gest4 + hyp, data = births)
round( ci.lin(m3M)[ , c(1,5,6)], 1) 


###################################################
### code chunk number 19: test for hyp-gest4 interaction on bweight
###################################################
anova(m3I, m3M)


###################################################
### code chunk number 20: Effects of hyp on lowbw stratified by sex
###################################################
effx(bweight, type="metric", exposure=hyp, strata= sex, data=births)
m4S <- lm(bweight ~ sex/hyp, data = births)
round( ci.lin(m4S)[ , c(1,5,6)], 1) 
m4I <- lm(bweight ~ sex + hyp + sex:hyp, data = births)
round( ci.lin(m4I)[ , c(1,5,6)], 1) 


###################################################
### code chunk number 21: Effect of hyp on bweight controlled for sex
###################################################
effx(bweight, type="metric", exposure=hyp, control=sex, data=births)


###################################################
### code chunk number 22: lm for hyp on bweight controlled for sex
###################################################
m4 <- lm(bweight ~ sex + hyp, data = births)
ci.lin(m4)[ , c(1,5,6)]  


###################################################
### code chunk number 23: Linear effect of gestwks on bweight
###################################################
effx(response=bweight, type="metric", exposure=gestwks,data=births)
m5 <- lm(bweight ~ gestwks, data=births) ; ci.lin(m5)[ , c(1,5,6)]


###################################################
### code chunk number 24: Linear effect of gestwks on lowbw
###################################################
effx(response=lowbw, type="binary", exposure=gestwks,data=births)


###################################################
### code chunk number 25: Linear effect of gestwks on bweight stratified by maged
###################################################
effx(bweight, type="metric", exposure=gestwks, strata=maged, 
     data=births)


###################################################
### code chunk number 26: Plot-bweight-by-gestwks
###################################################
with(births, plot(gestwks,bweight))
abline(m5)


###################################################
### code chunk number 27: bweight-gestwks-m5-diag
###################################################
par(mfrow=c(2,2))
plot(m5)


###################################################
### code chunk number 28: bweight-gestwks-mPs
###################################################
mPs <- gam( bweight ~ s(gestwks), data = births)		
summary(mPs)	


###################################################
### code chunk number 29: mPs-sig2
###################################################
mPs$sig2
sqrt(mPs$sig2)


###################################################
### code chunk number 30: plotFitPredInt
###################################################
plotFitPredInt <- function( xval, fit, pred, ...)
{
    matshade( xval, fit,  lwd=2, alpha=0.2)
    matshade( xval, pred, lwd=2, alpha=0.2)
    matlines( xval, fit,  lty=1, lwd=c(3,2,2), col=c("red","blue","blue") )
    matlines( xval, pred, lty=1, lwd=c(3,2,2), col=c("red","green","green") )
}


###################################################
### code chunk number 31: bweight-gestwks-mPs-plot
###################################################
nd <- data.frame(gestwks = seq(24, 45, by = 0.25) ) 	
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
### code chunk number 32: lowbw-hyp-table
###################################################
stat.table( index=list(hyp, lowbw), 
            contents=list(count(), percent(lowbw)),
            margins=TRUE, data=births)


###################################################
### code chunk number 33: lowbw-hyp-comp
###################################################
binRD <- glm(lowbw ~ hyp, family=binomial(link="identity"), data=births)
round(ci.lin(binRD)[, c(1,2,5:6)], 3)
binRR <- glm(lowbw ~ hyp, family=binomial(link="log"), data=births)
round(ci.lin(binRR, Exp=TRUE)[, c(1,2,5:7)], 3)
binOR <- glm(lowbw ~ hyp, family=binomial(link="logit"), data=births)
round(ci.lin(binOR, Exp=TRUE)[, c(1,2,5:7)], 3)
effx(response=lowbw, type="binary", exposure=hyp, data=births)


###################################################
### code chunk number 34: lowbw-gestwks-table
###################################################
stat.table( index=list(gest4, lowbw),
          contents=list(count(), percent(lowbw)),
          margins=TRUE, data=births)


###################################################
### code chunk number 35: lowbw-gestwks-spline
###################################################
binm1 <- gam(lowbw ~ s(gestwks), family=binomial(link="logit"), data=births)
summary(binm1)
plot(binm1)


###################################################
### code chunk number 36: lowbw-gestwks-logitlin
###################################################
binm2 <- glm(lowbw ~ I(gestwks-40), family=binomial(link="logit"), data=births)
round(ci.lin(binm2, Exp=TRUE)[, c(1,2,5:7)], 3)


###################################################
### code chunk number 37: lowbw-gestwks-pred
###################################################
predm2 <- predict(binm2, newdata=nd, type="response")
plot( nd$gestwks, predm2, type="l")


###################################################
### code chunk number 38: lowbw-gestwks-hyp
###################################################
binm3 <- glm(lowbw ~ hyp*I(gestwks-40), family=binomial, data=births)
round(ci.lin(binm3, Exp=TRUE)[, c(1,2,5:7)], 3)


###################################################
### code chunk number 39: lowbw-gestwks-hyp-pred
###################################################
predm3hyp <- predict(binm3, 
   newdata=data.frame(hyp="hyper", nd), type="response")
predm3nor <- predict(binm3, 
   newdata=data.frame(hyp="normal", nd), type="response")
par(mfrow=c(1,2))
plot( nd$gestwks, qlogis(predm3hyp), type="l")
lines( nd$gestwks, qlogis(predm3nor), lty=2)
plot( nd$gestwks, predm3hyp, type="l")
lines( nd$gestwks, predm3nor, lty=2)


