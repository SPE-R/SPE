options(width = 90)
par(mar = c(3,3,1,1),
    mgp = c(3,1,0) / 1.6,
    las = 1,
    bty = "n",
   lend = "butt")

#-----------------------------------------------------------------------------
library(Epi)
library(popEpi)
library(mgcv)
library(tidyverse)

#-----------------------------------------------------------------------------
data(DMlate)
str(DMlate)

## -----------------------------------------------------------------------------
LL <- Lexis(entry = list(A = dodm - dobth,
                         P = dodm,
                       dur = 0),
             exit = list(P = dox),
      exit.status = factor(!is.na(dodth),
                           labels = c("Alive", "Dead")),
             data = DMlate)
head(LL)
summary(LL)

#-----------------------------------------------------------------------------
stat.table(sex,
           list(D = sum(lex.Xst == "Dead"),
                Y = sum(lex.dur),
             rate = ratio(lex.Xst == "Dead",
                          lex.dur,
                          1000)),
          margins = TRUE,
             data = LL)

# stat.table is more versatile than xtabs, but xtabs more compact--------------
xtabs(cbind(D = lex.Xst == "Dead",
            Y = lex.dur)
      ~ sex,
      data = LL)

# neither gives confidence intervals so we model--------------------------------
SL <- splitLexis(LL,
                 breaks = seq(0, 125, 1 / 2),
             time.scale = "A")
summary(SL)

# model for men  ---------------------------------------------------------------
r.m <- gam(cbind(lex.Xst == "Dead", lex.dur) ~ s(A, k = 20),
                 family = poisreg,
                   data = subset(SL, sex == "M"))

#-simpler modeling using the Lexisi attributes in SL ---------------------------
r.m <- gam.Lexis(subset(SL, sex == "M"), ~ s(A, k = 20))
r.f <- gam.Lexis(subset(SL, sex == "F"), ~ s(A, k = 20))

# fitted ok ? ------------------------------------------------------------------
gam.check(r.f)

# predicting age-specific rates ------------------------------------------------
nd <- data.frame(A = seq(20, 90, 0.5))
p.m <- ci.pred(r.m, newdata = nd)
p.f <- ci.pred(r.f, newdata = nd)
str(p.m)

#-------------------------------   ---------------------------------------------
par(mar = c(3.5,3.5,1,1),
    mgp = c(3,1,0) / 1.6,
    las = 1,
    bty = "n",
   lend = "butt")
matshade(nd$A, cbind(p.m, p.f) * 1000, plot = TRUE,
        type = "l",
         col = c("blue", "red"),
         lwd = c(3, 1, 1),
         lty = 1,
         log = "y", yaxt = "n",
        xlab = "Age",
        ylab = "Mortality per 1000 PY")
axis(side = 2,
     at = ll <- outer(c(5, 10, 20), -1:1, function(x,y) x * 10^y),
     labels = ll)

# modeling by more time scales -------------------------------------------------
Mcr <- gam.Lexis(subset(SL, sex == "M"),
                 ~ s(A, bs = "cr", k = 10) +
                   s(P, bs = "cr", k = 10) +
                 s(dur, bs = "cr", k = 10))
Fcr <- gam.Lexis(subset(SL, sex == "F"),
                 ~ s(A, bs = "cr", k = 10) +
                   s(P, bs = "cr", k = 10) +
                 s(dur, bs = "cr", k = 10))
summary(Mcr)
summary(Fcr)

#--------------------------------------------------------------------------------
par(mfrow = c(2, 3))
plot(Mcr, ylim = c(-3, 3))
plot(Fcr, ylim = c(-3, 3))
#--------------------------------------------------------------------------------
par(mfcol = c(3, 2))
plot(Mcr, ylim = c(-3, 3))
plot(Fcr, ylim = c(-3, 3))

#--------------------------------------------------------------------------------
anova(Mcr, r.m, test = "Chisq")

# Predicting frames -------------------------------------------------------------
pts <- seq(0, 12, 1/4)
nd <- data.frame(A = 50   + pts,
                 P = 1995 + pts,
               dur =        pts)
m.pr <- ci.pred(Mcr, newdata = nd)
par(mfrow = c(1,1))
matshade(nd$A, m.pr, plot = TRUE,
         col = "blue",
         log = "y")

# For men diagnosed different ages----------------------------------------------
nd50 <- nd
nd60 <- mutate(nd, A = A + 10)
nd70 <- mutate(nd, A = A + 20)
m.pr50 <- ci.pred(Mcr, newdata = nd50)
m.pr60 <- ci.pred(Mcr, newdata = nd60)
m.pr70 <- ci.pred(Mcr, newdata = nd70)
matshade(nd50$A, m.pr50 * 1000,
         plot = TRUE,
         col = "blue", lwd = 3,
         log = "y",
         xlim = c(50,80), ylim = c(10, 200),
         xlab = "Age at FU",
         ylab = "Motality rater per 1000 PY")
matshade(nd60$A, m.pr60 * 1000, col = "blue", lwd = 3)
matshade(nd70$A, m.pr70 * 1000, col = "blue", lwd = 3)

#--------------------------------------------------------------------------------
str(SL)

########## SMR ############

# where is the midpoints of the follow-up intervals?
SL$Am <- floor(SL$A + 0.25)
SL$Pm <- floor(SL$P + 0.25)

# population mortality
data(M.dk)
str(M.dk)
M.dk <- transform(M.dk,
                  Am = A,
                  Pm = P,
                 sex = factor(sex, labels = c("M", "F")))
str(M.dk)
# Am, Pm, sex are now common variables between SL and M.dk, so merge
SLr <- merge(SL, M.dk[, c("sex", "Am", "Pm", "rate")])
SLr <- left_join(SL, M.dk[, c("sex", "Am", "Pm", "rate")])
dim(SL)
dim(SLr)

# Expected number of deaths ----------------------------------------------------
SLr$E <- SLr$lex.dur * SLr$rate / 1000

## -----------------------------------------------------------------------------
msmr <- glm(cbind(lex.Xst == "Dead", E) ~ sex - 1,
            family = poisreg,
              data = subset(SLr, E > 0))
ci.exp(msmr)

## -----------------------------------------------------------------------------
(CM <- rbind(M = c(1, 0),
             W = c(0, 1),
         "M/F" = c(1, -1)))
round(ci.exp(msmr, ctr.mat = CM), 2)
# ...see package 'publish'

## -----------------------------------------------------------------------------
Msmr <- gam(cbind(lex.Xst == "Dead", E)
            ~ s(  A, bs = "cr", k = 5) +
              s(  P, bs = "cr", k = 5) +
              s(dur, bs = "cr", k = 5),
            family = poisreg,
              data = subset(SLr, E > 0 & sex == "M"))
ci.exp(Msmr)
Fsmr <- update(Msmr, data = subset(SLr, E > 0 & sex == "F"))

## -----------------------------------------------------------------------------
par(mfrow = c(1,1))
n50 <- nd
n60 <- mutate(n50, A = A + 10)
n70 <- mutate(n50, A = A + 20)
head(n70)
matshade(n50$A, cbind(ci.pred(Msmr, n50),
                      ci.pred(Fsmr, n50)), plot = TRUE,
         col = c("blue", "red"), lwd = 3,
         ylim = c(0.5, 5), log  = "y", xlim = c(50, 80))
matshade(n60$A, cbind(ci.pred(Msmr, n60),
                      ci.pred(Fsmr, n60)),
         col = c("blue", "red"), lwd = 3)
matshade(n70$A, cbind(ci.pred(Msmr, n70),
                      ci.pred(Fsmr, n70)),
         col = c("blue", "red"), lwd = 3)
abline(h = 1)
abline(v = 50 + 0:5, lty = 3, col = "gray")

## -----------------------------------------------------------------------------
Bsmr <- gam(cbind(lex.Xst == "Dead", E)
            ~ sex / A +
              sex / P +
              s(dur, bs = "cr", k = 5),
            family = poisreg,
              data = subset(SLr, E > 0))
round(ci.exp(Bsmr)[-1,], 3)

## -----------------------------------------------------------------------------
m50 <- mutate(n50, sex = "M")
f50 <- mutate(n50, sex = "F")
m60 <- mutate(m50, A = A + 10)
f60 <- mutate(f50, A = A + 10)
m70 <- mutate(m50, A = A + 20)
f70 <- mutate(f50, A = A + 20)
matshade(n50$A, cbind(ci.pred(Bsmr, m50),
                      ci.pred(Bsmr, f50)), plot = TRUE,
         col = c("blue", "red"), lwd = 3,
         ylim = c(0.5, 5), log  = "y", xlim = c(50, 80))
matshade(n60$A, cbind(ci.pred(Bsmr, m60),
                      ci.pred(Bsmr, f60)),
         col = c("blue", "red"), lwd = 3)
matshade(n70$A, cbind(ci.pred(Bsmr, m70),
                      ci.pred(Bsmr, f70)),
         col = c("blue", "red"), lwd = 3)
abline(h = 1)
abline(h = 1:5, lty = 3, col = "gray")
