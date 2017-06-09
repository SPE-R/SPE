### R code from vignette source 'rates-rrrd-17-e.Rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: rates-rrrd-17-e.Rnw:49-51
###################################################
library( Epi )
options(digits=3)  #  to cut down decimal points in the output


###################################################
### code chunk number 2: rates-rrrd-17-e.Rnw:53-58
###################################################
D <- 15
Y <- 5.532    # thousands of years
rate <- D / Y
SE.rate <- rate/sqrt(D)
c(rate, SE.rate, rate + c(-1.96, 1.96)*SE.rate )


###################################################
### code chunk number 3: rates-rrrd-17-e.Rnw:63-67
###################################################
SE.logr <- 1/sqrt(D)
EF <- exp( 1.96 * SE.logr )
c(log(rate), SE.logr)
c( rate, EF, rate/EF, rate*EF )


###################################################
### code chunk number 4: rates-rrrd-17-e.Rnw:81-83
###################################################
m <- glm( D ~ 1, family=poisson(link=log), offset=log(Y) )
summary( m )


###################################################
### code chunk number 5: rates-rrrd-17-e.Rnw:92-93
###################################################
ci.lin( m )


###################################################
### code chunk number 6: rates-rrrd-17-e.Rnw:98-99
###################################################
ci.lin( m, Exp=TRUE)


###################################################
### code chunk number 7: rates-rrrd-17-e.Rnw:104-106
###################################################
ci.exp( m)
ci.lin( m, Exp=TRUE)[, 5:7] 


###################################################
### code chunk number 8: rates-rrrd-17-e.Rnw:117-119
###################################################
mw <- glm( D/Y ~ 1, family=poisson, weight=Y )
ci.exp( mw ) 


###################################################
### code chunk number 9: rates-rrrd-17-e.Rnw:132-134
###################################################
mi <- glm( D/Y ~ 1, family=poisson(link=identity), weight=Y )
coef( mi )


###################################################
### code chunk number 10: rates-rrrd-17-e.Rnw:142-143
###################################################
ci.lin( mi )[, c(1,5,6)]


###################################################
### code chunk number 11: rates-rrrd-17-e.Rnw:157-162
###################################################
Dx <- c(3,7,5)
Yx <- c(1.412,2.783,1.337)
Px <- 1:3
rates <- Dx/Yx 
rates


###################################################
### code chunk number 12: rates-rrrd-17-e.Rnw:166-168
###################################################
m3 <- glm( Dx ~ 1, family=poisson, offset=log(Yx)  )
ci.exp( m3 )


###################################################
### code chunk number 13: rates-rrrd-17-e.Rnw:173-174
###################################################
mp <- glm( Dx ~ factor(Px), offset=log(Yx), family=poisson )


###################################################
### code chunk number 14: rates-rrrd-17-e.Rnw:179-180
###################################################
anova( m3, mp, test="Chisq" )

##  The deviance between the two nested models is only 0.7
##  which with 2 degrees of freedom implies a P-value of 0.7.
##  (NB. The same value for deviance and P is a coincidence.)
##  Thus, there is no sufficient evidence against the
##  simplifying null hypothesis according to which the
##  rate is constant over the three separate periods.


###################################################
### code chunk number 15: rates-rrrd-17-e.Rnw:222-228
###################################################
D0 <- 15   ; D1 <- 28
Y0 <- 5.532 ; Y1 <- 4.783
RR <- (D1/Y1)/(D0/Y0)
SE.lrr <- sqrt(1/D0+1/D1) 
EF <- exp( 1.96 * SE.lrr)
c( RR, RR/EF, RR*EF )


###################################################
### code chunk number 16: rates-rrrd-17-e.Rnw:232-234
###################################################
D <- c(D0,D1) ; Y <- c(Y0,Y1); expos <- 0:1
mm <- glm( D ~ factor(expos), family=poisson, offset=log(Y) )


###################################################
### code chunk number 17: rates-rrrd-17-e.Rnw:240-241
###################################################
ci.exp( mm )


###################################################
### code chunk number 18: rates-rrrd-17-e.Rnw:261-264
###################################################
rd <- diff( D/Y )
sed <- sqrt( sum( D/Y^2 ) )
c( rd, rd + c(-1, 1) * 1.96 * sed )


###################################################
### code chunk number 19: rates-rrrd-17-e.Rnw:268-271
###################################################
ma <- glm( D/Y ~ factor(expos), 
           family=poisson(link=identity), weight=Y )
ci.lin( ma )[, c(1,5,6)]


###################################################
### code chunk number 20: rates-rrrd-17-e.Rnw:287-289
###################################################
ci.mat
ci.mat()


###################################################
### code chunk number 21: rates-rrrd-17-e.Rnw:300-303
###################################################
rateandSE <- c( rate, SE.rate ) 
rateandSE
rateandSE %*% ci.mat()


###################################################
### code chunk number 22: rates-rrrd-17-e.Rnw:308-311
###################################################
lograndSE <- c( log(rate), SE.logr )
lograndSE
exp( lograndSE %*% ci.mat() )


###################################################
### code chunk number 23: rates-rrrd-17-e.Rnw:316-317
###################################################
exp( c( log(RR), SE.lrr ) %*% ci.mat() )


###################################################
### code chunk number 24: rates-rrrd-17-e.Rnw:325-327
###################################################
ci.mat( alpha=0.1 )
exp( c( log(RR), SE.lrr ) %*% ci.mat(alpha=0.1) )


###################################################
### code chunk number 25: rates-rrrd-17-e.Rnw:334-340
###################################################
CM <- rbind( c(1,0), c(1,1), c(0,1) )
rownames( CM ) <- c("rate 0", "rate 1", "RR 1 vs. 0")
CM
mm <- glm( D ~ factor(expos),
           family=poisson(link=log),  offset=log(Y) )
ci.exp( mm, ctr.mat=CM )


###################################################
### code chunk number 26: rates-rrrd-17-e.Rnw:345-349
###################################################
rownames( CM ) <- c("rate 0", "rate 1", "RD 1 vs. 0")
ma <- glm( D/Y ~ factor(expos),
                 family=poisson(link=identity), weight=Y )
ci.lin( ma, ctr.mat=CM )[, c(1,5,6)]


