x <- c(-2,-1, 0, 1, 2)
y <- x
N <- length(x)
LIM <- 4

png("extrap1.png")
plot(x,y, xlim=c(-LIM, LIM), ylim=c(-LIM,LIM), xaxt="n", yaxt="n",
     xlab="dose x", ylab="response f(x)", cex.lab=1.5, pch=16)
dev.off()

png("extrap2.png")
plot(x,y, xlim=c(-LIM, LIM), ylim=c(-LIM,LIM), xaxt="n", yaxt="n",
     xlab="dose x", ylab="response f(x)", cex.lab=1.5, pch=16)
title("Linear interpolation")
lines(x,y)
dev.off()

png("extrap3.png")
plot(x,y, xlim=c(-LIM, LIM), ylim=c(-LIM,LIM), xaxt="n", yaxt="n",
     xlab="dose x", ylab="response f(x)", cex.lab=1.5, pch=16)
title("Extrapolation - not what we want")
lines(x,y)
segments(-LIM, y[1], x[1], y[1])
segments(x[N], y[N], LIM, y[N])
dev.off()

png("extrap4.png")
plot(x,y, xlim=c(-LIM, LIM), ylim=c(-LIM,LIM), xaxt="n", yaxt="n",
     xlab="dose x", ylab="response f(x)", cex.lab=1.5, pch=16)
title("We want this")
abline(0,1)
dev.off()
