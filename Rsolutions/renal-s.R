### R code from vignette source '/home/runner/work/SPE/SPE/build/renal-s.rnw'

###################################################
### code chunk number 1: renal-s.rnw:3-7
###################################################
options( width=90,
         prompt=" ", continue=" ",
         SweaveHooks=list( fig=function()
         par(mar=c(3,3,1,1),mgp=c(3,1,0)/1.6,las=1,bty="n") ) )


###################################################
### code chunk number 2: renal-s.rnw:19-27
###################################################
library( Epi ) 
library( foreign )
clear()
renal <- read.dta(
"https://raw.githubusercontent.com/SPE-R/SPE/master/pracs/data/renal.dta")
# renal <- read.dta( "./data/renal.dta" )
renal$sex <- factor( renal$sex, labels=c("M","F") )
head( renal )


###################################################
### code chunk number 3: renal-s.rnw:40-48
###################################################
Lr <- Lexis( entry = list( per = doe,
                           age = doe-dob,
                           tfi = 0 ),
              exit = list( per = dox ),
       exit.status = factor( event>0, labels=c("NRA","ESRD") ),
              data = renal )
str( Lr )
summary( Lr )


###################################################
### code chunk number 4: Lexis-ups
###################################################
plot( Lr, col="black", lwd=3 )
subset( Lr, age<0 )


###################################################
### code chunk number 5: Lexis-def
###################################################
Lr <- transform( Lr, dob = ifelse( dob>2000, dob-100, dob ),
                     age = ifelse( dob>2000, age+100, age ) )
subset( Lr, id==586 )
plot( Lr, col="black", lwd=3 )


###################################################
### code chunk number 6: renal-s.rnw:81-87
###################################################
pdf( "./graph/renal-Lexis-fancy.pdf", height=80/9+1, width=40/9+1 )
par( mai=c(3,3,1,1)/4, mgp=c(3,1,0)/1.6 )
plot( Lr, 1:2, col=c("blue","red")[Lr$sex], lwd=3, grid=0:20*5,
      xlab="Calendar time", ylab="Age",
      xlim=c(1970,2010), ylim=c(0,80), xaxs="i", yaxs="i", las=1 )
dev.off()


###################################################
### code chunk number 7: renal-s.rnw:108-112
###################################################
library( survival )
mc <- coxph( Surv( lex.dur, lex.Xst=="ESRD" ) ~
             I(age/10) + sex, data=Lr )
summary( mc )


###################################################
### code chunk number 8: renal-s.rnw:123-125
###################################################
mc <- coxph.Lexis( Lr, formula = tfi ~ I(age/10) + sex )
summary( mc )


###################################################
### code chunk number 9: renal-s.rnw:140-146
###################################################
Lc <- cutLexis( Lr, cut = Lr$dor, # where to cut follow up
              timescale = "per",  # what timescale are we referring to
              new.state = "Rem",  # name of the new state
            split.state = TRUE,   # state subdivided by origin of transition
       precursor.states = "NRA" ) # which states are less severe
summary( Lc )


###################################################
### code chunk number 10: renal-s.rnw:153-155
###################################################
subset( Lr, lex.id %in% c(2:4,21) )[,c(1:9,12)]
subset( Lc, lex.id %in% c(2:4,21) )[,c(1:9,12)]


###################################################
### code chunk number 11: Lc-boxes
###################################################
boxes( Relevel(Lc,c(1,2,4,3)), boxpos=TRUE, scale.R=100, show.BE=TRUE )


###################################################
### code chunk number 12: Lexis-rem
###################################################
par( mai=c(3,3,1,1)/4, mgp=c(3,1,0)/1.6 )
plot( Lc, col=c("red","forestgreen")[Lc$lex.Cst],
      xlab="Calendar time", ylab="Age",
      lwd=3, grid=0:20*5, xlim=c(1970,2010), ylim=c(0,80), xaxs="i", yaxs="i", las=1 )
points( Lc, pch=c(NA,NA,16,16)[Lc$lex.Xst],
            col=c("red","forestgreen","transparent")[Lc$lex.Cst])
points( Lc, pch=c(NA,NA,1,1)[Lc$lex.Xst],
            col="black", lwd=2 )


###################################################
### code chunk number 13: renal-s.rnw:202-212
###################################################
( EP <- levels(Lc)[3:4] )
m1 <- coxph( Surv( tfi,                  # from
                   tfi+lex.dur,          # to
                   lex.Xst %in% EP ) ~   # event
             sex + I((doe-dob-50)/10) +  # fixed covariates
             (lex.Cst=="Rem"),           # time-dependent variable 
             data = Lc )
m1 <- coxph.Lexis( Lc, formula= tfi ~ sex + I((doe-dob-50)/10) +
                                      (lex.Cst=="Rem") )     
summary( m1 )


###################################################
### code chunk number 14: renal-s.rnw:227-233
###################################################
mt <- coxph.Lexis( Lc, formula = 
                       tfi ~ sex + I((doe-dob-50)/10) + (lex.Cst=="Rem") )
ma <- coxph.Lexis( Lc, formula = 
                       age ~ sex + I(tfi/10) + (lex.Cst=="Rem") )
cbind( ci.exp(m1), ci.exp(mt) )
ci.exp( ma )


###################################################
### code chunk number 15: renal-s.rnw:242-243
###################################################
cox.zph( m1 )


###################################################
### code chunk number 16: renal-s.rnw:259-262
###################################################
sLc <- splitLexis( Lc, "tfi", breaks=seq(0,30,1/12) )
summary( Lc, scale=100 )
summary(sLc, scale=100 )


###################################################
### code chunk number 17: renal-s.rnw:267-270
###################################################
library( popEpi )
sLc <- splitMulti( Lc, tfi=seq(0,30,1/12) )
summary(sLc, scale=100 )


###################################################
### code chunk number 18: renal-s.rnw:281-287
###################################################
library( splines )
mp <- glm( cbind(lex.Xst %in% EP,lex.dur) ~ Ns( tfi, knots=c(0,2,5,9,14) ) +
                            sex + I((doe-dob-40)/10) + I(lex.Cst=="Rem"),
           family = poisreg, 
             data = sLc )
ci.exp( mp )


###################################################
### code chunk number 19: renal-s.rnw:293-296
###################################################
mpx <- glm.Lexis( sLc, formula=~ Ns( tfi, knots=c(0,2,5,10) ) +
                                 sex + I((doe-dob-40)/10) + I(lex.Cst=="Rem") )
ci.exp( mpx )


###################################################
### code chunk number 20: renal-s.rnw:304-310
###################################################
library( mgcv )
mx <- gam.Lexis( sLc, formula=~ s( tfi, k=10 ) +
                                sex + I((doe-dob-40)/10) + I(lex.Cst=="Rem") )
ci.exp( mx )
round( ci.exp( mp, subset=c("Cst","doe","sex") ), 3 )
round( ci.exp( mx, subset=c("Cst","doe","sex") ), 3 )


###################################################
### code chunk number 21: renal-s.rnw:317-320
###################################################
ci.exp( mx, subset=c("sex","dob","Cst"), pval=TRUE )
ci.exp( m1 )
round( ci.exp( mp, subset=c("sex","dob","Cst") ) / ci.exp( m1 ), 3 )


###################################################
### code chunk number 22: tfi-gam
###################################################
plot( mx )


###################################################
### code chunk number 23: pred
###################################################
nd <- data.frame( tfi = seq(0,20,.1),
                  sex = "M",
                  doe = 1990,
                  dob = 1940,
              lex.Cst = "NRA" )
str( nd )
matshade( nd$tfi, cbind( ci.pred( mp, newdata=nd ),
                         ci.pred( mx, newdata=nd ) )*100, plot=TRUE,
          type="l", lwd=3:4, col=c("black","forestgreen"),
          log="y", xlab="Time since entry (years)",
                   ylab="ESRD rate (per 100 PY) for 50 year old man" )
rug(c(0,2,5,9,14))


###################################################
### code chunk number 24: renal-s.rnw:385-386
###################################################
sLc <- transform( sLc, tfr = pmax( (per-dor)/10, 0, na.rm=TRUE ) )


###################################################
### code chunk number 25: time-since-rem
###################################################
mPx <- gam.Lexis( sLc, formula= ~ s( tfi, k=10 ) +
                       factor(sex) + I((doe-dob-40)/10) +  
                       I(lex.Cst=="Rem") + tfr )
round( ci.exp( mPx ), 3 )


###################################################
### code chunk number 26: rem-inc-mgcv
###################################################
mr <- gam( cbind(lex.Xst=="Rem",lex.dur) ~ s( tfi, k=10 ) + sex,
           family = poisreg,
             data = subset( sLc, lex.Cst=="NRA" ) )


###################################################
### code chunk number 27: renal-s.rnw:431-433
###################################################
mr <- gam.Lexis( sLc, to="Rem", formula= ~ s( tfi, k=10 ) + sex )
ci.exp( mr, pval=TRUE )


###################################################
### code chunk number 28: renal-s.rnw:450-466
###################################################
inL <- sLc[1,1:11]
timeSince(inL)
inL[1,"lex.id"] <- 1
inL[1,"per"] <- 2000
inL[1,"age"] <- 50
inL[1,"tfi"] <- 0
inL[1,"lex.dur"] <- NA
inL[1,"lex.Cst"] <- "NRA"
inL[1,"lex.Xst"] <- NA
inL[1,"sex"] <- "M"
inL[1,"doe"] <- 2000
inL[1,"dob"] <- 1950
inL <- inL[c(1,1),]
inL[2,"sex"] <- "F"
inL
str( inL )


###################################################
### code chunk number 29: renal-s.rnw:475-478
###################################################
Tr <- list( "NRA" = list( "Rem"  = mr,
                          "ESRD" = mx ),
            "Rem" = list( "ESRD(Rem)" = mx ) )


###################################################
### code chunk number 30: 10000-sim
###################################################
system.time( sM <- simLexis( Tr, inL, N=5000 ) )
summary( sM, by="sex" )


###################################################
### code chunk number 31: nState
###################################################
nStm <- nState( subset(sM,sex=="M"), at=seq(0,10,0.1), from=50, time.scale="age" )
nStf <- nState( subset(sM,sex=="F"), at=seq(0,10,0.1), from=50, time.scale="age" )
head( nStf )


###################################################
### code chunk number 32: pState
###################################################
prm <- c(2,1,3,4)
colnames( nStm )[prm]
ppm <- pState( nStm, perm=prm )
ppf <- pState( nStf, perm=prm )
head( ppf )
tail( ppf )


###################################################
### code chunk number 33: plot-pp
###################################################
plot( ppf )


###################################################
### code chunk number 34: new-pState
###################################################
clr <- c("forestgreen","orange")
clr <- c(clr,adjustcolor(rev(clr),alpha=0.7))
par( mfrow=c(1,2), mar=c(3,1.5,1,1), oma=c(0,2,0,0), las=1 )
plot( ppm, col=clr )
lines( as.numeric(rownames(ppm)), ppm[,"NRA"], lwd=4 )
mtext( "Probability", side=2, las=0, outer=T, line=0.5 )
mtext( "Men", side=3 )
axis( side=4, at=0:10/10 )
axis( side=4, at=0:20/20 , labels=NA, tck=-0.02 )
axis( side=4, at=1:99/100, labels=NA, tck=-0.01 )

plot( ppf, col=clr, xlim=c(60,50), yaxt="n", ylab="" )
lines( as.numeric(rownames(ppf)), ppf[,"NRA"], lwd=4 )
mtext( "Women", side=3 )
axis( side=2, at=0:10/10 , labels=NA )
axis( side=2, at=0:20/20 , labels=NA, tck=-0.02 )
axis( side=2, at=1:99/100, labels=NA, tck=-0.01 )


