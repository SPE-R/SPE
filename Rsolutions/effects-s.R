## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(results = "markup", fig.show="hide", message=FALSE, prefix.string = "./graph/effects", include=TRUE)


## ----Run births-house---------------------------------------------------------
library(Epi)
library(mgcv)
data(births)
str(births)


## ----housekeeping of births---------------------------------------------------
births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
births$sex <- factor(births$sex, labels = c("M", "F"))
births$maged <- cut(births$matage, breaks = c(22, 35, 44), right = FALSE)
births$gest4 <- cut(births$gestwks,
  breaks = c(20, 35, 37, 39, 45), right = FALSE)


## ----summary of births--------------------------------------------------------
summary(births)
with(births, sd(bweight))


## ----t test for hyp on bweight------------------------------------------------
with(births, t.test(bweight ~ hyp, var.equal = TRUE))


## ----lm of bweight by hyp-----------------------------------------------------
m1 <- glm(bweight ~ hyp, family = gaussian, data = births)
summary(m1)


## ----ci.lin of bweight by hyp-------------------------------------------------
round(ci.lin(m1)[, c(1, 5, 6)], 1)


## ----bweight-by-hyp-sex, fig = FALSE------------------------------------------
par(mfrow = c(1, 1))
with(births, interaction.plot(sex, hyp, bweight))


## ----lm for hyp on bweight stratified by sex----------------------------------
m3 <- lm(bweight ~ sex / hyp, data = births)
round(ci.lin(m3)[, c(1, 5, 6)], 1)


## ----lmIa for hyp on bweight stratified by sex--------------------------------
m3I <- lm(bweight ~ sex + hyp + sex:hyp, data = births)
round(ci.lin(m3I)[, c(1, 4, 5, 6)], 2)


## ----lm for hyp on bweight controlled for sex---------------------------------
m4 <- lm(bweight ~ sex + hyp, data = births)
ci.lin(m4)[, c(1, 5, 6)]


## ----Linear effect of gestwks on bweight--------------------------------------
m5 <- lm(bweight ~ gestwks, data = births)
ci.lin(m5)[, c(1, 5, 6)]


## ----Plot-bweight-by-gestwks, fig = FALSE-------------------------------------
with(births, plot(gestwks, bweight))
abline(m5)


## ----bweight-gestwks-m5-diag, fig= FALSE--------------------------------------
par(mfrow = c(2, 2))
plot(m5)


## ----bweight-gestwks-mPs------------------------------------------------------
mPs <- mgcv::gam(bweight ~ s(gestwks), data = births)
summary(mPs)


## ----mPs-sig2-----------------------------------------------------------------
mPs$sig2
sqrt(mPs$sig2)


## ----plotFitPredInt, ECHO=TRUE------------------------------------------------
plotFitPredInt <- function(xval, fit, pred, ...) {
  matshade(xval, fit, lwd = 2, alpha = 0.2)
  matshade(xval, pred, lwd = 2, alpha = 0.2)
  matlines(xval, fit, lty = 1, lwd = c(3, 2, 2), col = c("black", "blue", "blue"))
  matlines(xval, pred, lty = 1, lwd = c(3, 2, 2), col = c("black", "brown", "brown"))
}


## ----bweight-gestwks-mPs-plot, fig=FALSE--------------------------------------
nd <- data.frame(gestwks = seq(24, 45, by = 0.25))
pr.Ps <- predict(mPs, newdata = nd, se.fit = TRUE)
str(pr.Ps) # with se.fit=TRUE, only two columns: fitted value and its SE
fit.Ps <- cbind(
  pr.Ps$fit,
  pr.Ps$fit - 2 * pr.Ps$se.fit,
  pr.Ps$fit + 2 * pr.Ps$se.fit
)
pred.Ps <- cbind(
  pr.Ps$fit, # must add residual variance to se.fit^2
  pr.Ps$fit - 2 * sqrt(pr.Ps$se.fit^2 + mPs$sig2),
  pr.Ps$fit + 2 * sqrt(pr.Ps$se.fit^2 + mPs$sig2)
)
par(mfrow = c(1, 1))
with(births, plot(bweight ~ gestwks,
  xlim = c(24, 45),
  cex.axis = 1.5, cex.lab = 1.5
))
plotFitPredInt(nd$gestwks, fit.Ps, pred.Ps)


## ----lowbw-hyp-table----------------------------------------------------------
stat.table(
  index = list(hyp, lowbw),
  contents = list(count(), percent(lowbw)),
  margins = TRUE, data = births
)


## ----lowbw-hyp-comp-----------------------------------------------------------
binRD <- glm(lowbw ~ hyp, family = binomial(link = "identity"), data = births)
round(ci.lin(binRD)[, c(1, 2, 5:6)], 3)
binRR <- glm(lowbw ~ hyp, family = binomial(link = "log"), data = births)
round(ci.lin(binRR, Exp = TRUE)[, c(1, 2, 5:7)], 3)
binOR <- glm(lowbw ~ hyp, family = binomial(link = "logit"), data = births)
round(ci.lin(binOR, Exp = TRUE)[, c(1, 2, 5:7)], 3)


## ----lowbw-gestwks-table------------------------------------------------------
stat.table(
  index = list(gest4, lowbw),
  contents = list(count(), percent(lowbw)),
  margins = TRUE, data = births
)


## ----lowbw-gestwks-spline, fig=FALSE------------------------------------------
binm1 <- mgcv::gam(lowbw ~ s(gestwks), family = binomial(link = "logit"), data = births)
summary(binm1)
plot(binm1)


## ----lowbw-gestwks-logitlin---------------------------------------------------
binm2 <- glm(lowbw ~ I(gestwks - 40), family = binomial(link = "logit"), data = births)
round(ci.lin(binm2, Exp = TRUE)[, c(1, 2, 5:7)], 3)


## ----lowbw-gestwks-pred, fig=FALSE--------------------------------------------
predm2 <- predict(binm2, newdata = nd, type = "response")
plot(nd$gestwks, predm2, type = "l")

