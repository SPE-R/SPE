options(width=75)
library( Epi )
library( popEpi )
library( mgcv )
data( DMlate )
head( DMlate )

LL <- Lexis( entry = list( A = dodm-dobth,
                           P = dodm,
                         dur = 0 ),
              exit = list( P = dox ),
       exit.status = 1*!is.na(dodth),
              data = DMlate )
summary( LL )
head( LL )

system.time( SL <- splitLexis( LL, breaks=seq(0,125,1/2), time.scale="A" ) )
summary( SL ) ; class( SL )
system.time( SL <- splitMulti( LL, A=seq(0,125,1/2) ) )
summary( SL ) ; class( SL )
summary( LL )

# Fit mortality models
r.m <- gam( cbind(lex.Xst,lex.dur) ~ s(A,k=20),
            family = poisreg,
              data = subset( SL, sex=="M" ) )
r.f <- update( r.m, data = subset( SL, sex=="F" ) )
gam.check( r.m )
gam.check( r.f )

# Predicted mortality rates
nd <-  data.frame( A = seq(20,90,0.5) )
p.m <- ci.pred( r.m, newdata = nd ) * 1000
p.f <- ci.pred( r.f, newdata = nd ) * 1000
head( p.m )
matshade( nd$A, cbind(p.m,p.f), plot=TRUE,
          col=c("blue","red"), lwd=3,
          log="y", xlab="Age", ylab="Mortality of DM ptt per 1000 PY")


# Include calendar time and duration
Mcr <- gam( cbind(lex.Xst,lex.dur) ~ s(   A, bs="cr", k=10 ) +
                                     s(   P, bs="cr", k=10 ) +
                                     s( dur, bs="cr", k=10 ),
            family = poisreg,
              data = subset( SL, sex=="M" ) )
Fcr <- update( Mcr, data = subset( SL, sex=="F" ) )
# Shapes of effects
par( mfrow=c(2,3) )
plot( Mcr, ylim=c(-3,3), col="blue", lwd=2 )
plot( Fcr, ylim=c(-3,3), col="red" , lwd=2 )

# Extra timescales contribute?
anova( Mcr, r.m, test="Chisq" )
anova( Fcr, r.f, test="Chisq" )

# Prediction for a 50 year old man diagnosed 1995
pts <- seq(0,12,0.2)
nd <- data.frame( A =   50+pts,
                  P = 1995+pts,
                dur =      pts )
head( cbind( nd[,c("A","P","dur")], ci.pred( Mcr, newdata=nd )*1000 ) )

# Empty plot
plot( NA, xlim = c(50,85), ylim = c(5,400), log="y",
          xlab="Age", ylab="Mortality rate for DM patients per 1000 PY" )
matshade( nd$A, ci.pred( Mcr, nd )*1000, col="blue" )
matshade( nd$A, ci.pred( Fcr, nd )*1000, col="red" )

# Lines for 2 dates, 3 ages and m/W
for( ip in c(1995,2005) )
for( ia in c(50,60,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip+pts,
                dur=   pts )
matshade( nd$A, ci.pred( Mcr, nd )*1000, col="blue" )
matshade( nd$A, ci.pred( Fcr, nd )*1000, col="red" )
   }

# Heavier smooting of diabets duration
Mcr <- gam( cbind(lex.Xst,lex.dur) ~ s(   A, bs="cr", k=10 ) +
                                     s(   P, bs="cr", k=10 ) +
                                     s( dur, bs="cr", k=5 ),
                  family = poisreg, 
                    data = subset(SL,sex=="M") )
Fcr <- update( Mcr, data = subset(SL,sex=="F") )
gam.check( Mcr )
gam.check( Fcr )

# Plot it all again but only for 1995 date of dx
plot( NA, xlim = c(50,80), ylim = c(0.9,100), log="y",
          xlab="Age", ylab="Mortality rate for DM patients 2005" )
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
   } 

########### SMR #################

# Midpoints of intervals in variables Am, Pm
SL$Am <- floor( SL$A+0.25 )
SL$Pm <- floor( SL$P+0.25 )

# Population mortality
data( M.dk )
# Renale population rate intervl to Am, Pm
M.dk <- transform( M.dk, Am = A,
                         Pm = P,
                        sex = factor( sex, labels=c("M","F") ) )
str( M.dk )

# attach the rate to to the SL data frame
SLr <- merge( SL, M.dk[,c("sex","Am","Pm","rate")] )
dim( SL )
dim( SLr )

# Expected numbers (rate in M.dk is mortality per 1000 PY)
SLr$E <- SLr$lex.dur * SLr$rate / 1000
stat.table( sex, 
            list( D = sum(lex.Xst), 
                  Y = sum(lex.dur), 
                  E = sum(E), 
                SMR = ratio(lex.Xst,E) ), 
            data = SLr,
            margin = TRUE ) 
# Model the SMR
msmr <- glm( cbind(lex.Xst,E) ~ sex - 1,
             family = poisreg,
               data = subset(SLr,E>0) )
ci.exp( msmr )

# Same model as for mortality
SLr <- subset( SLr, E>0 )
Msmr <- gam( cbind(lex.Xst,E) ~ s(   A, bs="cr", k=10 ) +
                                s(   P, bs="cr", k=10 ) +
                                s( dur, bs="cr", k=5 ),
                    family = poisreg,
                      data = subset( SLr, sex=="M" ) )
Fsmr <- update( Msmr, data = subset( SLr, sex=="F" ) )
# Rough overview of effcts
par( mfrow=c(2,3) )
plot( Msmr, ylim=c(-1,2), col="blue", lwd=2 )
plot( Fsmr, ylim=c(-1,2), col="red" , lwd=2 )

# Predicted SMR by all timescales
par( mfrow=c(1,1) )
plot( NA, xlim = c(50,82), ylim = c(0.5,5), log="y",
          xlab="Age", ylab="SMR relative to total population (dx 1998)" )
abline( v = c(50,55,60,65,70), col=gray(0.8) )
     ip <- 1998
for( ia in c(50,55,60,65,70) )
   {
nd <- data.frame( A=ia+pts,
                  P=ip, #+pts,
                dur=   pts )
matshade( nd$A, rm <- ci.pred( Msmr, nd ), col="blue", lwd=2 )
matshade( nd$A, rf <- ci.pred( Fsmr, nd ), col="red" , lwd=2 )
matshade( nd$A, ci.ratio( rm, rf ), lwd=2, col=gray(0.5) )
   } 
abline( h=1, lty="55" )

# Same duraion effect for men and women, (log)liner effect of age/per
Asmr <- gam( cbind(lex.Xst,E) ~ sex +
                                sex:I(A-60) + 
                                sex:I(P-2000) +
                                s( dur, k=5 ),
             family = poisreg,
               data = SLr )
gam.check( Asmr )
round( ( ci.exp(Asmr,subset="sex")-1 )*100, 1 )

# SMR for persons dx 1998
plot( NA, xlim = c(50,80), ylim = c(0.5,5), log="y",
          xlab="Age", ylab="SMR relative to total population" )
abline( v = c(50,55,60,65,70), col=gray(0.8) )
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

# Natural splines with arbitrary knots for duration, commom for M & W
dim( Ns(SLr$dur, knots=c(0,1,4,8) ) )
SMRglm <- glm( cbind(lex.Xst,E) ~ I(A-60) + 
                                  I(P-2000) + 
                                  Ns( dur, knots=c(0,1,4,8) ),
               family = poisreg,
                 data = SLr )
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


