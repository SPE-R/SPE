## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(keep.source = TRUE, eps = FALSE, results = "markup", prefix.string = "./graph/occoh-caco")


## ----Read in occoh data, echo=TRUE--------------------------------------------
library(Epi)
library(survival)
url <- "https://raw.githubusercontent.com/SPE-R/SPE/master/pracs/data"
oc <- read.table(paste(url, "occoh.txt", sep = "/"), header = TRUE)
str(oc)
summary(oc)


## ----cal.yr, echo=TRUE--------------------------------------------------------
oc$ybirth <- cal.yr(oc$birth)
oc$yentry <- cal.yr(oc$entry)
oc$yexit <- cal.yr(oc$exit)


## ----age.yr, echo=TRUE--------------------------------------------------------
oc$agentry <- oc$yentry - oc$ybirth
oc$agexit <- oc$yexit - oc$ybirth


## ----oclexis, echo=TRUE-------------------------------------------------------
oc.lex <- Lexis(
  entry = list(
    per = yentry,
    age = yentry - ybirth
  ),
  exit = list(per = yexit),
  exit.status = chdeath,
  id = id, data = oc
)
str(oc.lex)
summary(oc.lex)


## ----plotlexis, echo=TRUE, fig = FALSE----------------------------------------
par(mfrow = c(1, 1))
plot(oc.lex, xlim = c(1990, 2010), grid = TRUE)
points(oc.lex, pch = c(NA, 16)[oc.lex$lex.Xst + 1])


## ----plotlexage, echo=TRUE, fig=FALSE-----------------------------------------
oc.ord <- cbind(ID = 1:1501, oc[order(oc$agexit, oc$agentry), ])
oc.lexord <- Lexis(
  entry = list(age = agentry),
  exit = list(age = agexit),
  exit.status = chdeath,
  id = ID, data = oc.ord
)
plot(oc.lexord, "age")
points(oc.lexord, pch = ifelse(oc.lexord$lex.Xst == 1, 16, NA))
with(
  subset(oc.lexord, lex.Xst == 1),
  abline(v = agexit, lty = 3)
)


## ----plotlexage2, echo=TRUE, fig=FALSE----------------------------------------
plot(oc.lexord, "age", xlim = c(50, 58), ylim = c(5, 65))
points(
  oc.lexord, "age", pch = ifelse(oc.lexord$lex.Xst == 1, 16, NA)
)
with(
  subset(oc.lexord, lex.Xst == 1),
  abline(v = agexit, lty = 3)
)


## ----agentry2, echo=TRUE------------------------------------------------------
oc.lex$agen2 <- cut(oc.lex$agentry, br = seq(40, 62, 1))


## ----risksetsample, echo=TRUE-------------------------------------------------
set.seed(98623)
cactrl <-
  ccwc(
    entry = agentry, exit = agexit, fail = chdeath,
    controls = 2, match = agen2,
    include = list(id, agentry),
    data = oc.lex, silent = FALSE
  )
str(cactrl)


## ----ocX, echo=TRUE-----------------------------------------------------------
ocX <- 
  read.table(
    paste(url, "occoh-Xdata.txt", sep = "/"), header = TRUE
  )
str(ocX)


## ----merge, echo=TRUE---------------------------------------------------------
oc.ncc <- merge(cactrl, ocX[, c("id", "smok", "tchol", "sbp")],
  by = "id"
)
str(oc.ncc)


## ----factor smol, echo=TRUE---------------------------------------------------
oc.ncc$smok <- factor(oc.ncc$smok,
  labels = c("never", "ex", "1-14/d", ">14/d")
)


## ----cccrude smok, echo=TRUE--------------------------------------------------
stat.table(
  index = list(smok, Fail),
  contents = list(count(), percent(smok)),
  margins = TRUE, 
  data = oc.ncc
)
smok.crncc <- glm(Fail ~ smok, family = binomial, data = oc.ncc)
round(ci.exp(smok.crncc), 3)


## ----clogit , echo=TRUE-------------------------------------------------------
m.clogit <- clogit(Fail ~ smok + I(sbp / 10) + tchol +
  strata(Set), data = oc.ncc)
summary(m.clogit)
round(ci.exp(m.clogit), 3)


## ----subc sample, echo=TRUE---------------------------------------------------
N <- 1501
n <- 260
set.seed(15792)
subcids <- sample(N, n)
oc.lexord$subcind <- 1 * (oc.lexord$id %in% subcids)


## ----casecoh data, echo=TRUE--------------------------------------------------
oc.cc <- subset(oc.lexord, subcind == 1 | chdeath == 1)
oc.cc <- merge(oc.cc, ocX[, c("id", "smok", "tchol", "sbp")],
  by = "id"
)
str(oc.cc)


## ----casecoh-lines, echo=TRUE, fig=FALSE--------------------------------------
plot(subset(oc.cc, chdeath == 0), "age")
lines(subset(oc.cc, chdeath == 1 & subcind == 1), col = "blue")
lines(subset(oc.cc, chdeath == 1 & subcind == 0), col = "red")
points(subset(oc.cc, chdeath == 1),
  pch = 16,
  col = c("blue", "red")[oc.cc$subcind + 1]
)


## ----grouping , echo=TRUE-----------------------------------------------------
oc.cc$smok <- factor(oc.cc$smok,
  labels = c("never", "ex", "1-14/d", ">14/d")
)


## ----cc-crude HR by smok------------------------------------------------------
sm.cc <- stat.table(
  index = smok,
  contents = list(Cases = sum(lex.Xst), Pyrs = sum(lex.dur)),
  margins = TRUE, 
  data = oc.cc
)
print(sm.cc, digits = c(sum = 0, ratio = 1))
HRcc <- 
  (sm.cc[1, -5] / sm.cc[1, 1]) / (sm.cc[2, -5] / sm.cc[2, 1])
round(HRcc, 3)


## ----weighted cox LinYing, echo=TRUE------------------------------------------
oc.cc$survobj <- with(oc.cc, Surv(agentry, agexit, chdeath))
cch.LY <- cch(survobj ~ smok + I(sbp / 10) + tchol,
  stratum = NULL,
  subcoh = ~subcind, id = ~id, cohort.size = N, data = oc.cc,
  method = "LinYing"
)
summary(cch.LY)


## ----fullcoh, echo=TRUE-------------------------------------------------------
oc.full <- merge(oc.lex, ocX[, c("id", "smok", "tchol", "sbp")],
  by.x = "id", by.y = "id"
)
oc.full$smok <- factor(oc.full$smok,
  labels = c("never", "ex", "1-14/d", ">14/d")
)


## ----cox-crude HR by smok-----------------------------------------------------
sm.coh <- stat.table(
  index = smok,
  contents = list(Cases = sum(lex.Xst), Pyrs = sum(lex.dur)),
  margins = TRUE, 
  data = oc.full
)
print(sm.coh, digits = c(sum = 0, ratio = 1))
HRcoh <- 
  (sm.coh[1, -5] / sm.coh[1, 1]) / (sm.coh[2, -5] / sm.coh[2, 1])
round(HRcoh, 3)


## ----cox full, echo=TRUE------------------------------------------------------
cox.coh <- coxph(Surv(agentry, agexit, chdeath) ~
  smok + I(sbp / 10) + tchol, data = oc.full)
summary(cox.coh)


## ----comparison, echo=TRUE----------------------------------------------------
betas <- cbind(coef(cox.coh), coef(m.clogit), coef(cch.LY))
colnames(betas) <- c("coh", "ncc", "cch.LY")
round(betas, 3)

SEs <- cbind(
  sqrt(diag(cox.coh$var)),
  sqrt(diag(m.clogit$var)),
  sqrt(diag(cch.LY$var))
)
colnames(SEs) <- colnames(betas)
round(SEs, 3)

