## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(keep.source = TRUE, eps = FALSE, include = TRUE, prefix.string = "./graph/oral")


## ----packages, echo=T,eval=TRUE-----------------------------------------------
library(Epi)
library(survival)
cB8  <- c("#000000", "#E69F00", "#56B4E9", "#009E73", 
          "#F0E442", "#0072B2", "#D55E00", "#CC79A7") #colors chosen
options(digits=3)


## ----dinput, echo=T,eval=TRUE-------------------------------------------------
orca <-  read.table(file = 'https://raw.githubusercontent.com/SPE-R/SPE/master/pracs/data/oralca2.txt', header = TRUE, sep = " ",row.names = 1 )
head(orca)
orca$stage<-as.factor(orca$stage)
orca$sex<-factor(orca$sex,levels=c("Male","Female"))
str(orca)
summary(orca)


## ----Survobject, echo=T,eval=TRUE---------------------------------------------
suob <- Surv(orca$time, 1 * (orca$event > 0))
str(suob)
summary(suob)


## ----surv1, echo=T,eval=TRUE--------------------------------------------------
s.all <- survfit(suob ~ 1, data = orca)


## ----surv2, echo=T,eval=TRUE--------------------------------------------------
s.all
str(s.all)


## ----survcdf1, echo=TRUE, fig=TRUE, height=6, width=7,eval=TRUE---------------
plot(s.all,main="KM estimate of the survival
     and cum. mortality proportions",
     xlab="years", ylab="Survival")
plot(s.all)
lines(s.all, fun = "event", mark.time = F, conf.int = FALSE)


## ----cdfstage, echo=T, fig=T, height=6, width=7,eval=TRUE---------------------
s.stg <- survfit(suob ~ stage, data = orca)
col5 <- cB8[1:5]
plot(s.stg, col = col5, fun = "event", main="Cum. mortality by stage",mark.time = FALSE)
legend(15, 0.6, title="stage",legend=levels(orca$stage),col = col5,lty=rep(1,5))


## ----chstage, echo=T, fig=T, height=6, width=12,eval=TRUE---------------------
par(mfrow = c(1, 2))
plot(s.stg, col = col5, fun = "cumhaz", main = "Cumulative hazards")
legend(1, 3.5, title="stage",legend=levels(orca$stage),col = col5,lty=rep(1,5), cex=0.8)
plot(s.stg, col = col5, fun = "cloglog",main = "cloglog: log cum.haz")
legend(3, -2, title="stage",legend=levels(orca$stage),col = col5,lty=rep(1,5), cex=0.7)



## ----sexage, echo=T,eval=TRUE-------------------------------------------------
orca$agegr <- cut(orca$age, br = c(0, 55, 75, 95))
stat.table(list(sex, agegr), list(count(), percent(agegr)),
  margins = TRUE, 
  data = orca
)


## ----cdfsexage, echo=TRUE, fig=TRUE, height=6, width=7,eval=TRUE--------------
s.agrx <- survfit(suob ~ agegr + sex, data=orca)
par(mfrow=c(1,1))
plot(s.agrx, fun="event", main="Cumulative mortality (KM) by age and sex",xlab="Time since oral cancer diagnosis (years)",ylab="Cum. mortality",mark.time=F, xlim = c(0,15), lwd=2,
             col=rep(c(cB8[7], cB8[6]),3), lty=c(2,2, 1,1, 5,5),
     xaxs="i",yaxs="i")
legend(12,0.35, legend=c("(0,55] Female "," (0,55] Male",
                       "(55,75] Female "," (55,75] Male",
                       "(75,95] Female "," (75,95] Male" ),
       col=rep(c(cB8[7], cB8[6]),3), lty=c(2,2, 1,1, 5,5),cex=0.65)


## ----cif1a, echo=T,eval=TRUE--------------------------------------------------
library(survival)
cif1 <- survfit(Surv(time, event, type = "mstate") ~ 1,
  data = orca
)
str(cif1)


## ----plotcif1, echo=T,fig=T,eval=TRUE-----------------------------------------
par(mfrow = c(1, 2))
plotCIF(cif1, 1, main = "Cancer death",xlab="Time since oral cancer diagnosis (years)")
plotCIF(cif1, 2, main = "Other deaths",xlab="Time since oral cancer diagnosis (years)")


## ----plotcif2, echo=T, fig=T, height=6, width=10,eval=TRUE--------------------
col5 <- col5
cif2 <- survfit(Surv(time, event, type = "mstate") ~ stage,
  data = orca
)
str(cif2)

par(mfrow = c(1, 2))
plotCIF(cif2, 1,
  main = "Cancer death by stage",
  col = col5, ylim = c(0, 0.7)
)
plotCIF(cif2, 2,
  main = "Other deaths by stage",
  col = col5, ylim = c(0, 0.7)
)

legend(3, 0.7, title="stage",legend=levels(orca$stage),col = col5,lty=rep(1,5), cex=0.7)



## ----stackedcif1, echo=TRUE, fig=TRUE, eval=TRUE------------------------------
par(mfrow=c(1,1),xaxs="i", yaxs="i") # make plot start 0,0
stackedCIF(cif1,xlim=c(0,20),
           col = c("black"),
           fill=c(cB8[6],cB8[8],cB8[2])) #choosing some colors 
text( 10, 0.10, "Oral ca death ", pos = 4)
text( 10, 0.5, " Other death ", pos = 4)
text( 10, 0.80, " Alive ", pos = 4)


## ----cox1, echo=T,eval=TRUE---------------------------------------------------
options(show.signif.stars = FALSE)
m1 <- coxph(suob ~ sex + I((age - 65) / 10) + stage, data = orca)
summary(m1)
round(ci.exp(m1),3)


## ----coxzph, echo=T,eval=TRUE-------------------------------------------------
cox.zph(m1)


## ----cox2, echo=T,eval=TRUE---------------------------------------------------
orca2 <- subset(orca, stage != "unkn")
orca2$st3 <- Relevel(orca2$stage, list(1:2, 3, 4:5))
levels(orca2$st3) <- c("I-II", "III", "IV")
m2 <- coxph(Surv(orca2$time, 1 * (orca2$event > 0)) ~ sex + I((age - 65) / 10) + st3, data = orca2)
summary(m2)
#m2 <- update(m1, . ~ . - stage + st3, data = orca2) #do not work
round(ci.exp(m2), 3)


## ----cox2cll, echo=T,eval=TRUE------------------------------------------------
newd <- data.frame(
  sex = c(rep("Male", 6), rep("Female", 6)),
  age = rep(c(rep(40, 3), rep(80, 3)), 2),
  st3 = rep(levels(orca2$st3), 4)
)
newd
col3 <- cB8[1:3] #pre-setting color palette
leg<-levels(interaction(levels(factor(orca2$sex)),levels(orca2$st3))) #legend labels by sex and stage
par(mfrow = c(1, 2))
plot(
  survfit(m2, newdata = subset(newd, sex == "Male" & age == 40)),
  col = col3, 
  lty= 1,
  fun = "event", mark.time = FALSE,
  main="Cum. mortality for M and F \n age 40"
  )
lines(
  survfit(m2, newdata = subset(newd, sex == "Female" & age == 40)),
  col = col3, lty=c(2,2,2),fun = "event", mark.time = FALSE
)
legend(0, 0.95, title="stage",legend=leg,
       col = c(col3[1],col3[1],col3[2],col3[2],col3[3],col3[3]),
        ,lty=c(2,1,2,1,2,1), cex=0.6)
plot(
  survfit(m2, newdata = subset(newd, sex == "Male" & age == 80)),
  ylim = c(0, 1), col = col3, fun = "event", mark.time = FALSE,
   main="Cum. mortality for M and F \n age 80"
)
lines(
  survfit(m2, newdata = subset(newd, sex == "Female" & age == 80)  ),
  col = col3, fun = "event", lty = 2, mark.time = FALSE
)
legend(10, 0.5, title="stage",legend=leg,
       col = c(col3[1],col3[1],col3[2],col3[2],col3[3],col3[3]),
        ,lty=c(2,1,2,1,2,1), cex=0.7)


## ----coxhaz1, echo=T,eval=TRUE------------------------------------------------
m2haz1 <- 
  coxph(
    Surv(time, event == 1) ~ sex + I((age - 65) / 10) + st3, 
    data = orca2
  )
round(ci.exp(m2haz1), 4)
cox.zph(m2haz1)


## ----coxhaz2, echo=T,eval=TRUE------------------------------------------------
m2haz2 <- 
  coxph(
    Surv(time, event == 2) ~ sex + I((age - 65) / 10) + st3, 
    data = orca2
  )
round(ci.exp(m2haz2), 4)
cox.zph(m2haz2)


## ----lexis 1, echo=T,eval=TRUE------------------------------------------------
orca.lex <- Lexis(
  exit = list(stime = time),
  exit.status = factor(event,
    labels = c("Alive", "Oral ca. death", "Other death")
  ),
  data = orca
)
summary(orca.lex)


## ----lexis, echo=T,eval=TRUE--------------------------------------------------
boxes(orca.lex,boxpos = TRUE)

