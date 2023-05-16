k <- 1

x <- seq(from=-1, to=1, by=0.01)

y1 <- x
y2 <- x + 0.5 * (x^2 - 1)
y3 <- x + 0.5 * (-(x^3) + x)


par(bg="lightgrey")
plot(x,y1, type="l", xaxt="n", yaxt="n", xlab="dose", ylab="response")
lines(x,y2)
lines(x,y3)

Npal <- 50
delta.range <- range(c(diff(y1)^k, diff(y2)^k, diff(y3)^k))
bk <- seq(from=delta.range[1], to=delta.range[2], length=Npal)


library(viridis)
pal <- viridis(Npal)

N <- length(x)


seg.viridis <- function(y, ...)
{
    delta <- cut(diff(y)^k, bk, include.lowest=TRUE, label=FALSE)
    segments(x[-N], y[-N], x[-1], y[-1], col= pal[delta], ...)
}
lwd <- 5
seg.viridis(y1, lwd=lwd)
seg.viridis(y2, lwd=lwd)
seg.viridis(y3, lwd=lwd)

yleg <- seq(from=0, to=1, length=Npal+1)
for (i in 1:Npal) {
    polygon(c(-1, -0.75, -0.75, -1), c(yleg[i], yleg[i], yleg[i+1], yleg[i+1]),
            border=NA, col=pal[i])
}
text(-0.75, 0, "low", adj=c(0,0), cex=2)
text(-0.75, 1, "high", adj=c(0,1), cex=2)
###legend("topleft", col=pal, legend=
