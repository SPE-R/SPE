### R code from vignette source 'rates-rrrd-s.rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: rates-rrrd-s.rnw:47-49
###################################################
library( Epi )
options(digits=4)  #  to cut down decimal points in the output


###################################################
### code chunk number 2: rates-rrrd-s.rnw:51-56
###################################################
D <- 15
Y <- 5.532    # thousands of years!
rate <- D / Y
SE.rate <- rate/sqrt(D)
c(rate, SE.rate, rate + c(-1.96, 1.96)*SE.rate )


###################################################
### code chunk number 3: rates-rrrd-s.rnw:61-65
###################################################
SE.logr <- 1/sqrt(D)
EF <- exp( 1.96 * SE.logr )
c(log(rate), SE.logr)
c( rate, EF, rate/EF, rate*EF )


###################################################
### code chunk number 4: rates-rrrd-s.rnw:88-90
###################################################
m <- glm( D ~ 1, family=poisson(link=log), offset=log(Y) )
summary( m )


###################################################
### code chunk number 5: rates-rrrd-s.rnw:101-102
###################################################
ci.lin( m )


###################################################
### code chunk number 6: rates-rrrd-s.rnw:107-108
###################################################
ci.lin( m, Exp=TRUE)


###################################################
### code chunk number 7: rates-rrrd-s.rnw:113-115
###################################################
ci.exp( m)
ci.lin( m, Exp=TRUE)[, 5:7] 


###################################################
### code chunk number 8: rates-rrrd-s.rnw:128-130
###################################################
mreg <- glm( cbind(D, Y) ~ 1, family=poisreg(link=log) )
ci.exp( mreg ) 


###################################################
### code chunk number 9: rates-rrrd-s.rnw:147-150
###################################################
mid <- glm( cbind(D,Y) ~ 1, family=poisreg(link=identity) )
ci.lin( mid )
ci.lin( mid )[, c(1,5,6)]


###################################################
### code chunk number 10: rates-rrrd-s.rnw:175-177
###################################################
ci.lin( mid )
sqrt(D)/Y 


###################################################
### code chunk number 11: rates-rrrd-s.rnw:189-194
###################################################
Dx <- c(3,7,5)
Yx <- c(1.412,2.783,1.337)
Px <- 1:3
rates <- Dx/Yx 
rates


###################################################
### code chunk number 12: rates-rrrd-s.rnw:199-201
###################################################
m3 <- glm( cbind(Dx,Yx) ~ 1, family=poisreg(link=log) )
ci.exp( m3 )


###################################################
### code chunk number 13: rates-rrrd-s.rnw:206-208
###################################################
mp <- glm( cbind(Dx,Yx) ~ factor(Px), family=poisreg(link=log) )
ci.exp(mp)


###################################################
### code chunk number 14: rates-rrrd-s.rnw:213-214
###################################################
anova( m3, mp, test="Chisq" )


###################################################
### code chunk number 15: rates-rrrd-s.rnw:267-274
###################################################
D0 <- 15   ; D1 <- 28
Y0 <- 5.532 ; Y1 <- 4.783
R1 <- D1/Y1; R0 <- D0/Y0
RR <- R1/R0
SE.lrr <- sqrt(1/D0+1/D1) 
EF <- exp( 1.96 * SE.lrr)
c( R1, R0, RR, RR/EF, RR*EF )


###################################################
### code chunk number 16: rates-rrrd-s.rnw:280-282
###################################################
D <- c(D0,D1) ; Y <- c(Y0,Y1); expos <- 0:1
mm <- glm( cbind(D,Y) ~ factor(expos), family=poisreg(link=log) )


###################################################
### code chunk number 17: rates-rrrd-s.rnw:287-289
###################################################
ci.exp( mm )
ci.lin( mm, Exp=TRUE ) [,5:7]


###################################################
### code chunk number 18: rates-rrrd-s.rnw:309-312
###################################################
RD <- diff( D/Y )    ##  or RD <- R1 - R0
SED <- sqrt( sum( D/Y^2 ) )
c( R1, R0, RD, SED, RD+c(-1,1)*1.96*SED )


###################################################
### code chunk number 19: rates-rrrd-s.rnw:316-319
###################################################
ma <- glm( cbind(D,Y) ~ factor(expos), 
           family=poisreg(link=identity) )
ci.lin( ma )[, c(1,5,6)]


###################################################
### code chunk number 20: rates-rrrd-s.rnw:337-339
###################################################
mwei <- glm( D/Y ~ 1, family=poisson(link=log), weight=Y )
ci.exp( mwei ) 


###################################################
### code chunk number 21: rates-rrrd-s.rnw:362-364
###################################################
ci.mat
ci.mat()


###################################################
### code chunk number 22: rates-rrrd-s.rnw:375-378
###################################################
rateandSE <- c( rate, SE.rate ) 
rateandSE
rateandSE %*% ci.mat()


###################################################
### code chunk number 23: rates-rrrd-s.rnw:383-386
###################################################
lograndSE <- c( log(rate), SE.logr )
lograndSE
exp( lograndSE %*% ci.mat() )


###################################################
### code chunk number 24: rates-rrrd-s.rnw:391-392
###################################################
exp( c( log(RR), SE.lrr ) %*% ci.mat() )


###################################################
### code chunk number 25: rates-rrrd-s.rnw:400-402
###################################################
ci.mat( alpha=0.1 )
exp( c( log(RR), SE.lrr ) %*% ci.mat(alpha=0.1) )


###################################################
### code chunk number 26: rates-rrrd-s.rnw:409-415
###################################################
CM <- rbind( c(1,0), c(1,1), c(0,1) )
rownames( CM ) <- c("rate 0","rate 1","RR 1 vs. 0")
CM
mm <- glm( D ~ factor(expos),
           family=poisson(link=log),  offset=log(Y) )
ci.exp( mm, ctr.mat=CM )


###################################################
### code chunk number 27: rates-rrrd-s.rnw:420-424
###################################################
rownames( CM ) <- c("rate 0","rate 1","RD 1 vs. 0")
ma <- glm( cbind(D,Y) ~ factor(expos),
                 family=poisreg(link=identity) )
ci.lin( ma, ctr.mat=CM )[, c(1,5,6)]


