### R code from vignette source 'DMDK-s.rnw'

###################################################
### code chunk number 1: DMDK-s.rnw:20-24
###################################################
options(width = 90,
        prompt = " ", continue = " ",
        SweaveHooks = list( fig = function()
        par(mar = c(3,3,1,1),mgp = c(3,1,0)/1.6,las = 1,bty = "n")))


###################################################
### code chunk number 2: DMDK-s.rnw:55-60
###################################################
options(width = 90)
library(Epi)
library(popEpi)
library(tidyverse)
library(mgcv)


###################################################
### code chunk number 3: DMDK-s.rnw:63-67
###################################################
data(DMlate)
str(DMlate)
head(DMlate)
summary(DMlate)


###################################################
### code chunk number 4: DMDK-s.rnw:92-94
###################################################
with(DMlate, table(dead = !is.na(dodth),
                   same = (dodth == dox), exclude = NULL))


###################################################
### code chunk number 5: DMDK-s.rnw:98-105
###################################################
LL <- Lexis(entry = list(A = dodm-dobth,
                         P = dodm,
                       dur = 0),
             exit = list(P = dox),
      exit.status = factor(!is.na(dodth),
                           labels = c("Alive","Dead")),
             data = DMlate)


###################################################
### code chunk number 6: DMDK-s.rnw:115-123
###################################################
LL <- Lexis(entry = list(A = dodm-dobth,
                         P = dodm,
                       dur = 0),
             exit = list(P = dox),
      exit.status = factor(!is.na(dodth),
                           labels = c("Alive","Dead")),
             data = DMlate,
     keep.dropped = TRUE)


###################################################
### code chunk number 7: DMDK-s.rnw:126-127
###################################################
attr(LL, 'dropped')


###################################################
### code chunk number 8: DMDK-s.rnw:131-133
###################################################
summary(LL)
head(LL)


###################################################
### code chunk number 9: DMDK-s.rnw:150-156
###################################################
stat.table(sex,
           list(D = sum(lex.Xst == "Dead"),
                Y = sum(lex.dur),
             rate = ratio(lex.Xst == "Dead", lex.dur, 1000)),
           margins = TRUE,
           data = LL)


###################################################
### code chunk number 10: DMDK-s.rnw:195-200
###################################################
system.time(SL <- splitLexis(LL, breaks = seq(0,125,1/2), time.scale = "A"))
summary(SL) ; class(SL)
system.time(SL <- splitMulti(LL, A = seq(0,125,1/2)))
summary(SL) ; class(SL)
summary(LL)


###################################################
### code chunk number 11: DMDK-s.rnw:243-247
###################################################
r.m <- gam(cbind(lex.Xst == "Dead", lex.dur) ~ s(A, k = 20),
            family = poisreg,
              data = subset(SL, sex == "M"))
r.f <- update(r.m, data = subset(SL, sex == "F"))


###################################################
### code chunk number 12: DMDK-s.rnw:257-259
###################################################
r.m <- gam.Lexis(subset(SL, sex == "M"), ~ s(A, k = 20))
r.f <- gam.Lexis(subset(SL, sex == "F"), ~ s(A, k = 20))


###################################################
### code chunk number 13: DMDK-s.rnw:304-308
###################################################
nd <-  data.frame(A = seq(20, 80, 0.5))
p.m <- ci.pred(r.m, newdata = nd)
p.f <- ci.pred(r.f, newdata = nd)
head(p.m)


###################################################
### code chunk number 14: a-rates
###################################################
matplot(nd$A, cbind(p.m, p.f) * 1000,
        type = "l", col = rep(c("blue","red"),each = 3), lwd = c(3,1,1), lty = 1,
        log = "y", xlab = "Age", ylab = "Mortality of DM ptt per 1000 PY")


###################################################
### code chunk number 15: A-rates
###################################################
matshade(nd$A, cbind(p.m,p.f) * 1000, plot = TRUE,
         col = c("blue","red"), lty = 1, lwd = 3,
         log = "y", xlab = "Age", ylab = "Mortality among DM ptt per 1000 PY")


###################################################
### code chunk number 16: DMDK-s.rnw:378-388
###################################################
Mcr <- gam.Lexis(subset(SL, sex == "M"),
                 ~ s(  A, bs = "cr", k = 10) +
                   s(  P, bs = "cr", k = 10) +
                   s(dur, bs = "cr", k = 10))
summary(Mcr)
Fcr <- gam.Lexis(subset(SL, sex == "F"),
                 ~ s(  A, bs = "cr", k = 10) +
                   s(  P, bs = "cr", k = 10) +
                   s(dur, bs = "cr", k = 10))
summary(Fcr)


###################################################
### code chunk number 17: plgam-default
###################################################
par(mfcol = c(3,2))
plot(Fcr, ylim = c(-3,3), col = "red")
plot(Mcr, ylim = c(-3,3), col = "blue",
          lwd = 2, shade = TRUE, shade.col = adjustcolor("blue", alpha = 0.15))


###################################################
### code chunk number 18: DMDK-s.rnw:426-428
###################################################
anova(Mcr, r.m, test = "Chisq")
anova(Fcr, r.f, test = "Chisq")


###################################################
### code chunk number 19: DMDK-s.rnw:480-485
###################################################
pts <- seq(0, 12, 1/4)
nd <- data.frame(A =   50 + pts,
                 P = 1995 + pts,
               dur =        pts)
head(cbind(nd$A, ci.pred(Mcr, newdata = nd) * 1000))


###################################################
### code chunk number 20: rates
###################################################
plot(NA, xlim = c(50, 85), ylim = c(5, 400), log = "y",
         xlab = "Age", ylab = "Mortality rate for DM patients")
for(ip in c(1995, 2005))
for(ia in c(50, 60, 70))
   {
nd <- data.frame(A = ia + pts,
                 P = ip + pts,
               dur =      pts)
matshade(nd$A, ci.pred(Mcr, nd) * 1000, col = "blue", lty = 1 + (ip == 1995))
matshade(nd$A, ci.pred(Fcr, nd) * 1000, col = "red" , lty = 1 + (ip == 1995))
   }


###################################################
### code chunk number 21: rates5
###################################################
Mcr <- gam.Lexis(subset(SL, sex == "M"),
                 ~ s(  A, bs = "cr", k = 10) +
                   s(  P, bs = "cr", k = 10) +
                   s(dur, bs = "cr", k = 5))
summary(Mcr)
Fcr <- gam.Lexis(subset(SL, sex == "F"),
                 ~ s(  A, bs = "cr", k = 10) +
                   s(  P, bs = "cr", k = 10) +
                   s(dur, bs = "cr", k = 5))
summary(Fcr)
gam.check(Mcr)
gam.check(Fcr)


###################################################
### code chunk number 22: rates-5
###################################################
plot(NA, xlim = c(50,80), ylim = c(0.9,100), log = "y",
         xlab = "Age", ylab = "Mortality rate for DM patients")
abline(v = c(50,55,60,65,70), col = gray(0.8))
# for(ip in c(1995,2005))
ip <- 2005
for(ia in seq(50, 70, 5))
   {
nd <- data.frame(A = ia + pts,
                 P = ip + pts,
               dur =      pts)
matshade(nd$A, rm <- ci.pred(Mcr, nd) * 1000, col = "blue", lwd = 2)
matshade(nd$A, rf <- ci.pred(Fcr, nd) * 1000, col = "red" , lwd = 2)
matshade(nd$A, ci.ratio(rm, rf), lwd = 2)
   }
abline(h = 1, lty = "55")


###################################################
### code chunk number 23: DMDK-s.rnw:690-692
###################################################
SL$Am <- floor(SL$A + 0.25)
SL$Pm <- floor(SL$P + 0.25)


###################################################
### code chunk number 24: DMDK-s.rnw:696-704
###################################################
data(M.dk)
str(M.dk)
M.dk <- transform(M.dk, Am = A,
                        Pm = P,
                       sex = factor(sex, labels = c("M","F")))
head(M.dk)
str(SL)
str(M.dk)


###################################################
### code chunk number 25: DMDK-s.rnw:709-712
###################################################
SLr <- merge(SL, M.dk[,c("sex", "Am", "Pm", "rate")])
dim(SL)
dim(SLr)


###################################################
### code chunk number 26: DMDK-s.rnw:721-724
###################################################
SLi <- inner_join(SL, M.dk[,c("sex","Am","Pm","rate")])
dim(SL)
dim(SLi)


###################################################
### code chunk number 27: DMDK-s.rnw:737-755
###################################################
SLr$E <- SLr$lex.dur * SLr$rate / 1000
stat.table(sex,
           list(D = sum(lex.Xst == "Dead"),
                Y = sum(lex.dur),
                E = sum(E),
              SMR = ratio(lex.Xst == "Dead",E)),
           data = SLr,
           margin = TRUE)
stat.table(list(sex,
                Age = cut(A,
                          breaks = c(0, 4:9*10, 100),
                          right = FALSE)),
           list(D = sum(lex.Xst == "Dead"),
                Y = sum(lex.dur),
                E = sum(E),
              SMR = ratio(lex.Xst == "Dead", E)),
           margin = TRUE,
             data = SLr)


###################################################
### code chunk number 28: DMDK-s.rnw:777-781
###################################################
msmr <- glm((lex.Xst == "Dead") ~ sex - 1 + offset(log(E)),
            family = poisson,
              data = subset(SLr, E > 0))
ci.exp(msmr)


###################################################
### code chunk number 29: DMDK-s.rnw:805-809
###################################################
msmr <- glm(cbind(lex.Xst == "Dead", E) ~ sex - 1,
            family = poisreg,
              data = subset(SLr, E > 0))
ci.exp(msmr)


###################################################
### code chunk number 30: DMDK-s.rnw:813-817
###################################################
(CM <- rbind(M = c(1,0),
             W = c(0,1),
         'M/F' = c(1,-1)))
round(ci.exp(msmr, ctr.mat = CM), 2)


###################################################
### code chunk number 31: SMReff
###################################################
Msmr <- gam(cbind(lex.Xst == "Dead", E) ~ s(  A, bs = "cr", k = 10) +
                                          s(  P, bs = "cr", k = 10) +
                                          s(dur, bs = "cr", k = 5),
            family = poisreg,
              data = subset(SLr, E > 0 & sex == "M"))
Fsmr <- update(Msmr, data = subset(SLr, E > 0 & sex == "F"))
summary(Msmr)
summary(Fsmr)
par(mfcol = c(3,2))
plot(Msmr, ylim = c(-1,2), col = "blue")
plot(Fsmr, ylim = c(-1,2), col = "red")


###################################################
### code chunk number 32: SMRsm
###################################################
plot(NA, xlim = c(50,80), ylim = c(0.5,5), log = "y",
         xlab = "Age", ylab = "SMR relative to total population")
abline(v = c(50,55,60,65,70), col = gray(0.8))
# for(ip in c(1995,2005))
ip <- 2005
for(ia in c(50,60,70))
   {
nd <- data.frame(A = ia + pts,
                 P = ip + pts,
               dur =      pts)
matshade(nd$A, rm <- ci.pred(Msmr, nd), col = "blue", lwd = 2)
matshade(nd$A, rf <- ci.pred(Fsmr, nd), col = "red" , lwd = 2)
matshade(nd$A, ci.ratio(rm, rf), lwd = 2, col = gray(0.5))
   }
abline(h = 1, lty = "55")


###################################################
### code chunk number 33: DMDK-s.rnw:913-921
###################################################
Asmr <- gam(cbind(lex.Xst == "Dead", E) ~ sex +
                                          sex:I(A - 60) +
                                          sex:I(P - 2005) +
                                          s(dur, k = 5),
             family = poisreg,
               data = subset(SLr, E > 0))
summary(Asmr)
round((ci.exp(Asmr, subset = "sex") - 1) * 100, 1)


###################################################
### code chunk number 34: SMRsl
###################################################
plot(NA, xlim = c(50,80), ylim = c(0.8,5), log = "y",
          xlab = "Age", ylab = "SMR relative to total population")
abline(v = c(50,55,60,65,70), col = gray(0.8))
# for(ip in c(1995,2005))
ip <- 2005
for(ia in c(50,55,60,65,70))
   {
nd <- data.frame(A = ia + pts,
                 P = ip + pts,
               dur =      pts)
matshade(nd$A, rm <- ci.pred(Asmr, cbind(nd,sex = "M")), col = "blue", lwd = 2)
matshade(nd$A, rf <- ci.pred(Asmr, cbind(nd,sex = "F")), col = "red" , lwd = 2)
matshade(nd$A, ci.ratio(rm, rf), lwd = 2, col = gray(0.5))
   }
abline(h = 1, lty = "55")


