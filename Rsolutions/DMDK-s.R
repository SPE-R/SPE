## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(keep.source = TRUE, 
                          results = "verbatim", 
                          include = TRUE, 
                             eval = TRUE, 
                          comment = "")
knitr::opts_knit$set(global.par  = TRUE)


## ----echo=FALSE,eval=TRUE-----------------------------------------------------
options(width = 90,
        show.signif.stars = FALSE,
        prompt = " ", continue = " ")
par(mar = c(3,3,1,1),
    mgp = c(3,1,0) / 1.6,
    las = 1,
    bty = "n", 
   lend = "butt")


## ----echo=TRUE, results='hide'------------------------------------------------
library(Epi)
library(popEpi)
library(mgcv)
library(tidyverse)


## -----------------------------------------------------------------------------
data(DMlate)
str(DMlate)


## ----eval = FALSE-------------------------------------------------------------
## ?DMlate


## -----------------------------------------------------------------------------
LL <- Lexis(entry = list(A = dodm - dobth, 
                         P = dodm, 
                       dur = 0),
             exit = list(P = dox),
      exit.status = factor(!is.na(dodth), 
                           labels = c("Alive", "Dead")),
             data = DMlate)


## -----------------------------------------------------------------------------
stat.table(sex,
           list(D = sum(lex.Xst == "Dead"),
                Y = sum(lex.dur),
             rate = ratio(lex.Xst == "Dead", 
                          lex.dur, 
                          1000)),
          margins = TRUE,
             data = LL)
# stat.table is more versatile than xtabs:
xtabs(cbind(D = lex.Xst == "Dead",
            Y = lex.dur) 
      ~ sex, 
      data = LL)


## -----------------------------------------------------------------------------
SL <- splitLexis(LL, 
                 breaks = seq(0, 125, 1 / 2), 
             time.scale = "A")
summary(SL)


## -----------------------------------------------------------------------------
r.m <- mgcv::gam(cbind(lex.Xst == "Dead", lex.dur) ~ s(A, k = 20),
                 family = poisreg,
                   data = subset(SL, sex == "M"))


## -----------------------------------------------------------------------------
r.m <- gam.Lexis(subset(SL, sex == "M"), ~ s(A, k = 20))
r.f <- gam.Lexis(subset(SL, sex == "F"), ~ s(A, k = 20))


## -----------------------------------------------------------------------------
nd <- data.frame(A = seq(20, 90, 0.5))
p.m <- ci.pred(r.m, newdata = nd)
p.f <- ci.pred(r.f, newdata = nd)
str(p.m)


## -----------------------------------------------------------------------------
    par(mar = c(3.5,3.5,1,1),
        mgp = c(3,1,0) / 1.6,
        las = 1,
        bty = "n", 
       lend = "butt")
matplot(nd$A, cbind(p.m, p.f) * 1000,
        type = "l",
         col = rep(c("blue", "red"), each = 3),
         lwd = c(3, 1, 1),
         lty = 1,
         log = "y", yaxt = "n",
        xlab = "Age", 
        ylab = "Mortality per 1000 PY")
axis(side = 2, 
     at = ll <- outer( c(5, 10, 20), -1:1, function(x,y) x * 10^y),
     labels = ll)


## -----------------------------------------------------------------------------
Mcr <- gam.Lexis(subset(SL, sex == "M"),
                 ~ s(A, bs = "cr", k = 10) +
                   s(P, bs = "cr", k = 10) +
                 s(dur, bs = "cr", k = 10))
summary(Mcr)


## -----------------------------------------------------------------------------
Fcr <- gam.Lexis(subset(SL, sex == "F"),
                 ~ s(A, bs = "cr", k = 10) +
                   s(P, bs = "cr", k = 10) +
                 s(dur, bs = "cr", k = 10))
summary(Fcr)


## -----------------------------------------------------------------------------
par(mfrow = c(2, 3))
plot(Mcr, ylim = c(-3, 3))
plot(Fcr, ylim = c(-3, 3))

## -----------------------------------------------------------------------------
par(mfcol = c(3, 2))
plot(Mcr, ylim = c(-3, 3))
plot(Fcr, ylim = c(-3, 3))


## -----------------------------------------------------------------------------
anova(Mcr, r.m, test = "Chisq")


## -----------------------------------------------------------------------------
pts <- seq(0, 12, 1/4)
nd <- data.frame(A = 50   + pts, 
                 P = 1995 + pts, 
               dur =        pts)
m.pr <- ci.pred(Mcr, newdata = nd)


## ----eval = FALSE, results='hide'---------------------------------------------
## cbind(nd, ci.pred(Mcr, newdata = nd))[1:10,]


## ----rates5,fig = TRUE, width = 10, eval = TRUE-------------------------------
Mcr <- gam.Lexis(subset(SL, sex == "M"),
                 ~ s(A, bs = "cr", k = 10) +
                   s(P, bs = "cr", k = 10) +
                 s(dur, bs = "cr", k = 5))
Fcr <- gam.Lexis(subset(SL, sex == "F"),
                 ~ s(A, bs = "cr", k = 10) +
                   s(P, bs = "cr", k = 10) +
                 s(dur, bs = "cr", k = 5))


## ----eval = TRUE--------------------------------------------------------------
str(SL)
SL$Am <- floor(SL$A + 0.25)
SL$Pm <- floor(SL$P + 0.25)
data(M.dk)
str(M.dk)
M.dk <- transform(M.dk,
                  Am = A,
                  Pm = P,
                 sex = factor(sex, labels = c("M", "F")))
str(M.dk)


## ----eval = TRUE--------------------------------------------------------------
SLr <- merge(SL, 
             M.dk[, c("sex", "Am", "Pm", "rate")])
dim(SL)
dim(SLr)


## ----eval = TRUE, echo=FALSE--------------------------------------------------
SLr$E <- SLr$lex.dur * SLr$rate / 1000


## -----------------------------------------------------------------------------
msmr <- glm((lex.Xst == "Dead") ~ sex - 1,
            offset = log(E),
            family = poisson,
              data = subset(SLr, E > 0))
ci.exp(msmr)


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

