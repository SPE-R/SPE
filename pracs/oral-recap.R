###################################################
library(Epi)
library(survival)
sessionInfo()
options( width=87 )
par()
###################################################
setwd("C:/Users/janne/projects/SPE/pracs")
orca <- read.table("./data/oralca2.txt", header=T)
head(orca)
str(orca)
summary(orca)

###################################################
orca$suob <- Surv(orca$time, 1*(orca$event > 0) )
str(orca$suob)
summary(orca$suob)

###################################################
s.all <- survfit(suob ~ 1, data=orca)

###################################################
s.all
str(s.all)

###################################################
plot(s.all,main="KM estimate of the survival \n and cum. mortality proportions",
     xlab="years", ylab="Survival")
lines(s.all, fun = "event", mark.time=T, conf.int=F)

###################################################
# Oral cancer patient suvival by stage 
###################################################
s.stg  <- survfit(suob ~ stage, data= orca)
col5 <- c("green", "blue", "black", "red", "gray")
plot(s.stg, col= col5, fun="event", mark.time=F ,
     main="KM estimate of the cum. mortality proportions by stage",
     xlab="years", ylab="Cum. mortality")
legend(10, 0.4, legend=levels(factor(orca$stage)),
       col=col5, lty=1, cex=0.8,
       title="Stage", text.font=4, bg='white')
s.stg

###################################################
# Cum haz and log-log of cum. haz by stage
###################################################

par(mfrow=c(1,2))
plot(s.stg, col= col5, fun="cumhaz", main="cum. hazards", 
     xlab="years", ylab="Cum. hazard")
legend(0,3.5, legend=levels(factor(orca$stage)),
       col=col5, lty=1, cex=0.8,
       title="Stage", text.font=4, bg='white')
plot(s.stg, col= col5, fun="cloglog", main = "cloglog: log cum.haz",
     xlab="years", ylab="clog-log")
legend(0.1,1, legend=levels(factor(orca$stage)),
       col=col5, lty=1, cex=0.5,
       title="Stage", text.font=3, bg='white')


###################################################
# Cancer patients sex and age at diagnosis
###################################################

orca$agegr <- cut(orca$age, br=c(0,55,75, 95))
stat.table( list( sex, agegr), list( count(), percent(agegr) ),
             margins=T, data = orca )

###################################################
s.agrx <- survfit(suob ~ agegr + sex, data=orca)
par(mfrow=c(1,1))
plot(s.agrx, fun="event", mark.time=T, xlim = c(0,15), lwd=2,
             col=rep(c("red", "blue"),3), lty=c(2,2, 1,1, 5,5),
     pch=c(1,1,2,2,4,4))
legend(10,0.3, legend=c("(0,55] Female "," (0,55] Male",
                       "(55,75] Female "," (55,75] Male",
                       "(75,95] Female "," (75,95] Male" ),
       col=rep(c("red", "blue"),3), lty=c(2,2, 1,1, 5,5), 
       pch=c(1,1,2,2,4,4),cex=0.7)
       


###################################################
# Event Specific cumulative mortality
###################################################
cif1 <- survfit( Surv( time, event, type="mstate") ~ 1,
                 data = orca)
str(cif1)

###################################################
par(mfrow=c(1,2))
plotCIF(cif1, 1, main = "Cancer death")
plotCIF(cif1, 2, main= "Other deaths")

###################################################
col5 <- c("green", "blue", "black", "red", "gray")
cif2 <- survfit( Surv( time, event, type="mstate") ~ stage,
                 data = orca)
str(cif2)

par(mfrow=c(1,2))
plotCIF(cif2, 1, main = "Cancer death by stage",
        col = col5, ylim = c(0, 0.7) )
legend(10, 0.2, legend=levels(factor(orca$stage)),
       col=col5, lty=1, cex=0.6,
       title="Stage", text.font=4, bg='white')
plotCIF(cif2, 2, main= "Other deaths by stage",
        col=col5, ylim = c(0, 0.7) )

###################################################
# Stacked plot 
###################################################

par(mfrow=c(1,1),xaxs="i", yaxs="i") # make plot start 0,0
stackedCIF(cif1,xlim=c(0,20),
           col = c("black"),
           fill=c("blue","green","red"))
text( 10, 0.10, "Oral ca death ", pos = 4)
text( 10, 0.5, " Other death ", pos = 4)
text( 10, 0.80, " Alive ", pos = 4)

###################################################
# Proportional hazards models for total mortality
############################

options(show.signif.stars = F)
# recall
oral$stage<-factor(oral$stage)
orca$suob <- Surv(orca$time, 1*(orca$event > 0) ) # total mortality
m1 <- coxph(suob ~ sex + I(age/10) + stage, data= orca)
summary( m1 )
round( ci.exp( m1 ), 4 )


###################################################
# test proportionality
###################################################
cox.zph( m1 )

###################################################
orca2 <- subset(orca, stage != "unkn")
orca2$st3 <- Relevel( orca2$stage, list(1:2, 3, 4:5) )
levels(orca2$st3) = c("I-II", "III", "IV")
m2 <- update(m1, . ~ . - stage + st3, data=orca2 )
round( ci.exp(m2 ), 4)

###################################################
newd <- data.frame( sex = c( rep("Male", 6), rep("Female", 6) ),
                    age = rep( c( rep(40, 3), rep(80, 3) ), 2 ),
                    st3 = rep( levels(orca2$st3), 4) )
newd
col3 <- c("green", "black", "red")
par(mfrow=c(1,2))
plot( survfit(m2, newdata= subset(newd, sex=="Male" & age==40)),
     col=col3, fun="event", mark.time=F,main="Age 40")
lines( survfit(m2, newdata= subset(newd, sex=="Female" & age==40)),
      col= col3, fun="event", lty = 2, mark.time=F)

plot( survfit(m2, newdata= subset(newd, sex=="Male" & age==80)),
     ylim = c(0,1), col= col3, fun="event", mark.time=F,main="Age 80")
lines( survfit(m2, newdata= subset(newd, sex=="Female" & age==80)),
      col=col3, fun="event", lty=2, mark.time=F)

###################################################
# models for event specific hazards, oral cancer death
m2haz1 <- coxph( Surv( time, event==1)  ~ sex + I((age-65)/10) + st3 , data=orca2 )
round( ci.exp(m2haz1 ), 4)
cox.zph(m2haz1)

###################################################
# other cause death
m2haz2 <- coxph( Surv( time, event==2)  ~ sex + I((age-65)/10) + st3 , data=orca2 )
round( ci.exp(m2haz2 ), 4)
cox.zph(m2haz2)

###################################################
#library(cmprsk)
#attach(orca2)
#m2fg1 <- crr(time, event, cov1 = model.matrix(m2), failcode=1)
#summary(m2fg1, Exp=T)

###################################################
#m2fg2 <- crr(time, event, cov1 = model.matrix(m2), failcode=2)
#summary(m2fg2, Exp=T)

###################################################
orca.lex <- Lexis(exit = list(stime = time),
           exit.status = factor(event,
   labels = c("Alive", "Oral ca. death", "Other death")),
                  data = orca)
summary(orca.lex)

###################################################
# Optional
orca2.lex <- subset(orca.lex, stage != "unkn" )
orca2.lex$st3 <- Relevel( orca2$stage, list(1:2, 3, 4:5) )
levels(orca2.lex$st3) = c("I-II", "III", "IV")

###################################################
cuts <- sort(orca2$time[orca2$event==1])
orca2.spl <- splitLexis( orca2.lex, br = cuts, time.scale="stime" )
orca2.spl$timeband <- as.factor(orca2.spl$stime)

###################################################
str(orca2.spl)
orca2.spl[ 1:20, ]

###################################################
m2pois1 <- glm( 1*(lex.Xst=="Oral ca. death")  ~
      -1 + timeband + sex + I((age-65)/10) + st3,
      family=poisson, offset = log(lex.dur), data = orca2.spl)

###################################################
tb <- as.numeric(levels(orca2.spl$timeband)) ; ntb <- length(tb)
tbmid <- (tb[-ntb] + tb[-1])/2   # midpoints of the intervals
round( ci.exp(m2pois1 ), 3)
par(mfrow=c(1,1))
plot( tbmid, 1000*exp(coef(m2pois1)[1:(ntb-1)]),
            ylim=c(5,3000), log = "xy", type = "l")

###################################################
library(splines)
m2pspli <- update(m2pois1, . ~  ns(stime, df = 6, intercept = F) +
        sex + I((age-65)/10) + st3)
round( ci.exp( m2pspli ), 3)
news <- data.frame( stime = seq(0,25, length=301), lex.dur = 1000, sex = "Female",
                    age = 65, st3 = "I-II")
blhaz <- predict(m2pspli, newdata = news, se.fit = T, type = "link")
blh95 <- cbind(blhaz$fit, blhaz$se.fit) %*% ci.mat()
par(mfrow=c(1,1))
matplot( news$stime, exp(blh95), type = "l", lty = c(1,1,1), lwd = c(2,1,1) ,
      col = rep("black", 3),  log = "xy", ylim = c(5,3000)  )

