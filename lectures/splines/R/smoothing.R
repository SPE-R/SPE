set.seed(3136)
x <- 1:20
N <- length(x)

y <- 0.1 * x + rnorm(N, sd=1)

png("smooth1.png")
plot(x,y, xlab="dose", ylab="response", xaxt="n", yaxt="n", cex.lab=1.5,
     pch=16)
library(splines)
isp <- interpSpline(x, y)
z <- seq(from=1, to=N, length=101)
lines(predict(isp, z))
title("Perfect fit")
dev.off()

png("smooth2.png")
plot(x,y, xlab="dose", ylab="response", xaxt="n", yaxt="n", cex.lab=1.5,
     pch=16)
lm.out <- lm(y ~ x)
abline(lm.out)
yhat <- fitted(lm.out)
segments(x, yhat, x, y, col="grey")
title("Perfectly smooth")
dev.off()
