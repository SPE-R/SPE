# Simple plot on the screen}

data( births )
str( births )

hist(births$bweight)

help(hist)

hist(births$bweight, col="gray", border="white")

with(births, plot(gestwks, bweight))

plot(1:25, pch=1:25)

with(births, plot(matage, bweight) )
with(births, plot(matage, bweight, 
        xlab="Maternal age", ylab="Birth weight (g)") )
with(births, plot(gestwks, bweight, pch=16, 
                  col="green") )
with(births, points(gestwks, bweight, pch=1) )
with(births, plot(gestwks, bweight, type="n"))
with(births, points(gestwks[sex=="M"], bweight[sex=="M"],
                    col="blue"))
with(births, points(gestwks[sex=="F"], bweight[sex=="F"],
                    col="red"))
legend("topleft", pch=1, legend=c("Boys","Girls"),
       col=c("blue","red"))
title("Birth weight vs gestational weeks in 500 singleton births")

with(births, plot( gestwks, bweight, pch=16, col=c("blue","red")[sex]) )

births$oldmum <- ( births$matage >= 40 ) + 1
with(births, plot( gestwks, bweight,
      pch=c(16,3)[oldmum], col=c("blue","red")[sex] ))

with(births, plot( gestwks, bweight, pch=c(16,3)[(matage>=40 )+1], col=c("blue","red")[sex] ))

plot( 0:10, pch=16, cex=3, col=gray(0:10/10) )
points( 0:10, pch=1, cex=3 )


pdf(file="bweight_gwks.pdf", height=4, width=4)
with(births, plot( gestwks, bweight, col=c("blue","red")[sex]) )
legend("topleft", pch=1, legend=c("Boys","Girls"), col=c("blue","red"))
dev.off()
