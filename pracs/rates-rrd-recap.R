library( Epi )
options(digits=4)  #  to cut down decimal points in the output

###################################################
### code chunk number 1: rates-rrrd-17-e.Rnw:53-58
###################################################
D <- 15
Y <- 5.532    # thousands of years!
rate <- D / Y
SE.rate <- rate/sqrt(D)
c(rate, SE.rate, rate + c(-1.96, 1.96)*SE.rate )
mreg <- glm( cbind(D, Y) ~ 1, family=poisreg(link=log) )
ci.exp( mreg ) 

###################################################
### code chunk number 2: rates-rrrd-17-e.Rnw:53-58
###################################################
mreg <- glm( cbind(D, Y) ~ 1, family=poisreg(link=log) )
ci.lin( mreg )[,c(1,5,6)] 


###################################################
### code chunk number 3: rates-rrrd-17-e.Rnw:53-58
###################################################
mid <- glm( cbind(D,Y)~ 1, family=poisreg(link="identity"))
ci.lin( mid )
ci.lin( mid )[, c(1,5,6)]


###################################################
### code chunk number 4: rates-rrrd-17-e.Rnw:53-58
###################################################
Dx <- c(3,7,5)
Yx <- c(1.412,2.783,1.337)
Px <- 1:3
rates <- Dx/Yx 
rates
###################################################
### code chunk number 5: rates-rrrd-17-e.Rnw:53-58
###################################################
m3 <- glm( cbind(Dx,Yx) ~ 1, family=poisreg(link=log) )
ci.exp( m3 )

###################################################
### code chunk number 6: rates-rrrd-17-e.Rnw:53-58
###################################################
mp <- glm( cbind(Dx,Yx) ~ factor(Px), family=poisreg(link=log) )
ci.exp(mp)

###################################################
### code chunk number 7: rates-rrrd-17-e.Rnw:53-58
###################################################
anova( m3, mp, test="Chisq" )

###################################################
### code chunk number 8: rates-rrrd-17-e.Rnw:53-58
###################################################
D0 <- 15   ; D1 <- 28
Y0 <- 5.532 ; Y1 <- 4.783
D <- c(D0,D1) ; Y <- c(Y0,Y1); expos <- 0:1
mm <- glm( cbind(D,Y) ~ factor(expos), family=poisreg(link=log) )

###################################################
### code chunk number 9: rates-rrrd-17-e.Rnw:53-58
###################################################
ci.exp( mm )
ci.lin( mm, Exp=TRUE ) [,5:7]

###################################################
### code chunk number 10: rates-rrrd-17-e.Rnw:53-58
###################################################
R0<-D0/Y0
R1<-D1/Y1
RD <- diff( D/Y )
SED <- sqrt( sum( D/Y^2 ) )
c( R1, R0, RD, SED, RD+c(-1,1)*1.96*SED )

###################################################
### code chunk number 11 rates-rrrd-17-e.Rnw:53-58
###################################################
ma <- glm( cbind(D,Y) ~ factor(expos), 
           family=poisreg(link=identity) )
ci.lin( ma )[, c(1,5,6)]


###################################################
### code chunk number 12
###################################################
library( Epi )
options(digits=4)  #  to cut down decimal points in the output

D <- 15
Y <- 5.532    # thousands of years!
rate <- D / Y
SE.rate <- rate/sqrt(D)
c(rate, SE.rate, rate + c(-1.96, 1.96)*SE.rate )



SE.logr <- 1/sqrt(D)
EF <- exp( 1.96 * SE.logr )
c(log(rate), SE.logr)
c( rate, EF, rate/EF, rate*EF )




D0 <- 15   ; D1 <- 28
Y0 <- 5.532 ; Y1 <- 4.783
R1 <- D1/Y1; R0 <- D0/Y0
RR <- R1/R0
SE.lrr <- sqrt(1/D0+1/D1) 
EF <- exp( 1.96 * SE.lrr)
c( R1, R0, RR, RR/EF, RR*EF )


ci.mat
ci.mat()


rateandSE <- c( rate, SE.rate ) 
rateandSE
rateandSE %*% ci.mat()


lograndSE <- c( log(rate), SE.logr )
lograndSE
exp( lograndSE %*% ci.mat() )


exp( c( log(RR), SE.lrr ) %*% ci.mat() )

ci.mat( alpha=0.1 )
exp( c( log(RR), SE.lrr ) %*% ci.mat(alpha=0.1) )

D <- c(D0,D1) ; Y <- c(Y0,Y1); expos <- 0:1


CM <- rbind( c(1,0), c(1,1), c(0,1) )
rownames( CM ) <- c("rate 0","rate 1","RR 1 vs. 0")
CM
mm <- glm( D ~ factor(expos),
           family=poisson(link=log),  offset=log(Y) )
ci.exp( mm, ctr.mat=CM )


rownames( CM ) <- c("rate 0","rate 1","RD 1 vs. 0")
ma <- glm( cbind(D,Y) ~ factor(expos),
                 family=poisreg(link=identity) )

ci.lin( ma, ctr.mat=CM )[, c(1,5,6)]

