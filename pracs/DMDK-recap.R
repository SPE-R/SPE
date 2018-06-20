### R code from vignette source 'DMDK-s.rnw'
### Encoding: UTF-8

###################################################
### code chunk number 1: DMDK-s.rnw:5-10
###################################################
options( width=90,
         prompt=" ", continue=" ", # Absence of prompts makes it easier for
                                   # students to copy from the final pdf document
         SweaveHooks=list( fig=function()
         par(mar=c(3,3,1,1),mgp=c(3,1,0)/1.6,las=1,bty="n") ) )


###################################################
### code chunk number 2: DMDK-s.rnw:25-33
###################################################
options( width=90 )
library( Epi )
library( popEpi )
library( mgcv )
data( DMlate )
str( DMlate )
head( DMlate )
summary( DMlate )


###################################################
### code chunk number 3: DMDK-s.rnw:43-45
###################################################
with( DMlate, table( dead=!is.na(dodth),
                     same=(dodth==dox), exclude=NULL ) )


###################################################
### code chunk number 4: DMDK-s.rnw:49-56
###################################################
LL <- Lexis( entry = list( A = dodm-dobth,
                           P = dodm,
                         dur = 0 ),
              exit = list( P = dox ),
       exit.status = factor( !is.na(dodth),
                             labels=c("Alive","Dead") ),
              data = DMlate )

###################################################
### code chunk number 7: DMDK-s.rnw:81-83
###################################################
summary( LL )
head( LL )


###################################################
### code chunk number 8: DMDK-s.rnw:89-95
###################################################
stat.table( sex,
            list( D=sum( lex.Xst=="Dead" ),
                  Y=sum( lex.dur ),
               rate=ratio( lex.Xst=="Dead", lex.dur, 1000 ) ),
            margins=TRUE,
            data=LL )


###################################################
### code chunk number 9: DMDK-s.rnw:118-123
###################################################
system.time( SL <- splitLexis( LL, breaks=seq(0,125,1/2), time.scale="A" ) )
summary( SL ) ; class( SL )
system.time( SL <- splitMulti( LL, A=seq(0,125,1/2) ) )
summary( SL ) ; class( SL )
summary( LL )


###################################################
### code chunk number 10: DMDK-s.rnw:178-187
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
### code chunk number 11: DMDK-s.rnw:192-195
###################################################
names( SLr )
SLr <- merge( SL, M.dk[,c("sex","Am","Pm","rate")] )
dim( SL )
dim( SLr )


###################################################
### code chunk number 12: DMDK-s.rnw:207-222
###################################################
SLr$E <- SLr$lex.dur * SLr$rate / 1000
stat.table( list( sex, Age = cut(A,c(0,3:9*10,120)) ),
            list( D = sum(lex.Xst=="Dead"), 
                  Y = sum(lex.dur), 
                  E = sum(E), 
                SMR = ratio(lex.Xst=="Dead",E) ), 
             margin = TRUE,
               data = SLr )


###################################################
### code chunk number 13: DMDK-s.rnw:234-238
###################################################
msmr <- glm( (lex.Xst=="Dead") ~ sex - 1 + offset(log(E)),
             family = poisson,
             data = subset(SLr,E>0) )
ci.exp( msmr )


###################################################
### code chunk number 14: DMDK-s.rnw:245-246
###################################################
round( ci.exp( msmr, ctr.mat=rbind(M=c(1,0),W=c(0,1),'M/F'=c(1,-1)) ), 2 )


###################################################
### code chunk number 15: DMDK-s.rnw:260-266
###################################################
r.m <- gam( (lex.Xst=="Dead") ~ s(A,k=20) + offset( log(lex.dur) ),
            family = poisson,
              data = subset( SL, sex=="M" ) )
r.f <- update( r.m, data = subset( SL, sex=="F" ) )
gam.check( r.m )
gam.check( r.f )


###################################################
### code chunk number 16: DMDK-s.rnw:295-300
###################################################
nd <-  data.frame( A = seq(20,90,0.5),
             lex.dur = 1000)
p.m <- ci.pred( r.m, newdata = nd )
p.f <- ci.pred( r.f, newdata = nd )
str( p.m )


###################################################
### code chunk number 17: a-rates
###################################################
matplot( nd$A, cbind(p.m,p.f),
         type="l", col=rep(c("blue","red"),each=3), lwd=c(3,1,1), lty=1,
         log="y", xlab="Age", ylab="Mortality of DM ptt per 1000 PY")


###################################################
### code chunk number 18: A-rates
###################################################
matshade( nd$A, cbind(p.m,p.f), plot=TRUE,
          col=c("blue","red"), lty=1,
          log="y", xlab="Age", ylab="Mortality of DM ptt per 1000 PY")


###################################################
### code chunk number 19: DMDK-s.rnw:335-345
###################################################
Mcr <- gam( (lex.Xst=="Dead") ~ s(   A, bs="cr", k=10 ) +
                                s(   P, bs="cr", k=10 ) +
                                s( dur, bs="cr", k=10 ) + offset(log(lex.dur)),
            family = poisson,
              data = subset( SL, sex=="M" ) )
summary( Mcr )
Fcr <- update( Mcr, data = subset( SL, sex=="F" ) )
summary( Fcr )
gam.check( Mcr )
gam.check( Fcr )


###################################################
### code chunk number 20: plgam-default
###################################################
par( mfrow=c(2,3) )
plot( Mcr, ylim=c(-3,3), col="blue" )
plot( Fcr, ylim=c(-3,3), col="red" )

###################################################
### code chunk number 22: DMDK-s.rnw:388-394
###################################################
pts <- seq(0,17,0.5)
nd <- data.frame( A =   50+pts,
                  P = 1995+pts,
                dur =      pts,
            lex.dur = 1000 )
head( cbind( nd$A, ci.pred( Mcr, newdata=nd ) ) )


###################################################
### code chunk number 23: rates
###################################################
pts <- seq(0,12,0.1)
plot( NA, xlim = c(50,85), ylim = c(5,400), log="y",
          xlab="Age", ylab="Mortality rate for DM patients",
          las=1, bty="n" )
for( ip in c(1995,2005) )
for( ia in c(50,60,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts,
            lex.dur=1000 )
matshade( nd$A, ci.pred( Mcr, nd ), col="blue" )
matshade( nd$A, ci.pred( Fcr, nd ), col="red" )
   }
abline( v=c(50,60,70) )

###################################################
### code chunk number 24: rates5
###################################################
Mcr <- gam( (lex.Xst=="Dead") ~ s(   A, bs="cr", k=10 ) +
                                s(   P, bs="cr", k=10 ) +
                                s( dur, bs="cr", k=5 ) +
                                offset( log(lex.dur) ),
            family = poisson,
              data = subset(SL,sex=="M") )
Fcr <- update( Mcr, 
              data = subset(SL,sex=="F") )

###################################################
### code chunk number 25: rates-5
###################################################
plot( NA, xlim = c(50,80), ylim = c(0.9,100), log="y",
          xlab="Age", ylab="Mortality rate for DM patients" )
abline( v = c(50,60,70), col=gray(0.8) )
# for( ip in c(1995,2005) )
ip <- 2005
for( ia in c(50,60,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts,
            lex.dur=1000 )
matshade( nd$A, rm <- ci.pred( Mcr, nd ), col="blue", lwd=2 )
matshade( nd$A, rf <- ci.pred( Fcr, nd ), col="red" , lwd=2 )
matshade( nd$A, ci.ratio( rm, rf ), lwd=2 )
   } 
abline( h=1, lty="55" )

### STOP HERE #####################################

###################################################
### code chunk number 26: SMReff
###################################################
SLr <- subset( SLr, E>0 )
Msmr <- gam( (lex.Xst=="Dead") ~ s(   A, bs="cr", k=10 ) +
                                 s(   P, bs="cr", k=10 ) +
                                 s( dur, bs="cr", k=5 ),
              offset = log( E ),
              family = poisson,
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
plot( NA, xlim = c(50,80), ylim = c(0.8,5), log="y",
          xlab="Age", ylab="SMR relative to total population" )
abline( v = c(50,55,60,65,70), col=gray(0.8) )
# for( ip in c(1995,2005) )
ip <- 2005
for( ia in c(50,55,60,65,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts,
                  E=1 )
matshade( nd$A, rm <- ci.pred( Msmr, nd ), col="blue", lwd=2 )
matshade( nd$A, rf <- ci.pred( Fsmr, nd ), col="red" , lwd=2 )
matshade( nd$A, ci.ratio( rm, rf ), lwd=2, col=gray(0.5) )
   } 
abline( h=1, lty="55" )


###################################################
### code chunk number 28: DMDK-s.rnw:555-565
###################################################
Asmr <- gam( (lex.Xst=="Dead") ~ sex +
                                 sex:I(A-60) + 
                                 sex:I(P-2000) +
                                 s( dur, k=5 ) +
                                 offset( log(E) ),
             family = poisson,
               data = SLr )
summary( Asmr )
gam.check( Asmr )
round( ( ci.exp(Asmr,subset="sex")-1 )*100, 1 )


###################################################
### code chunk number 29: SMRsl
###################################################
plot( NA, xlim = c(50,80), ylim = c(0.8,5), log="y",
          xlab="Age", ylab="SMR relative to total population" )
abline( v = c(50,55,60,65,70), col=gray(0.8) )
# for( ip in c(1995,2005) )
ip <- 2005
for( ia in c(50,55,60,65,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts,
                  E=1 )
matshade( nd$A, rm <- ci.pred( Asmr, cbind(nd,sex="M") ), col="blue", lwd=2 )
matshade( nd$A, rf <- ci.pred( Asmr, cbind(nd,sex="F") ), col="red" , lwd=2 )
matshade( nd$A, ci.ratio( rm, rf ), lwd=2, col=gray(0.5) )
   } 
abline( h=1, lty="55" )


###################################################
### code chunk number 30: DMDK-s.rnw:607-608
###################################################
dim( Ns(SLr$dur, knots=c(0,1,4,8) ) )


###################################################
### code chunk number 31: DMDK-s.rnw:611-617
###################################################
SMRglm <- glm( (lex.Xst=="Dead") ~ I(A-60) + 
                                   I(P-2000) + 
                                   Ns( dur, knots=c(0,1,4,8) ) +
                                   offset( log(E) ),
               family = poisson,
                 data = SLr )


###################################################
### code chunk number 32: SMRsp
###################################################
plot( NA, xlim = c(50,80), ylim = c(0.8,5), log="y",
          xlab="Age", ylab="SMR relative to total population" )
abline( v = c(50,55,60,65,70), col=gray(0.8) )
# for( ip in c(1995,2005) )
ip <- 2005
for( ia in c(50,55,60,65,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts,
                  E=1 )
matshade( nd$A, ci.pred( SMRglm, nd ), lwd=2 )
   } 
abline( h=1, lty="55" )


