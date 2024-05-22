## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(keep.source = TRUE, 
                          results = "verbatim", 
                          include = TRUE, 
                             eval = TRUE, 
                          comment = "")
knitr::opts_knit$set(global.par  = TRUE)


## ----echo=FALSE, eval=TRUE----------------------------------------------------
options(width = 90,
        show.signif.stars = FALSE,
        prompt = " ", continue = " ")
par(mar = c(3,3,1,1),
    mgp = c(3,1,0) / 1.6,
    las = 1,
    bty = "n", 
   lend = "butt")


## ----results = "hide"---------------------------------------------------------
library(Epi)
library(survival)
library(mgcv)
library(foreign)
# renal <- read.dta(
#  "https://raw.githubusercontent.com/SPE-R/SPE/master/pracs/data/renal.dta")
renal <- read.dta("http://BendixCarstensen.com/SPE/data/renal.dta")
renal$sex <- factor(renal$sex, labels = c("M", "F"))
head(renal)


## -----------------------------------------------------------------------------
Lr <- Lexis(entry = list(per = doe,
                         age = doe - dob,
                         tfi = 0),
             exit = list(per = dox),
      exit.status = factor(event > 0, labels = c("NRA", "ESRD")),
             data = renal)
str(Lr)
summary(Lr)


## ----Lexis-ups, fig=TRUE------------------------------------------------------
plot(Lr, col = "black", lwd = 3)
subset(Lr, age < 0)


## ----Lexis-def,fig=TRUE-------------------------------------------------------
Lr <- transform(Lr, age = ifelse(dob > 2000, age + 100, age),
                    dob = ifelse(dob > 2000, dob - 100, dob))
subset(Lr, id == 586)
plot(Lr, col = "black", lwd = 3)


## -----------------------------------------------------------------------------
mc <- coxph(Surv(lex.dur, lex.Xst == "ESRD") 
            ~ I(age / 10) + sex, data = Lr)
summary(mc)


## -----------------------------------------------------------------------------
Lc <- cutLexis(Lr, cut = Lr$dor, # where to cut follow up
             timescale = "per",  # what timescale are we referring to
             new.state = "Rem",  # name of the new state
           split.state = TRUE)   # different states depending on previous
summary(Lc)


## ----eval=FALSE---------------------------------------------------------------
## boxes(Lc)


## ----Lc-boxes,fig=TRUE--------------------------------------------------------
boxes(Lc, boxpos = TRUE, scale.R = 100, show.BE = TRUE, hm = 1.5, wm = 1.5)


## ----Lexis-rem,fig=TRUE-------------------------------------------------------
levels(Lc) # names and order of states in lex.Cst and lex.Xst
par(mai = c(3, 3, 1, 1) / 4, mgp = c(3, 1, 0) / 1.6)
plot(Lc, col = c("red", "limegreen")[Lc$lex.Cst],
        xlab = "Calendar time", ylab = "Age",
         lwd = 3, grid = 0:20 * 5, las = 1,
        xlim = c(1970, 2010), ylim = c(20, 70), 
        xaxs = "i", yaxs = "i")
points(Lc, pch = c(NA, NA, 16, 16)[Lc$lex.Xst],
           col = c("red", "limegreen", "transparent", "transparent")[Lc$lex.Cst])
points(Lc, pch = c(NA, NA, 1, 1)[Lc$lex.Xst],
           col = "black", lwd = 2)


## -----------------------------------------------------------------------------
(EP <- levels(Lc)[3:4])           # define EndPoint states
m1 <- coxph(Surv(tfi,             # entry time
                 tfi + lex.dur,   # exit time
                 lex.Xst %in% EP) # event
            ~ sex + I((doe - dob - 50) / 10) + # fixed covariates
              (lex.Cst == "Rem"),              # time-dependent variable
            data = Lc)
summary(m1)


## -----------------------------------------------------------------------------
sLc <- splitLexis(Lc, "tfi", breaks = seq(0, 30, 1/12))
summary( Lc)
summary(sLc)


## -----------------------------------------------------------------------------
mp <- glm.Lexis(sLc, 
                ~ Ns(tfi, knots = c(0, 2, 5, 10)) +
                  sex + I((doe - dob - 40) / 10) + 
                  I(lex.Cst == "Rem"))
ci.exp(mp)


## -----------------------------------------------------------------------------
mx <- gam.Lexis(sLc,
                ~ s(tfi, k = 10) + 
                  sex + I((doe - dob - 40) / 10) + 
                  I(lex.Cst == "Rem"))
ci.exp(mp, subset = c("Cst", "doe", "sex"))
ci.exp(mx, subset = c("Cst", "doe", "sex"))


## -----------------------------------------------------------------------------
ci.exp(mx, subset = c("sex", "dob", "Cst"), pval = TRUE)
ci.exp(m1)
round(ci.exp(mp, subset = c("sex", "dob", "Cst")) / ci.exp(m1), 2)


## -----------------------------------------------------------------------------
plot(mx)


## ----pred,fig=TRUE------------------------------------------------------------
nd <- data.frame(tfi = seq(0, 20, 0.1),
                 sex = "M",
                 doe = 1990,
                 dob = 1940,
             lex.Cst = "NRA")
str(nd)
matshade(nd$tfi, cbind(ci.pred(mp, newdata = nd),
                       ci.pred(mx, newdata = nd)) * 100,
         plot = TRUE,
         type = "l", lwd = 3:4, col = c("black", "forestgreen"),
         log = "y", xlab = "Time since entry (years)",
         ylab = "ESRD rate (per 100 PY) for 50 year old men")


## ----rem-inc-mgcv-------------------------------------------------------------
mr <- gam.Lexis(sLc, ~ s(tfi, k = 10) + sex,
                     from = "NRA",
                       to = "Rem")
summary(mr)
ci.exp(mr, pval = TRUE)


## -----------------------------------------------------------------------------
inL <- subset(sLc, select = 1:11)[NULL, ]
str(inL)
timeScales(inL)
inL[1, "lex.id"] <- 1
inL[1, "per"] <- 2000
inL[1, "age"] <- 50
inL[1, "tfi"] <- 0
inL[1, "lex.Cst"] <- "NRA"
inL[1, "lex.Xst"] <- NA
inL[1, "lex.dur"] <- NA
inL[1, "sex"] <- "M"
inL[1, "doe"] <- 2000
inL[1, "dob"] <- 1950
inL <- rbind(inL, inL)
inL[2, "sex"] <- "F"
inL
str(inL)


## -----------------------------------------------------------------------------
Tr <- list("NRA" = list("Rem"  = mr,
                        "ESRD" = mx),
           "Rem" = list("ESRD(Rem)" = mx))


## ----first-sim----------------------------------------------------------------
(iL <- simLexis(Tr, inL, N = 10))
summary(iL, by = "sex")


## ----5000-sim-----------------------------------------------------------------
system.time(sM <- simLexis(Tr, inL, N = 500, t.range = 12))
summary(sM, by = "sex")


## ----nState-------------------------------------------------------------------
nStm <- nState(subset(sM, sex == "M"), time.scale = "age", 
               at = seq(0, 10, 0.1), 
             from = 50)
nStf <- nState(subset(sM, sex == "F"), time.scale = "age", 
               at = seq(0, 10, 0.1), 
             from = 50)
head(nStf, 15)


## ----pState-------------------------------------------------------------------
ppm <- pState(nStm, perm = c(2, 1, 3, 4))
ppf <- pState(nStf, perm = c(2, 1, 3, 4))
head(ppf)
tail(ppf)


## ----plot-pp,fig=TRUE---------------------------------------------------------
plot(ppf)


## ----new-nState,fig=TRUE------------------------------------------------------
par(mfrow = c(1, 2))
# Men
plot(ppm, col = c("limegreen", "red", "#991111", "forestgreen"))
lines(as.numeric(rownames(ppm)), ppm[, "NRA"], lwd = 2)
text(59.5, 0.95, "Men", adj = 1, col = "white", font = 2, cex = 1.2)
axis(side = 4, at = 0:10 / 10)
axis(side = 4, at = 1:99 / 100, labels = NA, tck = -0.01)
# Women 
plot(ppf, col = c("limegreen", "red", "#991111", "forestgreen"),
          xlim = c(60, 50)) # inverted x-axis
lines(as.numeric(rownames(ppf)), ppf[, "NRA"], lwd = 2)
text(59.5, 0.95, "Women", adj = 0, col = "white", font = 2, cex = 1.2)
axis(side = 2, at = 0:10 / 10)
axis(side = 2, at = 1:99 / 100, labels = NA, tck = -0.01)

