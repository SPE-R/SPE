## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(results = "markup", keep.source = TRUE, include = FALSE, eps = FALSE, prefix.string = "./graph/rates-rrrd")


## ----eval=FALSE---------------------------------------------------------------
## library(Epi)
## options(digits = 4) #  to cut down decimal points in the output

## ----eval=FALSE---------------------------------------------------------------
## D <- 15
## Y <- 5.532 # thousands of years!
## rate <- D / Y
## SE.rate <- rate / sqrt(D)
## c(rate, SE.rate, rate + c(-1.96, 1.96) * SE.rate)


## ----eval=FALSE---------------------------------------------------------------
## mreg <- glm(cbind(D, Y) ~ 1, family = poisreg(link = log))
## ci.exp(mreg)


## ----eval=FALSE---------------------------------------------------------------
## mreg <- glm(cbind(D, Y) ~ 1, family = poisreg(link = log))
## ci.lin(mreg)[, c(1, 5, 6)]


## ----eval=FALSE---------------------------------------------------------------
## mid <- glm(cbind(D, Y) ~ 1, family = poisreg(link = "identity"))
## ci.lin(mid)
## ci.lin(mid)[, c(1, 5, 6)]


## ----eval=FALSE---------------------------------------------------------------
## Dx <- c(3, 7, 5)
## Yx <- c(1.412, 2.783, 1.337)
## Px <- 1:3
## rates <- Dx / Yx
## rates


## ----eval=FALSE---------------------------------------------------------------
## m3 <- glm(cbind(Dx, Yx) ~ 1, family = poisreg(link = log))
## ci.exp(m3)


## ----eval=FALSE---------------------------------------------------------------
## mp <- glm(cbind(Dx, Yx) ~ factor(Px), family = poisreg(link = log))
## ci.exp(mp)


## ----eval=FALSE---------------------------------------------------------------
## anova(m3, mp, test = "Chisq")


## -----------------------------------------------------------------------------
D0 <- 15
D1 <- 28
Y0 <- 5.532
Y1 <- 4.783


## ----eval=FALSE---------------------------------------------------------------
## D <- c(D0, D1)
## Y <- c(Y0, Y1)
## expos <- 0:1
## mm <- glm(cbind(D, Y) ~ factor(expos), family = poisreg(link = log))


## ----eval=FALSE---------------------------------------------------------------
## ci.exp(mm)
## ci.lin(mm, Exp = TRUE)[, 5:7]


## ----eval=FALSE---------------------------------------------------------------
## R0 <- D0 / Y0
## R1 <- D1 / Y1
## RD <- diff(D / Y)
## SED <- sqrt(sum(D / Y^2))
## c(R1, R0, RD, SED, RD + c(-1, 1) * 1.96 * SED)


## ----eval=FALSE---------------------------------------------------------------
## ma <- glm(cbind(D, Y) ~ factor(expos),
##   family = poisreg(link = identity)
## )
## ci.lin(ma)[, c(1, 5, 6)]


## ----Run births-house 2,eval=FALSE--------------------------------------------
## library(dplyr)
## library(Epi)
## data(births)
## str(births)


## ----eval=FALSE---------------------------------------------------------------
## births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
## births$sex <- factor(births$sex, labels = c("M", "F"))
## births$gest4 <- cut(births$gestwks,
##   breaks = c(20, 35, 37, 39, 45), right = FALSE
## )
## births$maged <- ifelse(births$matage < 35, 0, 1)


## ----eval=FALSE---------------------------------------------------------------
## births %>%
##   count(hyp, lowbw) %>%
##   group_by(hyp) %>% # now required with changes to dplyr::count()
##   mutate(prop = prop.table(n))


## ----eval=FALSE---------------------------------------------------------------
## births2<-births
## births2$lowbw<-factor(2-births2$lowbw,labels=c("Yes","No"))
## births2$hyp<-factor(2-as.numeric(births2$hyp),labels=c("Hypertensive","Normal"))
## twoby2(births2$hyp,births2$lowbw)
## 
## 


## ----eval=FALSE---------------------------------------------------------------
## m <- glm(lowbw ~ hyp, family = binomial(link = "identity"), data = births)
## round(ci.lin(m),3)[,c(1,5:6)]


## ----eval=FALSE---------------------------------------------------------------
## m <- glm(lowbw ~ hyp, family = binomial(link = log), data = births)
## ci.exp(m)


## ----eval=FALSE---------------------------------------------------------------
## library(Epi)
## options(digits = 4) #  to cut down decimal points in the output


## ----eval=FALSE---------------------------------------------------------------
## D <- 15
## Y <- 5.532 # thousands of years!
## rate <- D / Y
## SE.rate <- rate / sqrt(D)
## c(rate, SE.rate, rate + c(-1.96, 1.96) * SE.rate)


## ----eval=FALSE---------------------------------------------------------------
## SE.logr <- 1 / sqrt(D)
## EF <- exp(1.96 * SE.logr)
## c(log(rate), SE.logr)
## c(rate, EF, rate / EF, rate * EF)


## ----eval=FALSE---------------------------------------------------------------
## D0 <- 15
## D1 <- 28
## Y0 <- 5.532
## Y1 <- 4.783
## R1 <- D1 / Y1
## R0 <- D0 / Y0
## RR <- R1 / R0
## SE.lrr <- sqrt(1 / D0 + 1 / D1)
## EF <- exp(1.96 * SE.lrr)
## c(R1, R0, RR, RR / EF, RR * EF)


## ----eval=FALSE---------------------------------------------------------------
## ci.mat
## ci.mat()


## ----eval=FALSE---------------------------------------------------------------
## rateandSE <- c(rate, SE.rate)
## rateandSE
## rateandSE %*% ci.mat()


## ----eval=FALSE---------------------------------------------------------------
## lograndSE <- c(log(rate), SE.logr)
## lograndSE
## exp(lograndSE %*% ci.mat())


## ----eval=FALSE---------------------------------------------------------------
## exp(c(log(RR), SE.lrr) %*% ci.mat())


## ----eval=FALSE---------------------------------------------------------------
## ci.mat(alpha = 0.1)
## exp(c(log(RR), SE.lrr) %*% ci.mat(alpha = 0.1))


## ----eval=FALSE---------------------------------------------------------------
## D <- c(D0, D1)
## Y <- c(Y0, Y1)
## expos <- 0:1


## ----eval=FALSE---------------------------------------------------------------
## CM <- rbind(c(1, 0), c(1, 1), c(0, 1))
## rownames(CM) <- c("rate 0", "rate 1", "RR 1 vs. 0")
## CM
## mm <- glm(D ~ factor(expos),
##   family = poisson(link = log), offset = log(Y)
## )
## ci.exp(mm, ctr.mat = CM)


## ----eval=FALSE---------------------------------------------------------------
## rownames(CM) <- c("rate 0", "rate 1", "RD 1 vs. 0")
## ma <- glm(cbind(D, Y) ~ factor(expos),
##   family = poisreg(link = identity)
## )
## ci.lin(ma, ctr.mat = CM)[, c(1, 5, 6)]

