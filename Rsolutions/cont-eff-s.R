## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(results = "markup", keep.source = TRUE, include = TRUE, eps = FALSE, prefix.string = "./graph/cont-eff")


## ----echo=FALSE---------------------------------------------------------------
# opt <- options()
# options( width=90,
#          SweaveHooks=list( fig=function()
#          par(mar=c(3,3,1,1),mgp=c(3,1,0)/1.6,las=1,bty="n") ) )


## ----data-input---------------------------------------------------------------
library(Epi)
library(mgcv)
data(testisDK)
str(testisDK)
summary(testisDK)
head(testisDK)


## ----housekeeping-------------------------------------------------------------
tdk <- subset(testisDK, A > 14 & A < 80)
tdk$Age <- cut(tdk$A, br = 5 * (3:16), include.lowest = TRUE, right = FALSE)
nAge <- length(levels(tdk$Age))
tdk$Per <- cut(tdk$P,
  br = seq(1943, 1998, by = 5),
  include.lowest = TRUE, right = FALSE)
nPer <- length(levels(tdk$Per))


## ----tabulation---------------------------------------------------------------
tab <- stat.table(
  index = list(Age, Per),
  contents = list(
    D = sum(D),
    Y = sum(Y / 1000),
    rate = ratio(D, Y, 10^5)
  ),
  margins = TRUE,
  data = tdk
)
str(tab)


## ----plot-rates, fig=FALSE----------------------------------------------------
str(tab)
par(mfrow = c(1, 1))
rateplot(
  rates = tab[3, 1:nAge, 1:nPer], which = "ap", ylim = c(1, 30),
  age = seq(15, 75, 5), per = seq(1943, 1993, 5),
  col = heat.colors(16), ann = TRUE
)


## ----mCat---------------------------------------------------------------------
tdk$Y <- tdk$Y / 100000
mCat <- glm(cbind(D, Y) ~ Age + Per,
  family = poisreg(link = log), data = tdk )
round(ci.exp(mCat), 2)


## ----mCat-est, fig=FALSE------------------------------------------------------
aMid <- seq(17.5, 77.5, by = 5)
pMid <- seq(1945, 1995, by = 5)
par(mfrow = c(1, 2))
matplot(aMid, rbind(c(1,1,1), ci.exp(mCat)[2:13, ]), type = "o", pch = 16,     
   log = "y", cex.lab = 1.5, cex.axis = 1.5, col=c("black", "blue", "blue"),
  xlab = "Age (years)", ylab = "Rate ratio" )
matplot(pMid, rbind(c(1,1,1), ci.exp(mCat)[14:23, ]), type = "o", pch = 16,
  log = "y", cex.lab = 1.5, cex.axis = 1.5, col=c("black", "blue", "blue"),
  xlab = "Calendar year - 1900", ylab = "Rate ratio" )


## ----mCat2-new-ref------------------------------------------------------------
tdk$Per70 <- Relevel(tdk$Per, ref = 6)
mCat2 <- glm(cbind(D, Y) ~ -1 + Age + Per70,
  family = poisreg(link = log), data = tdk )
round(ci.exp(mCat2), 2)


## ----mCat2-plot, fig =FALSE---------------------------------------------------
par(mfrow = c(1, 2))
matplot(aMid, rbind(c(1,1,1), ci.exp(mCat2)[2:13, ]), type = "o", pch = 16,     
   log = "y", cex.lab = 1.5, cex.axis = 1.5, col=c("black", "blue", "blue"),
  xlab = "Age (years)", ylab = "Rate ratio" )
matplot(pMid, rbind(ci.exp(mCat2)[14:18, ], c(1,1,1), ci.exp(mCat2)[19:23, ]),
        type = "o", pch = 16, log = "y", cex.lab = 1.5, cex.axis = 1.5,
        col=c("black", "blue", "blue"),
  xlab = "Calendar year - 1900", ylab = "Rate ratio" )
abline(h = 1, col = "gray")


## ----mPen---------------------------------------------------------------------
library(mgcv)
mPen <- mgcv::gam(cbind(D, Y) ~ s(A) + s(P),
  family = poisreg(link = log), data = tdk
)
summary(mPen)


## ----mPen-plot, fig=FALSE-----------------------------------------------------
par(mfrow = c(1, 2))
plot(mPen, seWithMean = TRUE)


## ----mPen-check---------------------------------------------------------------
par(mfrow = c(2, 2))
gam.check(mPen)


## ----mPen2--------------------------------------------------------------------
mPen2 <- mgcv::gam(cbind(D, Y) ~ s(A, k = 20) + s(P),
  family = poisreg(link = log), data = tdk
)
summary(mPen2)
par(mfrow = c(2, 2))
gam.check(mPen2)


## ----mPen2-plot, fig=FALSE----------------------------------------------------
par(mfrow = c(1, 2))
plot(mPen2, seWithMean = TRUE)
abline(v = 1968, h = 0, lty = 3)


## ----mPen2-newplot------------------------------------------------------------
par(mfrow = c(1, 2))
icpt <- coef(mPen2)[1] #  estimated intecept
plot(mPen2,
  seWithMean = TRUE, select = 1, rug = FALSE,
  yaxt = "n", ylim = c(log(1), log(20)) - icpt,
  xlab = "Age (y)", ylab = "Mean rate (/100000 y)"
)
axis(2, at = log(c(1, 2, 5, 10, 20)) - icpt, labels = c(1, 2, 5, 10, 20))
plot(mPen2,
  seWithMean = TRUE, select = 2, rug = FALSE,
  yaxt = "n", ylim = c(log(0.4), log(2)),
  xlab = "Calendat year", ylab = "Relative rate"
)
axis(2, at = log(c(0.5, 0.75, 1, 1.5, 2)), labels = c(0.5, 0.75, 1, 1.5, 2))
abline(v = 1968, h = 0, lty = 3)

