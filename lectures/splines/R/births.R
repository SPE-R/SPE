library(Epi)
library(scales)


calfit <- function(model) {
    fit <- predict(model, se.fit=TRUE)
    fit$lower <- fit$fit - fit$se.fit
    fit$upper <- fit$fit + fit$se.fit
}

calterm <- function(gestwks) {
    cut(gestwks,
        breaks=c(0, 37, 39, 41, 42, Inf),
        labels=c("preterm", "early term", "full term", "late term",
                 "post term"),
        right=FALSE)
}

calterm2 <- function(gestwks) {
    cut(gestwks,
        breaks=c(0, 28, 32.42, 37, 39, 41, 42, Inf),
        labels=c("early preterm", "very preterm", "moderate-late preterm",
                 "early term", "full term", "late term", "post term"),
        right=FALSE)
}

newdata <- data.frame(gestwks = seq(from=min(births$gestwks), to=max(births$gestwks), length=1001))
newdata$term <- calterm(newdata$gestwks)
newdata$term2 <- calterm2(newdata$gestwks)
                      
plotfit <- function(model) {
    fit <- predict(model, newdata=newdata, se.fit=TRUE)
    lower <- fit$fit - fit$se.fit
    upper <- fit$fit + fit$se.fit
    polygon(x=c(newdata$gestwks, rev(newdata$gestwks)), y=c(lower, rev(upper)),
            col=scales::alpha("lightblue", 0.5), border="lightblue")
    lines(newdata$gestwks, fit$fit, col="darkblue")
}

data(births)
births <- na.omit(births)
births <- births[order(births$gestwks),]
births$term <- calterm(births$gestwks)
births$term2 <- calterm2(births$gestwks)

### Linear model
lm.linear <- lm(bweight ~ gestwks, data=births)
plot(bweight ~ gestwks, data=births,
     xlab="Gestation weeks", ylab="Birth weight (g)",
     col=grey(0.5))
plotfit(lm.linear)

## Polynomial model
lm.poly <- lm(bweight ~ poly(gestwks,3), data=births)
plot(bweight ~ gestwks, data=births,
     xlab="Gestation weeks", ylab="Birth weight (g)",
     col=grey(0.5))
plotfit(lm.poly)

## Stepwise model
lm.step <- glm(bweight ~ term, data=births)
plot(bweight ~ gestwks, data=births,
     xlab="Gestation weeks", ylab="Birth weight (g)",
     col=grey(0.5))
plotfit(lm.step)

## Stepwise model
lm.step2 <- glm(bweight ~ term2, data=births)
plot(bweight ~ gestwks, data=births,
     xlab="Gestation weeks", ylab="Birth weight (g)",
     col=grey(0.5))
plotfit(lm.step2)

## GAM
library(mgcv)
gam.out <- gam(bweight ~ s(gestwks), data=births)
plot(bweight ~ gestwks, data=births,
     xlab="Gestation weeks", ylab="Birth weight (g)",
     col=grey(0.5))
plotfit(gam.out)

