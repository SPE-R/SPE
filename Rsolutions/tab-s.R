## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(results = "markup", prefix.string = "./graph/tab")


## ----Looking at births data b-------------------------------------------------
library(Epi)
data(births)
names(births)
head(births)


## -----------------------------------------------------------------------------
births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
births$sex <- factor(births$sex, labels = c("M", "F"))
births$agegrp <- 
  cut(
    births$matage, 
    breaks = c(20, 25, 30, 35, 40, 45), 
    right = FALSE
  )
births$gest4 <- 
  cut(
    births$gestwks, 
    breaks = c(20, 35, 37, 39, 45), 
    right = FALSE
  )


## ----sex1---------------------------------------------------------------------
stat.table(index = sex, data = births)


## ----sex2---------------------------------------------------------------------
stat.table(
  index = sex, 
  contents = list(count(), percent(sex)), 
  data = births
)


## ----sex3, echo=F-------------------------------------------------------------
stat.table(
  index = sex, contents = list(count(), percent(sex)),
  margin = TRUE, data = births
)


## ----bwsex1-------------------------------------------------------------------
stat.table(index = sex, contents = mean(bweight), data = births)


## ----bwsex2, echo=FALSE-------------------------------------------------------
stat.table(
  index = sex, contents = list(count(), mean(bweight)),
  margin = TRUE, data = births
)


## ----lowbwsex1----------------------------------------------------------------
stat.table(index = sex, contents = percent(lowbw), data = births)


## ----lowbwsex2----------------------------------------------------------------
stat.table(
  index = list(sex, lowbw), 
  contents = percent(lowbw), 
  data = births
)


## ----exercise on tables, echo=F-----------------------------------------------
stat.table(index = gest4, contents = count(), data = births)
stat.table(index = gest4, contents = mean(bweight), data = births)
stat.table(
  index = list(lowbw, gest4), 
  contents = percent(lowbw), 
  data = births
)


## ----ratio--------------------------------------------------------------------
stat.table(gest4, ratio(lowbw, 1, 100), data = births)


## ----tagged-------------------------------------------------------------------
stat.table(gest4, contents = list(
  N = count(),
  "(%)" = percent(gest4)
), data = births)


## ----named--------------------------------------------------------------------
stat.table(index = list("Gestation time" = gest4), data = births)


## ----twoway-------------------------------------------------------------------
stat.table(
  list(sex, hyp), 
  contents = mean(bweight), 
  data = births
)


## ----twoway2, echo=F----------------------------------------------------------
stat.table(list(sex, hyp),
  contents = list(count(), mean(bweight)),
  margin = TRUE, 
  data = births
)


## ----two way tables exc, echo=F-----------------------------------------------
stat.table(list(sex, hyp), contents = list(count(), mean(bweight)), margin = TRUE, data = births)
stat.table(list(sex, hyp), contents = list(count(), ratio(lowbw, 1, 100)), margin = TRUE, data = births)


## ----printing1----------------------------------------------------------------
odds.tab <- 
  stat.table(
    gest4, 
    list("odds of low bw" = ratio(lowbw, 1 - lowbw)),
    data = births
)
print(odds.tab)


## ----printing2, echo=F--------------------------------------------------------
print(odds.tab, width = 15, digits = 3)

