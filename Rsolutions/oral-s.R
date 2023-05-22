### R code from vignette source '/home/runner/work/SPE/SPE/build/oral-s.rnw'

###################################################
### code chunk number 1: packages
###################################################
library(Epi)
library(survival)


###################################################
### code chunk number 2: dinput
###################################################
orca <- read.table("./data/oralca2.txt", header=T)
head(orca) ; str(orca) ; summary(orca)


###################################################
### code chunk number 3: Survobject
###################################################
orca$suob <- Surv(orca$time, 1*(orca$event > 0) )
str(orca$suob)
summary(orca$suob)


###################################################
### code chunk number 4: surv1
###################################################
s.all <- survfit(suob ~ 1, data=orca)


###################################################
### code chunk number 5: surv2
###################################################
s.all
str(s.all)


###################################################
### code chunk number 6: survcdf1
###################################################
plot(s.all)
lines(s.all, fun = "event", mark.time=F, conf.int=F)


###################################################
### code chunk number 7: cdfstage
###################################################
s.stg  <- survfit(suob ~ stage, data= orca)
col5 <- c("green", "blue", "black", "red", "gray")
plot(s.stg, col= col5, fun="event", mark.time=F )
s.stg


###################################################
### code chunk number 8: chstage
###################################################
par(mfrow=c(1,2))
plot(s.stg, col= col5, fun="cumhaz", main="cum. hazards" )
plot(s.stg, col= col5, fun="cloglog", main = "cloglog: log cum.haz"  )


###################################################
### code chunk number 9: sexage
###################################################
orca$agegr <- cut(orca$age, br=c(0,55,75, 95))
stat.table( list( sex, agegr), list( count(), percent(agegr) ),
             margins=T, data = orca )


###################################################
### code chunk number 10: cdfsexage
###################################################
s.agrx <- survfit(suob ~ agegr + sex, data=orca)
par(mfrow=c(1,1))
plot(s.agrx, fun="event", mark.time=F, xlim = c(0,15),
             col=rep(c("red", "blue"),3), lty=c(2,2, 1,1, 5,5))


###################################################
### code chunk number 11: cif1a
###################################################
cif1 <- survfit( Surv( time, event, type="mstate") ~ 1,
                 data = orca)
str(cif1)


###################################################
### code chunk number 12: plotcif1
###################################################
par(mfrow=c(1,2))
plotCIF(cif1, 1, main = "Cancer death")
plotCIF(cif1, 2, main= "Other deaths")


###################################################
### code chunk number 13: plotcif2
###################################################
col5 <- c("green", "blue", "black", "red", "gray")
cif2 <- survfit( Surv( time, event, type="mstate") ~ stage,
                 data = orca)
str(cif2)

par(mfrow=c(1,2))
plotCIF(cif2, 1, main = "Cancer death by stage",
        col = col5, ylim = c(0, 0.7) )
plotCIF(cif2, 2, main= "Other deaths by stage",
        col=col5, ylim = c(0, 0.7) )


###################################################
### code chunk number 14: stackedcif1
###################################################
par(mfrow=c(1,1))
stackedCIF(cif1,colour = c("gray70", "gray85"))


###################################################
### code chunk number 15: cox1
###################################################
options(show.signif.stars = F)
m1 <- coxph(suob ~ sex + I((age-65)/10) + stage, data= orca)
summary( m1 )
round( ci.exp(m1 ), 4 )


###################################################
### code chunk number 16: coxzph
###################################################
cox.zph(m1)


###################################################
### code chunk number 17: cox2
###################################################
orca2 <- subset(orca, stage != "unkn")
orca2$st3 <- Relevel( orca2$stage, list(1:2, 3, 4:5) )
levels(orca2$st3) = c("I-II", "III", "IV")
m2 <- update(m1, . ~ . - stage + st3, data=orca2 )
round( ci.exp(m2 ), 4)


###################################################
### code chunk number 18: cox2cll
###################################################
newd <- data.frame( sex = c( rep("Male", 6), rep("Female", 6) ),
                    age = rep( c( rep(40, 3), rep(80, 3) ), 2 ),
                    st3 = rep( levels(orca2$st3), 4) )
newd
col3 <- c("green", "black", "red")
par(mfrow=c(1,2))
plot( survfit(m2, newdata= subset(newd, sex=="Male" & age==40)),
     col=col3, fun="event", mark.time=F)
lines( survfit(m2, newdata= subset(newd, sex=="Female" & age==40)),
      col= col3, fun="event", lty = 2, mark.time=F)
plot( survfit(m2, newdata= subset(newd, sex=="Male" & age==80)),
     ylim = c(0,1), col= col3, fun="event", mark.time=F)
lines( survfit(m2, newdata= subset(newd, sex=="Female" & age==80)),
      col=col3, fun="event", lty=2, mark.time=F)



###################################################
### code chunk number 19: coxhaz1
###################################################
m2haz1 <- coxph( Surv( time, event==1)  ~ sex + I((age-65)/10) + st3 , data=orca2 )
round( ci.exp(m2haz1 ), 4)
cox.zph(m2haz1)


###################################################
### code chunk number 20: coxhaz2
###################################################
m2haz2 <- coxph( Surv( time, event==2)  ~ sex + I((age-65)/10) + st3 , data=orca2 )
round( ci.exp(m2haz2 ), 4)
cox.zph(m2haz2)


###################################################
### code chunk number 21: fg1
###################################################
library(cmprsk)
attach(orca2)
m2fg1 <- crr(time, event, cov1 = model.matrix(m2), failcode=1)
summary(m2fg1, Exp=T)


###################################################
### code chunk number 22: fg2
###################################################
m2fg2 <- crr(time, event, cov1 = model.matrix(m2), failcode=2)
summary(m2fg2, Exp=T)


###################################################
### code chunk number 23: lexis
###################################################
orca.lex <- Lexis(exit = list(stime = time),
           exit.status = factor(event,
   labels = c("Alive", "Oral ca. death", "Other death")),
                  data = orca)
summary(orca.lex)


###################################################
### code chunk number 24: split
###################################################
orca2.lex <- subset(orca.lex, stage != "unkn" )
orca2.lex$st3 <- Relevel( orca2$stage, list(1:2, 3, 4:5) )
levels(orca2.lex$st3) = c("I-II", "III", "IV")


###################################################
### code chunk number 25: split
###################################################
cuts <- sort(orca2$time[orca2$event==1])
orca2.spl <- splitLexis( orca2.lex, br = cuts, time.scale="stime" )
orca2.spl$timeband <- as.factor(orca2.spl$stime)


###################################################
### code chunk number 26: strsplit
###################################################
str(orca2.spl)
#orca2.spl[ 1:20, ]


###################################################
### code chunk number 27: poisson
###################################################
m2pois1 <- glm( 1*(lex.Xst=="Oral ca. death")  ~
      -1 + timeband + sex + I((age-65)/10) + st3,
      family=poisson, offset = log(lex.dur), data = orca2.spl)


###################################################
### code chunk number 28: poissonresults
###################################################
tb <- as.numeric(levels(orca2.spl$timeband)) ; ntb <- length(tb)
tbmid <- (tb[-ntb] + tb[-1])/2   # midpoints of the intervals
round( ci.exp(m2pois1 ), 3)
par(mfrow=c(1,1))
plot( tbmid, 1000*exp(coef(m2pois1)[1:(ntb-1)]),
            ylim=c(5,3000), log = "xy", type = "l")


###################################################
### code chunk number 29: poissonspline
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


