## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(keep.source = TRUE, eps = FALSE, include = TRUE, prefix.string = "./graph/oral")


## ----packages, echo=TRUE,eval=FALSE-------------------------------------------
## library(Epi)
## library(survival)
## cB8  <- c("#000000", "#E69F00", "#56B4E9", "#009E73",
##           "#F0E442", "#0072B2", "#D55E00", "#CC79A7") #colors chosen


## ----dinput, echo=TRUE,eval=FALSE---------------------------------------------
## orca <-  read.table(file = 'https://raw.githubusercontent.com/SPE-R/SPE/master/pracs/data/oralca2.txt', header = TRUE, sep = " ",row.names = 1 )
## head(orca)
## str(orca)
## summary(orca)


## ----Survobject, echo=TRUE,eval=FALSE-----------------------------------------
## suob <- Surv(orca$time, 1 * (orca$event > 0))
## str(suob)
## summary(suob)


## ----surv1, echo=TRUE,eval=FALSE----------------------------------------------
## s.all <- survfit(suob ~ 1, data = orca)


## ----surv2, echo=TRUE,eval=FALSE----------------------------------------------
## s.all
## str(s.all)


## ----survcdf1, echo=TRUE, fig=TRUE, height=6, width=7,eval=FALSE--------------
## plot(s.all)
## lines(s.all, fun = "event", mark.time = F, conf.int = FALSE)


## ----cdfstage, echo=TRUE, fig=TRUE, height=6, width=7,eval=FALSE--------------
## s.stg <- survfit(suob ~ stage, data = orca)
## col5 <- cB8[1:5]
## plot(s.stg, col = col5, fun = "event", mark.time = FALSE)
## legend(15, 0.5, legend=levels(factor(orca$stage)),
##        col=col5, lty=1, cex=0.8,
##        title="Stage", text.font=4, bg='white')
## s.stg


## ----chstage, echo=TRUE, fig=TRUE, height=6, width=12,eval=FALSE--------------
## par(mfrow = c(1, 2))
## plot(s.stg, col = col5, fun = "cumhaz", main = "cum. hazards")
## plot(
##   s.stg,
##   col = col5,
##   fun = "cloglog",
##   main = "cloglog: log cum.haz"
## )
## legend(2, -2, legend=levels(factor(orca$stage)),
##        col=col5, lty=1, cex=0.8,
##        title="Stage", text.font=4, bg='white')


## ----sexage, echo=TRUE,eval=FALSE---------------------------------------------
## orca$agegr <- cut(orca$age, br = c(0, 55, 75, 95))
## stat.table(list(sex, agegr), list(count(), percent(agegr)),
##   margins = TRUE,
##   data = orca
## )


## ----cdfsexage, echo=TRUE, fig=TRUE, height=6, width=7,eval=FALSE-------------
## s.agrx <- survfit(suob ~ agegr + sex, data = orca)
## par(mfrow = c(1, 1))
## plot(s.agrx,
##   fun = "event", mark.time = FALSE, xlim = c(0, 15),
##   col = rep(c(cB8[8], cB8[6]), 3), lty = c(2, 2, 1, 1, 5, 5),lwd=2
## )


## ----cif1a, echo=TRUE,eval=FALSE----------------------------------------------
## library(survival)
## cif1 <- survfit(Surv(time, event, type = "mstate") ~ 1,
##   data = orca
## )
## str(cif1)


## ----plotcif1, echo=TRUE,fig=TRUE,eval=FALSE----------------------------------
## par(mfrow = c(1, 2))
## plotCIF(cif1, 1, main = "Cancer death")
## plotCIF(cif1, 2, main = "Other deaths")


## ----plotcif2, echo=TRUE, fig=TRUE, height=6, width=10,eval=FALSE-------------
## cif2 <- survfit(Surv(time, event, type = "mstate") ~ stage,
##   data = orca
## )
## str(cif2)
## 
## par(mfrow = c(1, 2))
## plotCIF(cif2, 1,
##   main = "Cancer death by stage",
##   col = cB8[1:5], ylim = c(0, 0.7)
## )
## 
## plotCIF(cif2, 2,
##   main = "Other deaths by stage",
##   col = cB8[1:5], ylim = c(0, 0.7)
## )
## 
## legend(0, 0.6, legend=levels(factor(orca$stage)), col=col5, lty=1, cex=0.5,
##        title="Stage", text.font=4, bg='white')
## 


## ----stackedcif1, echo=TRUE, fig=TRUE, eval=FALSE-----------------------------
## par(mfrow = c(1, 1))
## stackedCIF(cif1, colour = c("gray70", "gray85"))


## ----cox1, echo=TRUE,eval=FALSE-----------------------------------------------
## options(show.signif.stars = FALSE)
## m1 <- coxph(Surv(time, 1 * (event > 0)) ~ sex + I((age - 65) / 10) + stage, data = orca)
## summary(m1)
## round(ci.exp(m1), 3)


## ----coxzph, echo=TRUE,eval=FALSE---------------------------------------------
## cox.zph(m1)


## ----cox2, echo=TRUE,eval=FALSE-----------------------------------------------
## orca2 <- subset(orca, stage != "unkn")
## orca2$st3 <- Relevel(orca2$stage, list(1:2, 3, 4:5))
## levels(orca2$st3) <- c("I-II", "III", "IV")
## m2 <- update(m1, . ~ . - stage + st3, data = orca2)
## round(ci.exp(m2), 3)


## ----cox2cll, echo=TRUE,eval=FALSE--------------------------------------------
## newd <- data.frame(
##   sex = c(rep("Male", 6), rep("Female", 6)),
##   age = rep(c(rep(40, 3), rep(80, 3)), 2),
##   st3 = rep(levels(orca2$st3), 4)
## )
## newd
## col3 <- cB8[1:3]
## par(mfrow = c(1, 2))
## plot(
##   survfit(
##     m2, newdata = subset(newd, sex == "Male" & age == 40)
##   ),
##   col = col3, fun = "event", mark.time = FALSE,
##   main="Cum. mortality by sex and stage \n age 40", ylim=c(0,1)
## )
## lines(
##   survfit(
##     m2, newdata = subset(newd, sex == "Female" & age == 40)
##   ),
##   col = col3, fun = "event", lty = 2, mark.time = FALSE
## )
## plot(
##   survfit(
##     m2, newdata = subset(newd, sex == "Male" & age == 80)),
##   ylim = c(0, 1), col = col3, fun = "event", mark.time = FALSE,
##   main="Cum. mortality by sex and stage \n age 80")
## lines(
##   survfit(
##     m2, newdata = subset(newd, sex == "Female" & age == 80)
##   ),
##   col = col3, fun = "event", lty = 2, mark.time = FALSE
## )
## 
## legend(10, 0.4, legend=levels(interaction(levels(factor(newd$st3)),
##                                           levels(factor(newd$sex)))),       col=col3, lty=c(2,2,2,1,1,1), cex=0.5,
##        title="Stage and sex", text.font=4, bg='white')


## ----coxhaz1, echo=TRUE,eval=FALSE--------------------------------------------
## m2haz1 <-
##   coxph(
##     Surv(time, event == 1) ~ sex + I((age - 65) / 10) + st3,
##     data = orca2
##   )
## round(ci.exp(m2haz1), 4)
## cox.zph(m2haz1)


## ----coxhaz2, echo=TRUE,eval=FALSE--------------------------------------------
## m2haz2 <-
##   coxph(
##     Surv(time, event == 2) ~ sex + I((age - 65) / 10) + st3,
##     data = orca2
##   )
## round(ci.exp(m2haz2), 4)
## cox.zph(m2haz2)


## ----lexis 1, echo=TRUE,eval=FALSE--------------------------------------------
## orca.lex <- Lexis(
##   exit = list(stime = time),
##   exit.status = factor(event,
##     labels = c("Alive", "Oral ca. death", "Other death")
##   ),
##   data = orca
## )
## summary(orca.lex)


## ----lexis, echo=TRUE,eval=FALSE----------------------------------------------
## boxes(orca.lex,boxpos=T)


## ----split, echo=TRUE,eval=FALSE----------------------------------------------
## orca2.lex <- subset(orca.lex, stage != "unkn")
## orca2.lex$st3 <- Relevel(orca2$stage, list(1:2, 3, 4:5))
## levels(orca2.lex$st3) <- c("I-II", "III", "IV")


## ----split b, echo=TRUE,eval=FALSE--------------------------------------------
## cuts <- sort(orca2$time[orca2$event == 1])
## orca2.spl <-
##   splitLexis(orca2.lex, br = cuts, time.scale = "stime")
## orca2.spl$timeband <- as.factor(orca2.spl$stime)


## ----strsplit, echo=TRUE,eval=FALSE-------------------------------------------
## str(orca2.spl)
## orca2.spl[1:20, ]


## ----poisson, echo=TRUE,eval=FALSE--------------------------------------------
## m2pois1 <- glm(
##   1 * (lex.Xst == "Oral ca. death") ~
##     -1 + timeband + sex + I((age - 65) / 10) + st3,
##   family = poisson, offset = log(lex.dur), data = orca2.spl
## )


## ----poissonresults, echo=TRUE, fig=TRUE,eval=FALSE---------------------------
## tb <- as.numeric(levels(orca2.spl$timeband))
## ntb <- length(tb)
## tbmid <- (tb[-ntb] + tb[-1]) / 2 # midpoints of the intervals
## round(ci.exp(m2pois1), 3)
## par(mfrow = c(1, 1))
## plot(tbmid, 1000 * exp(coef(m2pois1)[1:(ntb - 1)]),
##   ylim = c(5, 3000), log = "xy", type = "l"
## )


## ----poissonspline, echo=TRUE, fig=TRUE,eval=FALSE----------------------------
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

