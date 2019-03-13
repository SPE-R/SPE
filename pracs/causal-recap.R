library(Epi)

### If you really want to use R for creating the graph:
########################################################
par( mar=c(0,0,0,0), cex=2)
plot( NA, bty="n",xlim= c(40,100), ylim=c(0,80), xaxt="n", yaxt="n",
 xlab="", ylab="" ) # create an empty plot with coordinates
b<-0; w=12
bb  <- tbox( "beer", 44, 40, w,w, col.txt="red" ,col.border=b)
ww  <- tbox( "weight", 90, 40, w,w, col.txt="red" ,col.border=b)
ss  <- tbox( "sex", 67, 70, w,w, col.txt="blue" ,col.border=b)
bp  <- tbox( "BP", 67, 10, w,w, col.txt="blue" ,col.border=b)
text( boxarr( bb, ww , col="red", lwd=3 ,gap= 4), "?", col="red", adj=c(0,-0.5) )
boxarr( bb, bp , col="blue", lwd=3 )
boxarr( ww, bp , col="blue", lwd=3 )
boxarr( ss, bb , col="blue", lwd=3 )
boxarr( ss, ww , col="blue", lwd=3 )

############
# remove causal effect
text( boxarr( bb, ww , col="white", lwd=3 ,gap= 4), "?", col="white", adj=c(0,-0.5) )
############

# remove nodes not in X, Y or their ancestors
bp  <- tbox( "BP", 67, 10, w,w, col.txt="white" ,col.border=b)
boxarr( bb, bp , col="white", lwd=3 )
boxarr( ww, bp , col="white", lwd=3 )
############
############
# need to remove sex to separate X and Y
ss  <- tbox( "sex", 67, 70, w,w, col.txt="yellow" ,col.border=b)
boxarr( ss, bb , col="yellow", lwd=3 )
boxarr( ss, ww , col="yellow", lwd=3 )
############

set.seed(426512)
bdat= data.frame(sex = c(rep(0,500),rep(1,500))  )
                   # a data frame with 500 females, 500 males

# The probability of beer-drinking is 0.2 for females and 0.7 for males
bdat$beer <- rbinom(1000,1,0.2+0.5*bdat$sex)

# check the distribution of sex/beer
stat.table(list(sex,beer),list(count(),percent(beer)),data=bdat)

# Men weigh on average 10kg more than women

bdat$weight <- 60 + 10*bdat$sex + rnorm(1000,0,7)

# One kg difference in body weight corresponds in
# average to 0.5mmHg difference in (systolic) blood pressures
# Beer-drinking increases blood pressure by 10mmHg in average.

bdat$bp <- 110 + 0.5*bdat$weight + 10*bdat$beer + rnorm(1000,0,10)

##################

# unadjusted
m1a<-lm(weight~beer, data=bdat)

# adjusted for sex
m2a<-lm(weight~beer+sex, data=bdat)

# adjusted for sex and bp
m3a<-lm(weight~beer+sex+bp, data=bdat)
ci.lin(m1a)
ci.lin(m2a)
ci.lin(m3a)

###############
# Now change the data-generation algorithm so, that in fact beer-drinking
# does increase the body weight by 2kg.

bdat$weight <- 60 + 10*bdat$sex + 2*bdat$beer + rnorm(1000,0,7)
bdat$bp <- 110 + 0.5*bdat$weight + 10*bdat$beer + rnorm(1000,0,10)
##################

m1b<-lm(weight~beer, data=bdat)
m2b<-lm(weight~beer+sex, data=bdat)
m3b<-lm(weight~beer+sex+bp, data=bdat)
ci.lin(m1b)
ci.lin(m2b)
ci.lin(m3b)

##################

# models for blood pressure

### If you really want to use R for creating the graph:
########################################################
par( mar=c(0,0,0,0), cex=2)
plot( NA, bty="n",xlim= c(40,100), ylim=c(0,80), xaxt="n", yaxt="n",
      xlab="", ylab="" ) # create an empty plot with coordinates
b<-0; w=12
bb  <- tbox( "beer", 44, 40, w,w, col.txt="red" ,col.border=b)
ww  <- tbox( "weight", 90, 40, w,w, col.txt="blue" ,col.border=b)
ss  <- tbox( "sex", 67, 70, w,w, col.txt="blue" ,col.border=b)
bp  <- tbox( "BP", 67, 10, w,w, col.txt="red" ,col.border=b)
boxarr( bb, bp , col="red", lwd=3)
boxarr( bb, ww , col=4, lwd=3, gap=4)
boxarr( ww, bp , col=4, lwd=3 )
boxarr( ss, bb , col=4, lwd=3 )
boxarr( ss, ww , col=4, lwd=3 )

############
# remove causal effect
 boxarr( bb, bp , col="white", lwd=3)

############
# removing weight separates beer and BP!
ww  <- tbox( "weight", 90, 40, w,w, col.txt="yellow" ,col.border=b)
boxarr( ww, bp , col="yellow", lwd=3 )
boxarr( ss, ww , col="yellow", lwd=3 )
boxarr( bb, ww , col="yellow", lwd=3, gap=4)
############

m1bp<-lm(bp~beer,data=bdat)
m2bp<-lm(bp~beer+weight,data=bdat)
m3bp<-lm(bp~beer+weight+sex,data=bdat)
ci.lin(m1bp)
ci.lin(m2bp)  
ci.lin(m3bp)  # no bias here!

###############
## MENDELIAN RANDOMIZATION
###############

### Modifying the script for the previous graph:
########################################################
par( mar=c(0,0,0,0), cex=2)
plot( NA, bty="n",xlim= c(40,100), ylim=c(0,80), xaxt="n", yaxt="n",
 xlab="", ylab="" ) # create an empty plot with coordinates
b<-0; w=12
bmi  <- tbox( "BMI", 44, 40, w,w, col.txt="blue" ,col.border=b)
gl  <- tbox( "Gluc.", 90, 40, w,w, col.txt="blue" ,col.border=b)
gene  <- tbox( "G", 67, 70, w,w, col.txt="blue" ,col.border=b)
u  <- tbox( "U", 67, 10, w,w, col.txt="blue" ,col.border=b)
text( boxarr( bmi, gl , col="red", lwd=3 ), "?", col="red", adj=c(0,-0.5) )
boxarr( gene, bmi , col=4, lwd=3 )
#boxarr( gene, gl , col=3, lwd=3 )
boxarr( u, bmi , col=4, lwd=3 )
boxarr( u, gl , col=4, lwd=3 )

############

 n <- 10000
 mrdat <- data.frame(G = rbinom(n,2,0.2))
 stat.table(G, list(count(),percent(G)),data=mrdat)
 
mrdat$U <- rnorm(n)
mrdat$BMI <- with(mrdat, 25 + 0.7*G + 2*U + rnorm(n) )

ci.lin(lm(BMI~G, data=mrdat))

mrdat$Y <- with(mrdat, 3 + 0.1*BMI - 1.5*U + rnorm(n,0,0.5) )

mxy<-lm(Y ~ BMI, data=mrdat)
ci.lin(mxy)

mgx<-lm(BMI ~ G, data=mrdat)
ci.lin(mgx)  # check the instrument effect
bgx<-mgx$coef[2]   # save the 2nd coefficient (coef of G) 

mgy<-lm(Y ~ G, data=mrdat)
ci.lin(mgy)
bgy<-mgy$coef[2]

causeff <- bgy/bgx
causeff    # closer to 0.1?

library(sem)
summary(tsls(Y ~ BMI, ~G, data=mrdat))


n <- 10000
# initializing simulations:
# 100 simulations (change it, if you want more):
nsim<-100       
mr<-rep(NA,nsim)   # empty vector for the outcome parameters

for (i in 1:nsim) { # start the loop
### Exactly the same commands as before:
mrdat <- data.frame(G = rbinom(n,2,0.2))
mrdat$U <- rnorm(n)
mrdat$BMI <- with(mrdat, 25 + 0.7*G + 2*U + rnorm(n) )
mrdat$Y <- with(mrdat, 3 + 0.1*BMI - 1.5*U + rnorm(n,0,0.5) )
mgx<-lm(BMI ~ G, data=mrdat)
bgx<-mgx$coef[2]
mgy<-lm(Y ~ G, data=mrdat)
bgy<-mgy$coef[2]
# Save the i'th parameter estimate:
mr[i]<-bgy/bgx
}   # end the loop
mr
summary(mr)

### PLEIOTROPY!!!

boxarr( gene, gl , col=3, lwd=3 )
### change the code:
# mrdat$Y <- with(mrdat, 3 + 0.1*BMI - 1.5*U + 0.05*G + rnorm(n,0,0.5) )

n <- 10000
# initializing simulations:
# 100 simulations (change it, if you want more):
nsim<-100       
mr<-rep(NA,nsim)   # empty vector for the outcome parameters

for (i in 1:nsim) { # start the loop
### Exactly the same commands as before:
mrdat <- data.frame(G = rbinom(n,2,0.2))
mrdat$U <- rnorm(n)
mrdat$BMI <- with(mrdat, 25 + 0.7*G + 2*U + rnorm(n) )
##
mrdat$Y <- with(mrdat, 3 + 0.1*BMI - 1.5*U + 0.05*G + rnorm(n,0,0.5) )
##
mgx<-lm(BMI ~ G, data=mrdat)
bgx<-mgx$coef[2]
mgy<-lm(Y ~ G, data=mrdat)
bgy<-mgy$coef[2]
# Save the i'th parameter estimate:
mr[i]<-bgy/bgx
}   # end the loop

summary(mr)


