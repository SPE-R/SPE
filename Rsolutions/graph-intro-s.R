## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(results = "markup", debug = FALSE, prefix.string = "./graph/graph-intro")


## -----------------------------------------------------------------------------
library(Epi)
data(births)
str(births)


## -----------------------------------------------------------------------------
hist(births$bweight)


## ----eval=FALSE---------------------------------------------------------------
## help(hist)


## -----------------------------------------------------------------------------
hist(births$bweight, col = "gray", border = "white")


## -----------------------------------------------------------------------------
with(births, plot(gestwks, bweight))


## -----------------------------------------------------------------------------
plot(1:25, pch = 1:25)


## -----------------------------------------------------------------------------
with(births, plot(matage, bweight))


## -----------------------------------------------------------------------------
with(
  births, 
  plot(
    matage, 
    bweight, 
    xlab = "Maternal age", 
    ylab = "Birth weight (g)"
  )
)


## -----------------------------------------------------------------------------
with(births, plot(gestwks, bweight, pch = 16, col = "green"))


## -----------------------------------------------------------------------------
with(births, plot(gestwks, bweight, pch = 16, col = "green"))
with(births, points(gestwks, bweight, pch = 1))


## -----------------------------------------------------------------------------
with(births, plot(gestwks, bweight, type = "n"))
with(
  births, 
  points(gestwks[sex == 1], bweight[sex == 1], col = "blue")
)
with(
  births, 
  points(gestwks[sex == 2], bweight[sex == 2], col = "red")
)


## -----------------------------------------------------------------------------
with(births, plot(gestwks, bweight, type = "n"))
with(
  births, 
  points(gestwks[sex == 1], bweight[sex == 1], col = "blue")
)
with(
  births, 
  points(gestwks[sex == 2], bweight[sex == 2], col = "red")
)
legend(
  "topleft", 
  pch = 1, 
  legend = c("Boys", "Girls"), 
  col = c("blue", "red")
)


## -----------------------------------------------------------------------------
with(births, plot(gestwks, bweight, type = "n"))
with(
  births, 
  points(gestwks[sex == 1], bweight[sex == 1], col = "blue")
)
with(
  births, 
  points(gestwks[sex == 2], bweight[sex == 2], col = "red")
)
legend(
  "topleft", 
  pch = 1, 
  legend = c("Boys", "Girls"), 
  col = c("blue", "red")
)
title(
  "Birth weight vs gestational weeks in 500 singleton births"
)


## -----------------------------------------------------------------------------
c("blue", "red")
births$sex


## -----------------------------------------------------------------------------
c("blue", "red")[births$sex]


## -----------------------------------------------------------------------------
with(
  births, 
  plot(gestwks, bweight, pch = 16, col = c("blue", "red")[sex])
)


## -----------------------------------------------------------------------------
births$oldmum <- (births$matage >= 40) + 1


## -----------------------------------------------------------------------------
with(
  births, 
  plot(
    gestwks, 
    bweight, 
    pch = c(16, 3)[oldmum], 
    col = c("blue", "red")[sex]
  )
)


## -----------------------------------------------------------------------------
with(
  births, 
  plot(
    gestwks, 
    bweight, 
    pch = c(16, 3)[(matage >= 40) + 1], 
    col = c("blue", "red")[sex]
  )
)


## -----------------------------------------------------------------------------
rainbow(4)


## -----------------------------------------------------------------------------
plot(0:10, pch = 16, cex = 3, col = gray(0:10 / 10))
points(0:10, pch = 1, cex = 3)


## ----eval=FALSE---------------------------------------------------------------
## pdf(file = "bweight_gwks.pdf", height = 4, width = 4)
## with(births, plot(gestwks, bweight, col = c("blue", "red")[sex]))
## legend(
##   "topleft",
##   pch = 1,
##   legend = c("Boys", "Girls"),
##   col = c("blue", "red")
## )
## dev.off()


## ----eval=FALSE---------------------------------------------------------------
## help(par)


## -----------------------------------------------------------------------------
par(mfrow = c(2, 3))


## -----------------------------------------------------------------------------
par(mfrow = c(1, 1))


## -----------------------------------------------------------------------------
with(births, plot(gestwks, bweight, col = c("blue", "red")[sex]))


## ----eval=FALSE---------------------------------------------------------------
## legend(
##   locator(1),
##   pch = 1,
##   legend = c("Boys", "Girls"),
##   col = c("blue", "red")
## )


## ----eval=FALSE---------------------------------------------------------------
## with(births, identify(gestwks, bweight))


## ----eval=FALSE---------------------------------------------------------------
## with(births, births[identify(gestwks, bweight), ])

