x <- c(0, 1, 2, 4, 4.6, 7)
y <- plogis(x - mean(x))
N <- length(x)

png("dose-response-points.png")
plot(x, y, xaxt="n", yaxt="n", xlab="Dose", ylab="Response", pch=16,
     cex.lab=1.5)
text(x, y+0.02, 1:N)
dev.off()

png("dose-response-linear.png")
plot(x, y, xaxt="n", yaxt="n", xlab="Dose", ylab="Response", pch=16,
     cex.lab=1.5)
lines(x,y)
dev.off()

png("dose-response-cubic.png")
library(splines)
sp <- interpSpline(x,y)
plot(x, y, xaxt="n", yaxt="n", xlab="Dose", ylab="Response", pch=16,
     cex.lab=1.5)
z <- seq(min(x), max(x), length=101)
lines(predict(sp, z))
dev.off()
