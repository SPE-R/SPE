###################################################
options( width=94 )
library( Epi )
library( mgcv )
data( DMlate )
str( DMlate )
head( DMlate )
summary( DMlate )

##############################################################################################
LL <- Lexis( entry = list( A = dodm-dobth,
                           P = dodm,
                         dur = 0 ),
              exit = list( P = dox ),
       exit.status = factor( !is.na(dodth),
                             labels=c("Alive","Dead") ),
              data = DMlate )

###################################################
LL <- Lexis( entry = list( A = dodm-dobth,
                           P = dodm,
                         dur = 0 ),
              exit = list( P = dox ),
       exit.status = factor( !is.na(dodth),
                             labels=c("Alive","Dead") ),
              data = DMlate,
              keep = TRUE )

###################################################
attr( LL, 'dropped' )

###################################################
summary( LL )
head( LL )

###################################################
stat.table( sex,
            list( D=sum( lex.Xst=="Dead" ),
                  Y=sum( lex.dur ),
               rate=ratio( lex.Xst=="Dead", lex.dur, 1000 ) ),
            data=LL )

###################################################
SL <- splitLexis( LL, breaks=seq(0,125,1/2), time.scale="A" )
summary( SL )
summary( LL )

###################################################
library( splines )
r.m <- glm( (lex.Xst=="Dead") ~ ns( A, df=10 ),
            offset = log( lex.dur ),
            family = poisson,
              data = subset( SL, sex=="M" ) )
r.f <- update( r.m, data = subset( SL, sex=="F" ) )

###################################################
nd <-  data.frame( A = seq(10,90,0.5),
             lex.dur = 1000 )
p.m <- ci.pred( r.m, newdata = nd )
p.f <- ci.pred( r.f, newdata = nd )
str( p.m )
head( p.m )

###################################################
matplot( nd$A, cbind(p.m,p.f),
         type="l", col=rep(c("blue","red"),each=3), lwd=c(3,1,1), lty=1,
         log="y", xlab="Age", ylab="Mortality of DM ptt per 1000 PY")

###################################################
library( mgcv )
s.m <- gam( (lex.Xst=="Dead") ~ s(A,k=20),
            offset = log( lex.dur ),
            family = poisson,
                    data = subset( SL, sex=="M" ) )
s.f <- update( s.m, data = subset( SL, sex=="F" ) )
p.m <- ci.pred( s.m, newdata = nd ) * 1000
p.f <- ci.pred( s.f, newdata = nd ) * 1000

###################################################
matplot( nd$A, cbind(p.m,p.f),
         type="l", col=rep(c("blue","red"),each=3), lwd=c(3,1,1), lty=1,
         log="y", xlab="Age", ylab="Mortality of DM ptt per 1000 PY")

###################################################
pl2 <- function(s.m,s.f) {
 nd <-  data.frame( A = seq(10,90,0.5), lex.dur = 1 )
p.m <- ci.pred( s.m, newdata = nd ) * 1000
p.f <- ci.pred( s.f, newdata = nd ) * 1000
matplot( nd$A, cbind(p.m,p.f), ylim=c(0.1,200),
         type="l", col=rep(c("blue","red"),each=3), lwd=c(3,1,1), lty=1,
         log="y", xlab="Age", ylab="Mortality of DM ptt per 1000 PY")
                         }
pl2( s.m, s.f )
pl2( r.m, r.f )
par( mfrow=c(1,2) )
pl2( s.m, s.f )
pl2( r.m, r.f )

###################################################
Mcr <- gam( (lex.Xst=="Dead") ~ s(   A, k=10 ) +
                                s(   P, k=10 ) +
                                s( dur, k=10 ),
            offset = log( lex.dur/1000 ),
            family = poisson, method="REML",
              data = subset( SL, sex=="M" ) )
summary( Mcr )
gam.check( Mcr )
Fcr <- update( Mcr, data = subset( SL, sex=="F" ) )

###################################################
par( mfrow=c(2,3) )
plot( Mcr, ylim=c(-3,3) )
plot( Fcr, ylim=c(-3,3) )

###################################################
# Simplification
Mcl <- update( Mcr, . ~ A + P + s( dur, k=10 ) )
Fcl <- update( Fcr, . ~ A + P + s( dur, k=10 ) )
anova( Mcr, Mcl, test="Chisq" )
anova( Fcr, Fcl, test="Chisq" )

###################################################
pts <- seq(0,12,0.5)
nd <- data.frame( A =   50+pts,
                  P = 1995+pts,
                dur =      pts,
            lex.dur = 1 )
head( cbind( nd$A, ci.pred( Mcr, newdata=nd ) ) )

###################################################
pts <- seq(0,12,0.1)
nd <- data.frame( A=  50+pts,
                  P=1995+pts,
                dur=     pts,
            lex.dur=1 )
Rpr <- cbind( ci.pred( Mcr, nd ),
              ci.pred( Fcr, nd ) )

###################################################
plot( NA, xlim=c(40,90), ylim=c(0.5,5000), log="y",
          xlab="Age", ylab="Mortality, diagnosed 1995" )
matlines( 50+pts, Rpr,
          type="l", lwd=c(4,1,1), lty=1,
          col=rep( c("blue","red"), each=3 ) )

ml <- function( A, P )
    {
nd <- data.frame( A = A+pts,
                  P = P+pts,
                dur =   pts,
            lex.dur = 1 )
Rpr <- cbind( ci.pred( Mcr, nd ),
              ci.pred( Fcr, nd ) )
matlines( A+pts, Rpr,
          type="l", lwd=c(4,1,1), lty=1,
          col=rep( c("blue","red"), each=3 ) )
    }

##################################################
plot( NA, xlim=c(40,90), ylim=c(0.5,5000), log="y",
          xlab="Age", ylab="Mortality, diagnosed 1995" )
ml( 50, 2000 )
ml( 55, 2000 )
ml( 60, 2000 )
ml( 65, 2000 )
ml( 70, 2000 )
ml( 75, 2000 )

plot( NA, xlim=c(40,90), ylim=c(2,300), log="y", las=1,
          xlab="Age", ylab="Mortality, diagnosis in 2000" )
for( aa in 40:80 ) ml( aa, 2000 )

###################################################
str( SL )
SL$Am <- floor( SL$A+0.25 )
SL$Pm <- floor( SL$P+0.25 )
data( M.dk )
str( M.dk )
M.dk <- transform( M.dk, Am = A,
                         Pm = P,
                        sex = factor( sex, labels=c("M","F") ) )

###################################################
SLr <- merge( SL, M.dk[,c("sex","Am","Pm","rate")] )
dim( SL )
dim( SLr )

###################################################
SLr$E <- SLr$lex.dur * SLr$rate / 1000
stat.table( sex, 
            list( D = sum(lex.Xst=="Dead"), 
                  Y = sum(lex.dur), 
                  E = sum(E), 
                SMR = ratio(lex.Xst=="Dead",E) ), 
            data = SLr,
            margin = TRUE ) 
stat.table( list( sex, Age = floor(pmax(A,39)/10)*10 ), 
            list( D = sum(lex.Xst=="Dead"), 
                  Y = sum(lex.dur), 
                  E = sum(E), 
                SMR = ratio(lex.Xst=="Dead",E) ), 
               data = SLr )


###################################################
### code chunk number 26: SMReff
###################################################
SLr <- subset( SLr, E>0 )
Msm <- gam( (lex.Xst=="Dead") ~ s(   A, k=10 ) +
                                s(   P, k=10 ) +
                                s( dur, k=10 ),
            offset = log( E ),
            family = poisson, method="REML",
                    data = subset( SLr, sex=="M" ) )
Fsm <- update( Msm, data = subset( SLr, sex=="F" ) )
summary( Msm )
summary( Fsm )
par( mfrow=c(2,3) )
plot( Msm, ylim=c(-1,2) )
plot( Fsm, ylim=c(-1,2) )

###################################################
show.mort <-
function( Msm, Fsm )
    {
mpr <- fpr <- NULL
pts <- seq(0,15,0.1)
for( ip in c(1995,2005) )
for( ia in c(50,60,70) )
   { 
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts,
                  E=1 )
mpr <- cbind( mpr, ci.pred( Msm, nd ) )
fpr <- cbind( fpr, ci.pred( Fsm, nd ) )
   }
par( mfrow=c(1,2) )
matplot( cbind(50+pts,60+pts,70+pts)[,rep(1:3,2,each=3)],
         cbind( mpr[,1:9], fpr[,1:9] ), ylim=c(0.5,5),
         log="y", xlab="Age", ylab="SMR, diagnosed 1995",
         type="l", lwd=c(4,1,1), lty=c("solid","18","18"),
         col=rep(c("blue","red"),each=9) )
abline( h= 1)
matplot( cbind(50+pts,60+pts,70+pts)[,rep(1:3,2,each=3)],
         cbind( mpr[,1:9+9], fpr[,1:9+9] ), ylim=c(0.5,5),
         log="y", xlab="Age", ylab="SMR, diagnosed 2005",
         type="l", lwd=c(4,1,1), lty=c("solid","18","18"),
         col=rep(c("blue","red"),each=9) )
abline( h= 1)
    }
show.mort( Msm, Fsm )

###################################################
print(
stat.table( list( dur=floor(dur/2)*2, sex=sex ),
            list( D=sum(lex.Xst=="Dead") ),
            margin = TRUE,
            data = SLr ), digits=0 )

###################################################
( a.kn <- with( subset(SLr,lex.Xst=="Dead"), quantile( A+lex.dur, (1:5-0.5)/5 ) ) )
( p.kn <- with( subset(SLr,lex.Xst=="Dead"), quantile( P+lex.dur, (1:2-0.5)/2 ) ) )
( d.kn <- with( subset(SLr,lex.Xst=="Dead"), quantile( dur+lex.dur, (1:3-0.5)/3 ) ) )
Msg <- glm( (lex.Xst=="Dead") ~ Ns(   A, knots=a.kn ) +
                                Ns(   P, knots=p.kn ) +
                                Ns( dur, knots=d.kn ),
            offset = log( E ),
            family = poisson,
              data = subset( SLr, sex=="M" ) )
Fsg <- update( Msg, data = subset( SLr, sex=="F" ) )
mpg <- fpg <- NULL
pts <- seq(0,15,0.1)
for( ip in c(1995,2005) )
for( ia in c(50,60,70) )
   { 
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts,
                  E=1 )
mpg <- cbind( mpg, ci.pred( Msg, nd ) )
fpg <- cbind( fpg, ci.pred( Fsg, nd ) )
   }
par( mfrow=c(1,2) )
matplot( cbind(50+pts,60+pts,70+pts)[,rep(1:3,2,each=3)],
         cbind( mpg[,1:9], fpg[,1:9] ),
         log="y", xlab="Age", ylab="SMR, diagnosed 1995",
         type="l", lwd=c(4,1,1), lty=1, ylim=c(0.5,5),
         col=rep(c("blue","red"),each=9) )
matlines( cbind(50+pts,60+pts,70+pts)[,rep(1:3,2,each=3)],
         cbind( mpr[,1:9], fpr[,1:9] ),
         type="l", lwd=c(4,1,1), lty="21", lend="butt",
         col=rep(c("blue","red"),each=9) )
abline( h= 1)
matplot( cbind(50+pts,60+pts,70+pts)[,rep(1:3,2,each=3)],
         cbind( mpg[,1:9+9], fpg[,1:9+9] ),
         log="y", xlab="Age", ylab="SMR, diagnosed 2005",
         type="l", lwd=c(4,1,1), lty=1, ylim=c(0.5,5),
         col=rep(c("blue","red"),each=9) )
matlines( cbind(50+pts,60+pts,70+pts)[,rep(1:3,2,each=3)],
         cbind( mpr[,1:9+9], fpr[,1:9+9] ),
         type="l", lwd=c(4,1,1), lty="21", lend="butt",
         col=rep(c("blue","red"),each=9) )
abline( h= 1)

###################################################
llsm <- gam( (lex.Xst=="Dead") ~ I(A-60) + 
                                 I(P-2000) + 
                                 s( dur, k=8 ),
             offset = log( E ),
             family = poisson, method="REML",
               data = subset( SLr, sex=="M" ) )
summary( llsm )
gam.check( llsm )
llsf <- update( llsm, data = subset( SLr, sex=="F" ) )
round( (cbind( ci.exp( llsm, subset="-" ),
               ci.exp( llsf, subset="-" ) )-1)*100, 1 )

###################################################
show.mort( llsm, llsf )
