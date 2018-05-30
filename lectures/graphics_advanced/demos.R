
#### Intro ####

### demo I.1

2+2
log(10)
help(log)
summary(airquality)
demo(graphics) # pretty pictures...


### demo I.2 ###

x <- round(rnorm(10,mean=20,sd=5)) # simulate data
x
mean(x)
m <- mean(x)
m
x - m # notice recycling
(x - m)^2
sum((x - m)^2)
sqrt(sum((x - m)^2)/9)
sd(x)

### demo I.3 ###

## names etc.

x <- c(boys = 1.2, girls = 1.1)
x
names(x)
names(x) <- c("M", "F")
x
matrix(1:4,ncol=2)
cbind(x=0:3,"exp(x)"=exp(0:3))

### demo I.4 ###
## factors
aq <- airquality
aq$Month <- factor(aq$Month, levels=5:9, labels=month.name[5:9])
aq$Month
levels(aq$Month) <- month.abb[5:9]
aq$Month

### demo I.5 ###
## cut
library(ISwR); data(juul)
age <- subset(juul, age >= 10 & age <= 16)$age
range(age)
agegr <- cut(age, seq(10,16,2), right=FALSE, include.lowest=TRUE)
length(age)
table(agegr)
agegr2 <- cut(age, seq(10,16,2), right=FALSE)
table(agegr2)

#####---------------------------------------

### demo M.1 ###
aq <- transform(airquality, Month=factor(Month))
fit.aq <- lm(log(Ozone) ~ Solar.R + Wind +
             Temp + Month, data=aq)
fit.aq2 <- update(fit.aq, ~ . - Month)
summary(fit.aq)
par(mfrow=c(2,2)); plot(fit.aq)
drop1(fit.aq, test="F")
anova(fit.aq, fit.aq2)

### demo M.2 ###
no.yes <- c("No","Yes")
smoking <- gl(2, 1, 8, no.yes)
obesity <- gl(2, 2, 8, no.yes)
snoring <- gl(2, 4, 8, no.yes)
n.tot <- c(60,17,8,2,187,85,51,23)
n.hyp <- c(5,2,1,0,35,13,15,8)
data.frame(smoking,obesity,snoring,n.tot,n.hyp)
hyp.tbl <- cbind(hyp=n.hyp,nohyp=n.tot-n.hyp)
hyp.tbl
glm.hyp <- glm(hyp.tbl~smoking+obesity+snoring,
               family=binomial("logit"))
summary(glm.hyp)
library(MASS)
confint(glm.hyp)
confint.default(glm.hyp)

#####---------------------------------------

#### Graphics ####

### demo G.1 ###
library(ISwR)
par(mfrow=c(2,2))
matplot(intake)
matplot(t(intake))
matplot(t(intake),type="b")
matplot(t(intake),type="b",pch=1:11,col="black",
        lty="solid", xaxt="n")
axis(1,at=1:2,labels=names(intake))

### demo G.2 ###

dev.off()
x <- runif(50,0,2)
y <- runif(50,0,2)
plot(x, y, main="Main title", sub="subtitle",
     xlab="x-label", ylab="y-label")
text(0.6,0.6,"text at (0.6,0.6)")
abline(h=.6,v=.6)
for (side in 1:4) mtext(-1:4,side=side,at=.7,line=-1:4)
mtext(paste("side",1:4), side=1:4, line=-1,font=2)

### demo G.3 ###

set.seed(70913)
y <- rnorm(25)
curve(dnorm(x, mean(y), sd(y)), from=-3, to=3)
rug(y)
abline(h=0)
substitute(paste(mu==m, "    ", sigma==s),
      list(m=mean(y), s=sd(y)) )

title(main=bquote(paste(mu==.(mean(y)), "    ",
      sigma==.(sd(y)))))


### demo G.4 ###
library(lattice)
dev.off() # don't mix with standard graphics
trellis.par.set(theme = col.whitebg())
myplot <-
  xyplot(log(Ozone)~Solar.R | equal.count(Temp),
         group=Month, data=airquality,
         ylab=list(label=expression("log"*O[3]),cex=2),
          xlab=list(cex=2))
myplot # OBS: no plot until object is printed!
dev.off()

### demo G.4a ###

trellis.par.set(theme = col.whitebg())
xyplot(log(Ozone)~Solar.R | equal.count(Temp),
       group=Month, data=airquality,
       ylab=list(label=expression("log"*O[3]),cex=2),
       xlab=list(cex=2),  panel=function(x,y,...){
           panel.superpose(x,y,...)
           panel.lmline(x,y,type="l")
       }
       )

#### End Graphics ####
