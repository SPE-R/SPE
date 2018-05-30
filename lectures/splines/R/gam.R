library(mgcv)
set.seed(2) ## simulate some data... 
dat <- gamSim(1,n=100,dist="normal",scale=2)

b <- gam(y~s(x1), data=dat)
summary(b)
png("gam-points.png")
plot(y ~ x1, data=dat, pch=16, cex=0.5)
title("Some simulated data")
dev.off()

png("gam-7.png")
plot(b,pages=1,residuals=TRUE, pch=16, cex=0.5)  ## show partial residuals
title("A gam fit with default options")
dev.off()

## run some basic model checks, including checking
## smoothing basis dimensions...
gam.check(b)

png("gam-100.png")
bb <- gam(y~s(x1,k=100), data=dat)
plot(bb, residuals=TRUE, pch=16, cex=0.5)
dev.off()

spline.basis <- as.data.frame(model.matrix(b))
glm.out <- glm(dat$y ~ ., data=spline.basis)
x <- seq(from=0, to=1, length=101)
png("gam-nonsmoothed.png")
plot(y ~ x1, data=dat, pch=16, cex=0.5)
ord <- order(dat$x1)
lines(dat$x1[ord], fitted(glm.out)[ord])
dev.off()

