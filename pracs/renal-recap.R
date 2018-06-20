options( width=75 )
par( mar=c(3,3,1,1), mgp=c(3,1,0)/1.6, las=1, bty="n" )

###################################################
library( Epi ) ; clear()
library( foreign )
renal <- read.dta( "http://BendixCarstensen.com/SPE/data/renal.dta" )
renal <- read.dta( "renal.dta" )
renal$sex <- factor( renal$sex, labels=c("M","F") )
head( renal )

###################################################
Lr <- Lexis( entry = list( per=doe,
                           age=doe-dob,
                           tfi=0 ),
              exit = list( per=dox ),
       exit.status = factor( event>0, labels=c("NRA","ESRD") ),
              data = renal )
str( Lr )
summary( Lr )

###################################################
plot( Lr, col="black", lwd=3 )
subset( Lr, age<0 )

###################################################
Lr <- transform( Lr, dob = ifelse( dob>2000, dob-100, dob ),
                     age = ifelse( dob>2000, age+100, age ) )
subset( Lr, id==586 )
plot( Lr, col="black", lwd=3 )

###################################################
library( survival )
mc <- coxph( Surv( lex.dur, lex.Xst=="ESRD" ) ~
             I(age/10) + sex, data=Lr )
summary( mc )

###################################################
Lc <- cutLexis( Lr,          # the Lexis object
               cut = Lr$dor, # where to cut follow up
         timescale = "per",  # what timescale are we referring to
         new.state = "Rem",  # name of the new state
       split.state = TRUE,   # different states depending on previous state
  precursor.states = "NRA" ) # which states are less severe than the new
summary( Lc )

###################################################
subset( Lr, lex.id %in% c(2:4,21) )[,c(1:9,12)]
subset( Lc, lex.id %in% c(2:4,21) )[,c(1:9,12)]

###################################################
boxes( Lc, boxpos=TRUE, scale.R=100, show.BE=TRUE, hm=1.5, wm=1.5 )
par( mfrow=c(1,1) )
boxes( Relevel(Lc,c(1,2,4,3)), 
       boxpos=TRUE, scale.R=100, show.BE=TRUE, hm=1.5, wm=1.5 )

###################################################
par( mai=c(3,3,1,1)/4, mgp=c(3,1,0)/1.6 )
plot( Lc, col=c("red","limegreen")[Lc$lex.Cst],
      xlab="Calendar time", ylab="Age",
      lwd=3, grid=0:20*5, xlim=c(1970,2010), ylim=c(0,80), xaxs="i", yaxs="i", las=1 )
points( Lc, pch=c(NA,NA,16,16)[Lc$lex.Xst],
            col=c("red","limegreen","transparent")[Lc$lex.Cst])
points( Lc, pch=c(NA,NA,1,1)[Lc$lex.Xst],
            col="black", lwd=2 )

###################################################
( EP <- levels(Lc)[3:4] )
m1 <- coxph( Surv( tfi,                  # from
                   tfi+lex.dur,          # to
                   lex.Xst %in% EP ) ~   # event
             sex + I((doe-dob-50)/10) + 
             (lex.Cst=="Rem"),           # time-dependent variable 
             data = Lc )
summary( m1 )

###################################################
sLc <- splitLexis( Lc, "tfi", breaks=seq(0,30,1/12) )
options( "popEpi.datatable" = FALSE ) # Make sure we get at data frame
                                      # from splitMulti
sLc <- splitMulti( Lc, tfi=seq(0,30,1/12) )
summary( Lc, scale=100 )
summary(sLc, scale=100 )

###################################################
### code chunk number 16: renal-s.rnw:286-294
###################################################
library( mgcv )
mx <- gam( (lex.Xst %in% EP) ~ s( tfi, k=10 ) +
           sex + I((doe-dob-40)/10) + I(lex.Cst=="Rem"),
           offset = log(lex.dur),
           family = poisson, 
             data = sLc )

###################################################
round( ci.exp( mx, subset=c("sex","dob","Cst"), pval=TRUE ), 3 )
round( ci.exp( m1 ), 3 )
round( ci.exp( mx, subset=c("sex","dob","Cst") ) / ci.exp( m1 ), 3 )

###################################################
nd <- data.frame( tfi = seq(0,20,.1),
                  sex = "M",
                  doe = 1990,
                  dob = 1940,
              lex.Cst = "NRA",
              lex.dur = 1 )
matshade( nd$tfi, ci.pred( mx, newdata=nd )*100, plot=TRUE,
          type="l", lty=1, lwd=c(4,1,1), col=rep(c("gray","black"), each=3),
          log="y", xlab="Time since entry (years)",
                   ylab="ESRD rate (per 100 PY) for 50 year man" )

###################################################
## Define time from remission in units of decades:
sLc <- transform( sLc, tfr = pmax( (per-dor)/10, 0, na.rm=TRUE ) )

###################################################
mPx <- gam( lex.Xst %in% EP ~ s( tfi, k=10 ) +
                   factor(sex) + I((doe-dob-40)/10) +  
                   I(lex.Cst=="Rem") + tfr,
            offset = log(lex.dur/100),
            family = poisson, 
              data = sLc )
round( ci.exp( mPx ), 3 )

###################################################
## Incidence rate of Remission
mr <- gam( lex.Xst=="Rem" ~ s( tfi, k=10 ) + sex,
           offset = log(lex.dur),
           family = poisson,
             data = subset( sLc, lex.Cst=="NRA" ) )
ci.exp( mr, pval=TRUE )

###################################################
inL <- subset( sLc, select=1:11 )[NULL,]
str( inL )
timeScales( inL )
inL[1,"lex.id"] <- 1
inL[1,"per"] <- 2000
inL[1,"age"] <- 50
inL[1,"tfi"] <- 0
inL[1,"lex.Cst"] <- "NRA"
inL[1,"lex.Xst"] <- NA
inL[1,"lex.dur"] <- NA
inL[1,"sex"] <- "M"
inL[1,"doe"] <- 2000
inL[1,"dob"] <- 1950
inL <- rbind( inL, inL )
inL[2,"sex"] <- "F"
inL
str( inL )

###################################################
boxes( Relevel(Lc,c(1,2,4,3)), 
       boxpos=TRUE, scale.R=100, show.BE=TRUE, hm=1.5, wm=1.5 )
Tr <- list( "NRA" = list( "Rem"  = mr,
                          "ESRD" = mx ),
            "Rem" = list( "ESRD(Rem)" = mx ) )

###################################################
system.time( sM <- simLexis( Tr, inL, N=500 ) )
system.time( sM <- simLexis( Tr, inL, N=1000 ) )
summary( sM, by="sex" )

###################################################
nStm <- nState( subset(sM,sex=="M"), at=seq(0,10,0.1), from=50, time.scale="age" )
nStf <- nState( subset(sM,sex=="F"), at=seq(0,10,0.1), from=50, time.scale="age" )
head( nStf )

###################################################
ppm <- pState( nStm, perm=c(1,2,4,3) )
ppf <- pState( nStf, perm=c(1,2,4,3) )
head( ppf )

###################################################
plot( ppf )

###################################################
par( mfrow=c(1,2), las=1 )
clr <- c("red","limegreen","forestgreen","#991111")

plot( ppm, col=clr )
lines( as.numeric(rownames(ppm)), ppm[,"Rem"], lwd=4 )
text( 59.5, 0.95, "Men", adj=1, col="white", font=2, cex=1.2 )
axis( side=4, at=0:10/10 , labels=NA )
axis( side=4, at=0:20/20 , labels=NA, tck=-0.02 )
axis( side=4, at=1:99/100, labels=NA, tck=-0.01 )

plot( ppf, col=clr, xlim=c(60,50) )
lines( as.numeric(rownames(ppf)), ppf[,"Rem"], lwd=4 )
text( 59.5, 0.95, "Women", adj=0, col="white", font=2, cex=1.2 )
axis( side=2, at=0:10/10 )
axis( side=2, at=1:20/20 , labels=NA, tck=-0.02 )
axis( side=2, at=1:99/100, labels=NA, tck=-0.01 )


