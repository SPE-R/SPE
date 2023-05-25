x <- c(0, 1, 2, 4, 4.6, 7)
y <- plogis(x - mean(x))
N <- length(x)

png("dose-response-points.png")
plot(x, y, xaxt="n", yaxt="n", xlab="Dose x", ylab="Response f(x)", pch=16,
     cex.lab=1.5)
text(x, y+0.02, 1:N)
dev.off()

png("dose-response-linear.png")
plot(x, y, xaxt="n", yaxt="n", xlab="Dose x", ylab="Response f(x)", pch=16,
     cex.lab=1.5)
lines(x,y)
dev.off()

png("dose-response-cubic.png")
library(splines)
sp <- interpSpline(x,y)
plot(x, y, xaxt="n", yaxt="n", xlab="Dose x", ylab="Response f(x)", pch=16,
     cex.lab=1.5)
z <- seq(min(x), max(x), length=101)
lines(predict(sp, z))
dev.off()

### Showing constraints on knots
xx <- c(0, 1, 2, 4)
yy <- plogis(xx - mean(x))
NN <- length(xx)

zz1 <- seq(0, 2, length=101)
zz2 <- seq(2, 4, length=101)
zz2 <- zz2[-1]

png("spline-constraint1.png")
plot(x, y, type="n", xaxt="n", yaxt="n", xlab="Dose x", ylab="Response f(x)", pch=16,
     cex.lab=1.5, xlim=c(0,4), ylim=c(0, 0.6))
title("No jumps")
points(xx[c(1,3)], yy[c(1,3)], pch=16)
sp <- interpSpline(xx, yy)
sp$coefficients[3,1] <- sp$coefficients[3,1] + 0.1
lines(predict(sp, zz1))
lines(predict(sp, zz2))
dev.off()

png("spline-constraint2.png")
plot(x, y, type="n", xaxt="n", yaxt="n", xlab="Dose x", ylab="Response f(x)", pch=16,
     cex.lab=1.5, xlim=c(0,4), ylim=c(0, 0.6))
title("No corners")
points(xx[c(1,3)], yy[c(1,3)], pch=16)
sp <- interpSpline(xx, yy)
sp$coefficients[3,2] <- sp$coefficients[3,2] - 0.3
lines(predict(sp, zz1))
lines(predict(sp, zz2))
dev.off()

png("spline-constraint3.png")
plot(x, y, type="n", xaxt="n", yaxt="n", xlab="Dose x", ylab="Response f(x)", pch=16,
     cex.lab=1.5, xlim=c(0,4), ylim=c(0, 0.6))
title("No sudden changes in curvature")
points(xx[c(1,3)], yy[c(1,3)], pch=16)
sp <- interpSpline(xx, yy)
sp$coefficients[3,3] <- sp$coefficients[3,3] - 0.5
lines(predict(sp, zz1))
lines(predict(sp, zz2))
dev.off()
