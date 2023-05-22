### R code from vignette source '/home/runner/work/SPE/SPE/build/graph-intro-s.rnw'

###################################################
### code chunk number 1: graph-intro-s.rnw:21-24
###################################################
library( Epi )
data( births )
str( births )


###################################################
### code chunk number 2: graph-intro-s.rnw:27-28
###################################################
hist(births$bweight)


###################################################
### code chunk number 3: graph-intro-s.rnw:31-32 (eval = FALSE)
###################################################
## help(hist)


###################################################
### code chunk number 4: graph-intro-s.rnw:35-36
###################################################
hist(births$bweight, col="gray", border="white")


###################################################
### code chunk number 5: graph-intro-s.rnw:39-40
###################################################
with(births, plot(gestwks, bweight))


###################################################
### code chunk number 6: graph-intro-s.rnw:44-45
###################################################
plot(1:25, pch=1:25)


###################################################
### code chunk number 7: graph-intro-s.rnw:50-51
###################################################
with(births, plot(matage, bweight) )


###################################################
### code chunk number 8: graph-intro-s.rnw:54-55
###################################################
with(births, plot(matage, bweight, xlab="Maternal age", ylab="Birth weight (g)") )


###################################################
### code chunk number 9: graph-intro-s.rnw:65-66
###################################################
with(births, plot(gestwks, bweight, pch=16, col="green") )


###################################################
### code chunk number 10: graph-intro-s.rnw:72-73
###################################################
with(births, points(gestwks, bweight, pch=1) )


###################################################
### code chunk number 11: graph-intro-s.rnw:86-87
###################################################
with(births, plot(gestwks, bweight, type="n"))


###################################################
### code chunk number 12: graph-intro-s.rnw:90-92
###################################################
with(births, points(gestwks[sex==1], bweight[sex==1], col="blue"))
with(births, points(gestwks[sex==2], bweight[sex==2], col="red"))


###################################################
### code chunk number 13: graph-intro-s.rnw:96-97
###################################################
legend("topleft", pch=1, legend=c("Boys","Girls"), col=c("blue","red"))


###################################################
### code chunk number 14: graph-intro-s.rnw:102-103
###################################################
title("Birth weight vs gestational weeks in 500 singleton births")


###################################################
### code chunk number 15: graph-intro-s.rnw:122-124
###################################################
c("blue","red")
births$sex


###################################################
### code chunk number 16: graph-intro-s.rnw:127-128
###################################################
c("blue","red")[births$sex]


###################################################
### code chunk number 17: graph-intro-s.rnw:135-136
###################################################
with(births, plot( gestwks, bweight, pch=16, col=c("blue","red")[sex]) )


###################################################
### code chunk number 18: graph-intro-s.rnw:140-141
###################################################
births$oldmum <- ( births$matage >= 40 ) + 1


###################################################
### code chunk number 19: graph-intro-s.rnw:146-147
###################################################
with(births, plot( gestwks, bweight, pch=c(16,3)[oldmum], col=c("blue","red")[sex] ))


###################################################
### code chunk number 20: graph-intro-s.rnw:155-156
###################################################
with(births, plot( gestwks, bweight, pch=c(16,3)[(matage>=40 )+1], col=c("blue","red")[sex] ))


###################################################
### code chunk number 21: graph-intro-s.rnw:172-173
###################################################
rainbow(4)


###################################################
### code chunk number 22: graph-intro-s.rnw:185-187
###################################################
plot( 0:10, pch=16, cex=3, col=gray(0:10/10) )
points( 0:10, pch=1, cex=3 )


###################################################
### code chunk number 23: graph-intro-s.rnw:198-202 (eval = FALSE)
###################################################
## pdf(file="bweight_gwks.pdf", height=4, width=4)
## with(births, plot( gestwks, bweight, col=c("blue","red")[sex]) )
## legend("topleft", pch=1, legend=c("Boys","Girls"), col=c("blue","red"))
## dev.off()


###################################################
### code chunk number 24: graph-intro-s.rnw:220-221 (eval = FALSE)
###################################################
## help(par)


###################################################
### code chunk number 25: graph-intro-s.rnw:239-240
###################################################
par( mfrow=c(2,3) )


###################################################
### code chunk number 26: graph-intro-s.rnw:248-249
###################################################
par(mfrow=c(1,1))


###################################################
### code chunk number 27: graph-intro-s.rnw:264-265
###################################################
with(births, plot(gestwks, bweight,  col = c("blue", "red")[sex]) )


###################################################
### code chunk number 28: graph-intro-s.rnw:268-269 (eval = FALSE)
###################################################
## legend(locator(1), pch=1, legend=c("Boys","Girls"), col=c("blue","red") )


###################################################
### code chunk number 29: graph-intro-s.rnw:274-275 (eval = FALSE)
###################################################
## with(births, identify(gestwks, bweight))


###################################################
### code chunk number 30: graph-intro-s.rnw:288-289 (eval = FALSE)
###################################################
## with(births, births[identify(gestwks, bweight), ])


