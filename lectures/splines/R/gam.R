library(mgcv)
set.seed(2) ## simulate some data... 
dat <- gamSim(1,n=100,dist="normal",scale=2)
dat <- dat[order(dat$x1),]

b <- gam(y~s(x1), data=dat)
summary(b)
png("gam-points.png")
plot(y ~ x1, data=dat, pch=16, cex=0.5)
title("Some simulated data")
dev.off()

png("gam-7.png")
plot(b, pages=1, residuals=TRUE, pch=16, cex=0.5, rug=FALSE,
     shade.col=scales::alpha("lightblue", 0.5),
     scheme=1, main="A gam fit with default options")
dev.off()

## run some basic model checks, including checking
## smoothing basis dimensions...
gam.check(b)

png("gam-100.png")
bb <- gam(y~s(x1,k=100), data=dat)
plot(bb, residuals=TRUE, pch=16, cex=0.5)
dev.off()

plotfit <- function(model) {
    fit <- predict(model, se.fit=TRUE)
    lower <- fit$fit - fit$se.fit
    upper <- fit$fit + fit$se.fit
    polygon(x=c(dat$x1, rev(dat$x1)), y=c(lower, rev(upper)),
            col=scales::alpha("lightblue", 0.5), border="lightblue")
    lines(dat$x1, fit$fit, col="darkblue")
}

spline.basis <- as.data.frame(model.matrix(b))
dat2 <- dat
dat2$y <- dat2$y - mean(dat2$y)
glm.out <- glm(dat2$y ~ 0 + ., data=spline.basis)
x <- seq(from=0, to=1, length=101)
png("gam-nonsmoothed.png")
plot(y ~ x1, data=dat2, pch=16, cex=0.5, ylab="s(x1, 9)", main="An unpenalized spline fit")
plotfit(glm.out)
dev.off()

