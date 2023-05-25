library(viridis)

Npal <- 50

x <- seq(from=-1, to=1, by=0.01)
N <- length(x)

y <- matrix(NA, nrow=N, ncol=3)
y[,1] <- x
y[,2] <- x + 0.5 * (x^2 - 1)
y[,3] <- x + 0.5 * (-(x^3) + x)

pal <- viridis(Npal)

seg.viridis <- function(x, y, z, breaks, ...)
{
    delta <- cut(z, breaks, include.lowest=TRUE, label=FALSE)
    segments(x[-N], y[-N], x[-1], y[-1], col= pal[delta], ...)
}

plot.penalty <- function(x, y, FUN, ...)
{
    matplot(x, y, type="n", xaxt="n", yaxt="n", xlab="dose x", ylab="response f(x)",
            cex.lab=1.5, ...)
    
    z <- apply(y, 2, FUN)
    breaks <- seq(from=0, to=max(z), length=Npal)
    for (i in 1:3) {
        seg.viridis(x, y[,i], z[,i], breaks, lwd=5)
    }
    
    yleg <- seq(from=0, to=1, length=Npal+1)
    for (i in 1:Npal) {
        polygon(c(-1, -0.75, -0.75, -1), c(yleg[i], yleg[i], yleg[i+1], yleg[i+1]),
                border=NA, col=pal[i])
    }
    text(-0.75, 0, "zero", adj=c(0,0), cex=1.5)
    text(-0.75, 1, "max", adj=c(0,1), cex=1.5)
}

png("penalty1.png")
par(bg="lightgrey", mar=c(5,5,4,2)+0.1)
plot.penalty(x, y, FUN= function(y) abs(diff(y)))
title("Visualization of the penalty function", cex.main=1.5)
dev.off()

png("penalty2.png")
par(bg="lightgrey", mar=c(5,5,4,2)+0.1)
plot.penalty(x, y, FUN= function(y) abs(diff(diff(y))))
title("Visualization of the penalty function", cex.main=1.5)
dev.off()
