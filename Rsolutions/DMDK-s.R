### R code from vignette source '/home/runner/work/SPE/SPE/build/DMDK-s.rnw'

###################################################
### code chunk number 1: DMDK-s.rnw:5-10
###################################################
options( width=90,
         prompt=" ", continue=" ", # Absence of prompts makes it easier for
                                   # students to copy from the final pdf document
         SweaveHooks=list( fig=function()
         par(mar=c(3,3,1,1),mgp=c(3,1,0)/1.6,las=1,bty="n") ) )


###################################################
### code chunk number 2: DMDK-s.rnw:25-31
###################################################
options( width=90 )
library( Epi )
library( popEpi )
library( mgcv )
data( DMlate )
head( DMlate )


###################################################
### code chunk number 3: DMDK-s.rnw:41-43
###################################################
with( DMlate, table( dead=!is.na(dodth),
                     same=(dodth==dox), exclude=NULL ) )


###################################################
### code chunk number 4: DMDK-s.rnw:47-53
###################################################
LL <- Lexis( entry = list( A = dodm-dobth,
                           P = dodm,
                         dur = 0 ),
              exit = list( P = dox ),
       exit.status = 1*!is.na(dodth),
              data = DMlate )


###################################################
### code chunk number 5: DMDK-s.rnw:60-67
###################################################
LL <- Lexis( entry = list( A = dodm-dobth,
                           P = dodm,
                         dur = 0 ),
              exit = list( P = dox ),
       exit.status = 1*!is.na(dodth),
              data = DMlate,
      keep.dropped = TRUE )


###################################################
### code chunk number 6: DMDK-s.rnw:70-71
###################################################
attr( LL, 'dropped' )


###################################################
### code chunk number 7: DMDK-s.rnw:75-77
###################################################
summary( LL )
head( LL )


###################################################
### code chunk number 8: DMDK-s.rnw:83-89
###################################################
stat.table( sex,
            list( D=sum( lex.Xst ),
                  Y=sum( lex.dur ),
               rate=ratio( lex.Xst, lex.dur, 1000 ) ),
            margins=TRUE,
            data=LL )


###################################################
### code chunk number 9: DMDK-s.rnw:112-117
###################################################
system.time( SL <- splitLexis( LL, breaks=seq(0,125,1/2), time.scale="A" ) )
summary( SL ) ; class( SL )
system.time( SL <- splitMulti( LL, A=seq(0,125,1/2) ) )
summary( SL ) ; class( SL )
summary( LL )


###################################################
### code chunk number 10: DMDK-s.rnw:173-182
###################################################
str( SL )
SL$Am <- floor( SL$A+0.25 )
SL$Pm <- floor( SL$P+0.25 )
data( M.dk )
str( M.dk )
M.dk <- transform( M.dk, Am = A,
                         Pm = P,
                        sex = factor( sex, labels=c("M","F") ) )
str( M.dk )


###################################################
### code chunk number 11: DMDK-s.rnw:187-190
###################################################
SLr <- merge( SL, M.dk[,c("sex","Am","Pm","rate")] )
dim( SL )
dim( SLr )


###################################################
### code chunk number 12: DMDK-s.rnw:202-217
###################################################
SLr$E <- SLr$lex.dur * SLr$rate / 1000
stat.table( sex, 
            list( D = sum(lex.Xst), 
                  Y = sum(lex.dur), 
                  E = sum(E), 
                SMR = ratio(lex.Xst,E) ), 
            data = SLr,
            margin = TRUE ) 
stat.table( list( sex, Age = floor(pmax(A,39)/10)*10 ), 
            list( D = sum(lex.Xst), 
                  Y = sum(lex.dur), 
                  E = sum(E), 
                SMR = ratio(lex.Xst,E) ), 
             margin = TRUE,
               data = SLr )


###################################################
### code chunk number 13: DMDK-s.rnw:229-234
###################################################
msmr <- glm( lex.Xst ~ sex - 1,
             offset = log(E),
             family = poisson,
             data = subset(SLr,E>0) )
ci.exp( msmr )


###################################################
### code chunk number 14: DMDK-s.rnw:241-245
###################################################
msmr <- glm( cbind(lex.Xst,E) ~ sex - 1,
             family = poisreg,
               data = subset(SLr,E>0) )
ci.exp( msmr )


###################################################
### code chunk number 15: DMDK-s.rnw:249-250
###################################################
round( ci.exp( msmr, ctr.mat=rbind(M=c(1,0),W=c(0,1),'M/F'=c(1,-1)) ), 2 )


###################################################
### code chunk number 16: DMDK-s.rnw:265-271
###################################################
r.m <- gam( cbind(lex.Xst,lex.dur) ~ s(A,k=20),
            family = poisreg,
              data = subset( SL, sex=="M" ) )
r.f <- update( r.m, data = subset( SL, sex=="F" ) )
gam.check( r.m )
gam.check( r.f )


###################################################
### code chunk number 17: DMDK-s.rnw:296-300
###################################################
nd <-  data.frame( A = seq(20,90,0.5) )
p.m <- ci.pred( r.m, newdata = nd ) * 1000
p.f <- ci.pred( r.f, newdata = nd ) * 1000
str( p.m )


###################################################
### code chunk number 18: a-rates
###################################################
matshade( nd$A, cbind(p.m,p.f), plot=TRUE,
          col=c("blue","red"), lwd=3,
          log="y", xlab="Age", ylab="Mortality of DM ptt per 1000 PY")


###################################################
### code chunk number 19: DMDK-s.rnw:330-338
###################################################
Mcr <- gam( cbind(lex.Xst,lex.dur) ~ s(   A, bs="cr", k=10 ) +
                                     s(   P, bs="cr", k=10 ) +
                                     s( dur, bs="cr", k=10 ),
            family = poisreg,
              data = subset( SL, sex=="M" ) )
summary( Mcr )
Fcr <- update( Mcr, data = subset( SL, sex=="F" ) )
summary( Fcr )


###################################################
### code chunk number 20: plgam-default
###################################################
par( mfrow=c(2,3) )
plot( Mcr, ylim=c(-3,3), col="blue" )
plot( Fcr, ylim=c(-3,3), col="red" )


###################################################
### code chunk number 21: DMDK-s.rnw:358-360
###################################################
anova( Mcr, r.m, test="Chisq" )
anova( Fcr, r.f, test="Chisq" )


###################################################
### code chunk number 22: DMDK-s.rnw:381-386
###################################################
pts <- seq(0,12,0.5)
nd <- data.frame( A =   50+pts,
                  P = 1995+pts,
                dur =      pts )
head( cbind( nd$A, ci.pred( Mcr, newdata=nd )*1000 ) )


###################################################
### code chunk number 23: rates
###################################################
pts <- seq(0,12,0.1)
plot( NA, xlim = c(50,85), ylim = c(5,400), log="y",
          xlab="Age", ylab="Mortality rate for DM patients per 1000 PY" )
for( ip in c(1995,2005) )
for( ia in c(50,60,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts )
matshade( nd$A, ci.pred( Mcr, nd )*1000, col="blue" )
matshade( nd$A, ci.pred( Fcr, nd )*1000, col="red" )
   }


###################################################
### code chunk number 24: rates5
###################################################
Mcr <- gam( cbind(lex.Xst,lex.dur) ~ s(   A, bs="cr", k=10 ) +
                                     s(   P, bs="cr", k=10 ) +
                                     s( dur, bs="cr", k=5 ),
                  family = poisreg, 
                    data = subset(SL,sex=="M") )
Fcr <- update( Mcr, data = subset(SL,sex=="F") )
gam.check( Mcr )
gam.check( Fcr )


###################################################
### code chunk number 25: rates-5
###################################################
plot( NA, xlim = c(50,80), ylim = c(0.9,100), log="y",
          xlab="Age", ylab="Mortality rate for DM patients" )
abline( v = c(50,55,60,65,70), col=gray(0.8) )
# for( ip in c(1995,2005) )
ip <- 2005
for( ia in c(50,55,60,65,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts )
matshade( nd$A, rm <- ci.pred( Mcr, nd )*1000, col="blue", lwd=2 )
matshade( nd$A, rf <- ci.pred( Fcr, nd )*1000, col="red" , lwd=2 )
matshade( nd$A, ci.ratio( rm, rf ), lwd=2 )
   } 
abline( h=1, lty="55" )


###################################################
### code chunk number 26: SMReff
###################################################
SLr <- subset( SLr, E>0 )
Msmr <- gam( cbind(lex.Xst,E) ~ s(   A, bs="cr", k=10 ) +
                                s(   P, bs="cr", k=10 ) +
                                s( dur, bs="cr", k=5 ),
              family = poisreg,
                data = subset( SLr, sex=="M" ) )
Fsmr <- update( Msmr, 
                data = subset( SLr, sex=="F" ) )
summary( Msmr )
summary( Fsmr )
par( mfrow=c(2,3) )
plot( Msmr, ylim=c(-1,2), col="blue" )
plot( Fsmr, ylim=c(-1,2), col="red" )


###################################################
### code chunk number 27: SMRsm
###################################################
plot( NA, xlim = c(50,82), ylim = c(0.5,5), log="y",
          xlab="Age", ylab="SMR relative to total population" )
abline( v = c(50,55,60,65,70), col=gray(0.8) )
# for( ip in c(1995,2005) )
ip <- 1998
for( ia in c(50,55,60,65,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts )
matshade( nd$A, rm <- ci.pred( Msmr, nd ), col="blue", lwd=2 )
matshade( nd$A, rf <- ci.pred( Fsmr, nd ), col="red" , lwd=2 )
matshade( nd$A, ci.ratio( rm, rf ), lwd=2, col=gray(0.5) )
   } 
abline( h=1, lty="55" )


###################################################
### code chunk number 28: DMDK-s.rnw:536-545
###################################################
Asmr <- gam( cbind(lex.Xst,E) ~ sex +
                                sex:I(A-60) + 
                                sex:I(P-2000) +
                                s( dur, k=5 ),
             family = poisreg,
               data = SLr )
summary( Asmr )
gam.check( Asmr )
round( ( ci.exp(Asmr,subset="sex")-1 )*100, 1 )


###################################################
### code chunk number 29: SMRsl
###################################################
plot( NA, xlim = c(50,80), ylim = c(0.5,5), log="y",
          xlab="Age", ylab="SMR relative to total population" )
abline( v = c(50,55,60,65,70), col=gray(0.8) )
# for( ip in c(1995,2005) )
ip <- 1998
for( ia in c(50,55,60,65,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts )
matshade( nd$A, rm <- ci.pred( Asmr, cbind(nd,sex="M") ), col="blue", lwd=2 )
matshade( nd$A, rf <- ci.pred( Asmr, cbind(nd,sex="F") ), col="red" , lwd=2 )
matshade( nd$A, ci.ratio( rm, rf ), lwd=2, col=gray(0.5) )
   } 
abline( h=1, lty="55" )


###################################################
### code chunk number 30: DMDK-s.rnw:587-588
###################################################
dim( Ns(SLr$dur, knots=c(0,1,4,8) ) )


###################################################
### code chunk number 31: DMDK-s.rnw:591-596
###################################################
SMRglm <- glm( cbind(lex.Xst,E) ~ I(A-60) + 
                                  I(P-2000) + 
                                  Ns( dur, knots=c(0,1,4,8) ),
               family = poisreg,
                 data = SLr )


###################################################
### code chunk number 32: SMRsp
###################################################
plot( NA, xlim = c(50,80), ylim = c(0.8,5), log="y",
          xlab="Age", ylab="SMR relative to total population" )
abline( v = c(50,55,60,65,70), col=gray(0.8) )
# for( ip in c(1995,2005) )
ip <- 1998
for( ia in c(50,55,60,65,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts )
matshade( nd$A, ci.pred( SMRglm, nd ), lwd=2 )
   } 
abline( h=1, lty="55" )


