library( Epi )
options(digits=4)  #  to cut down decimal points in the output

###################################################
### code chunk number 1: Rate and 95 CI (normal approx. rate by hand)
###################################################
D <- 15
Y <- 5.532    # thousands of years!
rate <- D / Y
SE.rate <- rate/sqrt(D)
c(rate, SE.rate, rate + c(-1.96, 1.96)*SE.rate )

###################################################
### code chunk number 1: Rate and Wald based 95 CI for log rate and exp transformed
###################################################

mreg <- glm( cbind(D, Y) ~ 1, family=poisreg(link=log) )
ci.exp( mreg ) 

###################################################
### code chunk number 2: log(Rate) and it's 95% CI. ci.lin NO exp=T
###################################################
mreg <- glm( cbind(D, Y) ~ 1, family=poisreg(link=log) )
ci.lin( mreg )[,c(1,5,6)] 


###################################################
### code chunk number 3: Rate and CI (with modeling for rate, not log rate!!!)
###################################################
mid <- glm( cbind(D,Y)~ 1, family=poisreg(link="identity"))
ci.lin( mid )
ci.lin( mid )[, c(1,5,6)]


###################################################
### code chunk number 4: rate ratios with 
###################################################
Dx <- c(3,7,5)
Yx <- c(1.412,2.783,1.337)
Px <- 1:3
rates <- Dx/Yx 
rates
###################################################
### code chunk number 5: average rate ignoring groups
###################################################
m3 <- glm( cbind(Dx,Yx) ~ 1, family=poisreg(link=log) )
ci.exp( m3 )

###################################################
### code chunk number 6: reference category comparison of rates
###################################################
mp <- glm( cbind(Dx,Yx) ~ factor(Px), family=poisreg(link=log) )
ci.exp(mp)

###################################################
### code chunk number 7: LR test for H0:Px=0 exp(Px=0)=1
###################################################
anova( m3, mp, test="Chisq" )

###################################################
### code chunk number 8: Rate ratios- 2 groups
###################################################
D0 <- 15   ; D1 <- 28
Y0 <- 5.532 ; Y1 <- 4.783
D <- c(D0,D1) ; Y <- c(Y0,Y1); expos <- 0:1
mm <- glm( cbind(D,Y) ~ factor(expos), family=poisreg(link=log) )

###################################################
### code chunk number 9: Rate ratio and 95%CI - binary factor 
###################################################
ci.exp( mm )
ci.lin( mm, Exp=TRUE ) [,5:7]

###################################################
### code chunk number 10:  normal approx. rate difference by hand
###################################################
R0<-D0/Y0
R1<-D1/Y1
RD <- diff( D/Y )
SED <- sqrt( sum( D/Y^2 ) )
c( R1, R0, RD, SED, RD+c(-1,1)*1.96*SED )

###################################################
### code chunk number 11 model based rd and 95% CI
###################################################
ma <- glm( cbind(D,Y) ~ factor(expos), 
           family=poisreg(link=identity) )
ci.lin( ma )[, c(1,5,6)]

###################################################
### code chunk for Binary regression
###################################################

library(dplyr)
library(Epi)
data(births)
str(births)

births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
births$sex <- factor(births$sex, labels = c("M", "F"))
births$gest4 <- cut(births$gestwks, 
                    breaks = c(20, 35, 37, 39, 45), right = FALSE)
births$maged <- ifelse(births$matage<35,0,1) # dichotomous 

###################################################
### code chunk for Binary regression
###################################################

births %>%
  count(hyp,lowbw) %>%
  group_by(hyp) %>% # now required with changes to dplyr::count()
  mutate(prop = prop.table(n))

###################################################
### code chunk for Binary regression
###################################################

m<-glm(lowbw~hyp,family=binomial(link=log),data=births)
ci.exp(m)

###################################################
### code chunk for Binary regression
###################################################

m<-glm(lowbw~sex+hyp,family=binomial(link=log),data=births)
ci.exp(m)


m<-glm(lowbw~maged+sex+hyp,family=binomial(link=log),data=births)
ci.exp(m)



###################################################
### code chunk number   
###################################################

library( Epi )
options(digits=4)  #  to cut down decimal points in the output

D <- 15
Y <- 5.532    # thousands of years!
rate <- D / Y
SE.rate <- rate/sqrt(D)
c(rate, SE.rate, rate + c(-1.96, 1.96)*SE.rate )

###################################################
### code chunk number  
###################################################


SE.logr <- 1/sqrt(D)
EF <- exp( 1.96 * SE.logr )
c(log(rate), SE.logr)
c( rate, EF, rate/EF, rate*EF )


###################################################
### code chunk number   
###################################################


D0 <- 15   ; D1 <- 28
Y0 <- 5.532 ; Y1 <- 4.783
R1 <- D1/Y1; R0 <- D0/Y0
RR <- R1/R0
SE.lrr <- sqrt(1/D0+1/D1) 
EF <- exp( 1.96 * SE.lrr)
c( R1, R0, RR, RR/EF, RR*EF )

###################################################
### code chunk number 
###################################################

ci.mat
ci.mat()

###################################################
### code chunk number 
###################################################

rateandSE <- c( rate, SE.rate ) 
rateandSE
rateandSE %*% ci.mat()
###################################################
### code chunk number   
###################################################


lograndSE <- c( log(rate), SE.logr )
lograndSE
exp( lograndSE %*% ci.mat() )

###################################################
### code chunk number   
###################################################

exp( c( log(RR), SE.lrr ) %*% ci.mat() )

###################################################
### code chunk number 
###################################################


ci.mat( alpha=0.1 )
exp( c( log(RR), SE.lrr ) %*% ci.mat(alpha=0.1) )

###################################################
### code chunk number 
###################################################


D <- c(D0,D1) ; Y <- c(Y0,Y1); expos <- 0:1


CM <- rbind( c(1,0), c(1,1), c(0,1) )
rownames( CM ) <- c("rate 0","rate 1","RR 1 vs. 0")
CM

###################################################
### code chunk number 
###################################################

mm <- glm( D ~ factor(expos),
           family=poisson(link=log),  offset=log(Y) )
ci.exp( mm, ctr.mat=CM )

###################################################
### code chunk number 
###################################################

rownames( CM ) <- c("rate 0","rate 1","RD 1 vs. 0")
ma <- glm( cbind(D,Y) ~ factor(expos),
                 family=poisreg(link=identity) )

ci.lin( ma, ctr.mat=CM )[, c(1,5,6)]

