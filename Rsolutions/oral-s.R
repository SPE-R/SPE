## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(keep.source = TRUE, eps = FALSE, include = TRUE, prefix.string = "./graph/oral")


## ----packages, echo=T,eval=FALSE----------------------------------------------
## library(Epi)
## library(survival)
## cB8  <- c("#000000", "#E69F00", "#56B4E9", "#009E73",
##           "#F0E442", "#0072B2", "#D55E00", "#CC79A7") #colors chosen
## options(digits=3)


## ----dinput, echo=T,eval=FALSE------------------------------------------------
## orca <- read.table("data/oralca2.txt", header = TRUE)
## head(orca)
## str(orca)
## summary(orca)


## ----Survobject, echo=T,eval=FALSE--------------------------------------------
## orca$suob <- Surv(orca$time, 1 * (orca$event > 0))
## str(orca$suob)
## summary(orca$suob)


## ----surv1, echo=T,eval=FALSE-------------------------------------------------
## s.all <- survfit(suob ~ 1, data = orca)


## ----surv2, echo=T,eval=FALSE-------------------------------------------------
## s.all
## str(s.all)


## ----survcdf1, echo=TRUE, fig=TRUE, height=6, width=7,eval=FALSE--------------
## plot(s.all,main="KM estimate of the survival
##      and cum. mortality proportions",
##      xlab="years", ylab="Survival")
## lines(s.all, fun = "event", mark.time = F, conf.int = FALSE)


## ----cdfstage, echo=T, fig=T, height=6, width=7,eval=FALSE--------------------
## s.stg <- survfit(suob ~ stage, data = orca)
## col5 <- c("green", "blue", "black", "red", "gray")
## plot(s.stg, col = col5, fun = "event", mark.time = FALSE)
## s.stg


## ----chstage, echo=T, fig=T, height=6, width=12,eval=FALSE--------------------
## par(mfrow = c(1, 2))
## plot(s.stg, col = col5, fun = "cumhaz", main = "cum. hazards")
## plot(
##   s.stg,
##   col = col5,
##   fun = "cloglog",
##   main = "cloglog: log cum.haz"
## )


## ----sexage, echo=T,eval=FALSE------------------------------------------------
## orca$agegr <- cut(orca$age, br = c(0, 55, 75, 95))
## stat.table(list(sex, agegr), list(count(), percent(agegr)),
##   margins = TRUE,
##   data = orca
## )


## ----cdfsexage, echo=TRUE, fig=TRUE, height=6, width=7,eval=FALSE-------------
## s.agrx <- survfit(suob ~ agegr + sex, data=orca)
## par(mfrow=c(1,1))
## plot(s.agrx, fun="event", mark.time=F, xlim = c(0,15), lwd=2,
##              col=rep(c(cB8[7], cB8[6]),3), lty=c(2,2, 1,1, 5,5), pch=c(1,1,2,2,4,4))
## legend(10,0.3, legend=c("(0,55] Female "," (0,55] Male",
##                        "(55,75] Female "," (55,75] Male",
##                        "(75,95] Female "," (75,95] Male" ),
##        col=rep(c(cB8[7], cB8[6]),3), lty=c(2,2, 1,1, 5,5),
##        pch=c(1,1,2,2,4,4),cex=0.65)


## ----cif1a, echo=T,eval=FALSE-------------------------------------------------
## library(survival)
## cif1 <- survfit(Surv(time, event, type = "mstate") ~ 1,
##   data = orca
## )
## str(cif1)


## ----plotcif1, echo=T,fig=T,eval=FALSE----------------------------------------
## par(mfrow = c(1, 2))
## plotCIF(cif1, 1, main = "Cancer death")
## plotCIF(cif1, 2, main = "Other deaths")


## ----plotcif2, echo=T, fig=T, height=6, width=10,eval=FALSE-------------------
## col5 <- c("green", "blue", "black", "red", "gray")
## cif2 <- survfit(Surv(time, event, type = "mstate") ~ stage,
##   data = orca
## )
## str(cif2)
## 
## par(mfrow = c(1, 2))
## plotCIF(cif2, 1,
##   main = "Cancer death by stage",
##   col = col5, ylim = c(0, 0.7)
## )
## plotCIF(cif2, 2,
##   main = "Other deaths by stage",
##   col = col5, ylim = c(0, 0.7)
## )


## ----stackedcif1, echo=TRUE, fig=TRUE, eval=FALSE-----------------------------
## par(mfrow=c(1,1),xaxs="i", yaxs="i") # make plot start 0,0
## stackedCIF(cif1,xlim=c(0,20),
##            col = c("black"),
##            fill=c(cB8[6],cB8[8],cB8[2]))
## text( 10, 0.10, "Oral ca death ", pos = 4)
## text( 10, 0.5, " Other death ", pos = 4)
## text( 10, 0.80, " Alive ", pos = 4)


## ----cox1, echo=T,eval=FALSE--------------------------------------------------
## options(show.signif.stars = FALSE)
## m1 <- coxph(suob ~ sex + I((age - 65) / 10) + stage, data = orca)
## summary(m1)
## round(ci.exp(m1), 4)


## ----coxzph, echo=T,eval=FALSE------------------------------------------------
## cox.zph(m1)


## ----cox2, echo=T,eval=FALSE--------------------------------------------------
## orca2 <- subset(orca, stage != "unkn")
## orca2$st3 <- Relevel(orca2$stage, list(1:2, 3, 4:5))
## levels(orca2$st3) <- c("I-II", "III", "IV")
## m2 <- update(m1, . ~ . - stage + st3, data = orca2)
## round(ci.exp(m2), 4)


## ----cox2cll, echo=T,eval=FALSE-----------------------------------------------
## newd <- data.frame(
##   sex = c(rep("Male", 6), rep("Female", 6)),
##   age = rep(c(rep(40, 3), rep(80, 3)), 2),
##   st3 = rep(levels(orca2$st3), 4)
## )
## newd
## col3 <- c("green", "black", "red")
## par(mfrow = c(1, 2))
## plot(
##   survfit(
##     m2, newdata = subset(newd, sex == "Male" & age == 40)
##   ),
##   col = col3, fun = "event", mark.time = FALSE
## )
## lines(
##   survfit(
##     m2, newdata = subset(newd, sex == "Female" & age == 40)
##   ),
##   col = col3, fun = "event", lty = 2, mark.time = FALSE
## )
## plot(
##   survfit(
##     m2, newdata = subset(newd, sex == "Male" & age == 80)
##   ),
##   ylim = c(0, 1), col = col3, fun = "event", mark.time = FALSE
## )
## lines(
##   survfit(
##     m2, newdata = subset(newd, sex == "Female" & age == 80)
##   ),
##   col = col3, fun = "event", lty = 2, mark.time = FALSE
## )


## ----coxhaz1, echo=T,eval=FALSE-----------------------------------------------
## m2haz1 <-
##   coxph(
##     Surv(time, event == 1) ~ sex + I((age - 65) / 10) + st3,
##     data = orca2
##   )
## round(ci.exp(m2haz1), 4)
## cox.zph(m2haz1)


## ----coxhaz2, echo=T,eval=FALSE-----------------------------------------------
## m2haz2 <-
##   coxph(
##     Surv(time, event == 2) ~ sex + I((age - 65) / 10) + st3,
##     data = orca2
##   )
## round(ci.exp(m2haz2), 4)
## cox.zph(m2haz2)


## ----lexis 1, echo=T,eval=FALSE-----------------------------------------------
## orca.lex <- Lexis(
##   exit = list(stime = time),
##   exit.status = factor(event,
##     labels = c("Alive", "Oral ca. death", "Other death")
##   ),
##   data = orca
## )
## summary(orca.lex)


## ----lexis, echo=T,eval=FALSE-------------------------------------------------
## boxes(orca.lex)


## ----split, echo=T,eval=FALSE-------------------------------------------------
## orca2.lex <- subset(orca.lex, stage != "unkn")
## orca2.lex$st3 <- Relevel(orca2$stage, list(1:2, 3, 4:5))
## levels(orca2.lex$st3) <- c("I-II", "III", "IV")


## ----split b, echo=T,eval=FALSE-----------------------------------------------
## cuts <- sort(orca2$time[orca2$event == 1])
## orca2.spl <-
##   splitLexis(orca2.lex, br = cuts, time.scale = "stime")
## orca2.spl$timeband <- as.factor(orca2.spl$stime)


## ----strsplit, echo=T,eval=FALSE----------------------------------------------
## str(orca2.spl)
## orca2.spl[1:20, ]


## ----poisson, echo=T,eval=FALSE-----------------------------------------------
## m2pois1 <- glm(
##   1 * (lex.Xst == "Oral ca. death") ~
##     -1 + timeband + sex + I((age - 65) / 10) + st3,
##   family = poisson, offset = log(lex.dur), data = orca2.spl
## )


## ----poissonresults, echo=T, fig=T,eval=FALSE---------------------------------
## tb <- as.numeric(levels(orca2.spl$timeband))
## ntb <- length(tb)
## tbmid <- (tb[-ntb] + tb[-1]) / 2 # midpoints of the intervals
## round(ci.exp(m2pois1), 3)
## par(mfrow = c(1, 1))
## plot(tbmid, 1000 * exp(coef(m2pois1)[1:(ntb - 1)]),
##   ylim = c(5, 3000), log = "xy", type = "l"
## )


## ----poissonspline, echo=T, fig=T,eval=FALSE----------------------------------
## library(splines)
## m2pspli <-
##   update(
##     m2pois1,
##     . ~ ns(stime, df = 6, intercept = FALSE) +
##       sex + I((age - 65) / 10) + st3)
## round(ci.exp(m2pspli), 3)
## news <- data.frame(
##   stime = seq(0, 25, length = 301),
##   lex.dur = 1000,
##   sex = "Female",
##   age = 65,
##   st3 = "I-II"
## )
## blhaz <-
##   predict(m2pspli, newdata = news, se.fit = TRUE, type = "link")
## blh95 <- cbind(blhaz$fit, blhaz$se.fit) %*% ci.mat()
## par(mfrow = c(1, 1))
## matplot(news$stime, exp(blh95),
##   type = "l", lty = c(1, 1, 1), lwd = c(2, 1, 1),
##   col = rep("black", 3), log = "xy", ylim = c(5, 3000)
## )

