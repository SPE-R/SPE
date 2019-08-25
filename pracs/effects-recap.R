### R code from vignette source 'effects-s.rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: Run births-house
###################################################
library(Epi)
data(births)
str(births)


###################################################
### code chunk number 2: effects-s.rnw:80-86
###################################################
births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
births$sex <- factor(births$sex, labels = c("M", "F"))
births$agegrp <- cut(births$matage, 
    breaks = c(20, 25, 30, 35, 40, 45), right = FALSE)
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
with( births, t.test(bweight ~ sex, var.equal=T) )


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
### code chunk number 25: Linear effect of gestwks on bweight stratified by agegrp
###################################################
effx(bweight, type="metric", exposure=gestwks, strata=agegrp, data=births)


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
### code chunk number 28: bweight-by-gestwks-cubic
###################################################
m6 <- update(m5, . ~ .  + I(gestwks^2) + I(gestwks^3))
round(ci.lin(m6)[, c(1,5,6)], 1)


###################################################
### code chunk number 29: bweight-by-gestwks-cubic-ortog
###################################################
births2 <- subset(births, !is.na(gestwks))
m.ortpoly <- lm(bweight ~ poly(gestwks, 3), data= births2 )
round(ci.lin(m.ortpoly)[, c(1,5,6)], 1)
anova(m5, m.ortpoly)


###################################################
### code chunk number 30: bweight-by-gestwks-cubic-pred
###################################################
nd <- data.frame(gestwks = seq(24, 45, by = 0.25) ) 
fit.poly <- predict( m.ortpoly, newdata=nd, interval="conf" )
pred.poly <- predict( m.ortpoly, newdata=nd, interval="pred" )
par(mfrow=c(1,1))
with( births, plot( bweight ~ gestwks, xlim = c(23, 46), cex.axis= 1.5, cex.lab = 1.5 )  )
matlines( nd$gestwks, fit.poly, lty=1, lwd=c(3,2,2), col=c('red','blue','blue') )
matlines( nd$gestwks, pred.poly, lty=1, lwd=c(3,2,2), col=c('red','green','green') )


###################################################
### code chunk number 31: bweight-gestwks-Ns5
###################################################
library(splines)
mNs5 <- lm( bweight ~ Ns( gestwks, 
        knots = c(28,34,38,40,43)), data = births)
round(ci.lin(mNs5)[ , c(1,5,6)], 1)


###################################################
### code chunk number 32: Ns5-pred
###################################################
fit.Ns5 <- predict( mNs5, newdata=nd, interval="conf" )
pred.Ns5 <- predict( mNs5, newdata=nd, interval="pred" )
with( births, plot( bweight ~ gestwks, xlim = c(23, 46), cex.axis= 1.5, cex.lab = 1.5 )  )
matlines( nd$gestwks, fit.Ns5, lty=1, lwd=c(3,2,2), col=c('red','blue','blue') )
matlines( nd$gestwks, pred.Ns5, lty=1, lwd=c(3,2,2), col=c('red','green','green') )


###################################################
### code chunk number 33: cubic-diag
###################################################
par(mfrow=c(2,2))
plot(mNs5)


###################################################
### code chunk number 34: bweigth-gestwks-Ns10
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
### code chunk number 35: bweight-gestwks-mPen
###################################################
library(mgcv)
mPen <- gam( bweight ~ s(gestwks), data = births)		
summary(mPen)	


###################################################
### code chunk number 36: mPen-sig2
###################################################
mPen$sig2
sqrt(mPen$sig2)


###################################################
### code chunk number 37: bweight-gestwks-mPen-plot
###################################################
pr.Pen <- predict( mPen, newdata=nd, se.fit=T)
par(mfrow=c(1,1))
with( births, plot( bweight ~ gestwks, xlim = c(24, 45), cex.axis= 1.5, cex.lab = 1.5 )  )
matlines( nd$gestwks, cbind(pr.Pen$fit, 
  pr.Pen$fit - 2*pr.Pen$se.fit, pr.Pen$fit + 2*pr.Pen$se.fit),  
  lty=1, lwd=c(3,2,2), col=c('red','blue','blue') )
matlines( nd$gestwks, cbind(pr.Pen$fit, 
  pr.Pen$fit - 2*sqrt( pr.Pen$se.fit^2 + mPen$sig2), 
  pr.Pen$fit + 2*sqrt( pr.Pen$se.fit^2 + mPen$sig2)),  
  lty=1, lwd=c(3,2,2), col=c('red','green','green')  )


###################################################
### code chunk number 38: Get the UCBAdmissions data
###################################################
UCBAdmissions


###################################################
### code chunk number 39: Convert the 2x2x6 contingency table to a data frame
###################################################
ucb <- as.data.frame(UCBAdmissions)
head(ucb)


###################################################
### code chunk number 40: Convert Admit to numeric coded 0/1
###################################################
ucb$Admit <- as.numeric(ucb$Admit)-1


###################################################
### code chunk number 41: Effect of Gender on Admit
###################################################
effx(Admit,type="binary",exposure=Gender,weights=Freq,data=ucb)


###################################################
### code chunk number 42: Effect of Gender stratified by Dept
###################################################
effx(Admit,type="binary",exposure=Gender,strata=Dept,weights=Freq,data=ucb)


###################################################
### code chunk number 43: Effect of Gender controlled for Dept
###################################################
effx(Admit,type="binary",exposure=Gender,control=Dept,weights=Freq,data=ucb)


