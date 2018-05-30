library(Ecdat)
data(CRANpackages)
png(file="cran.png", width=6, height=6, units="in", res=100)
yticks <- c(100, 200, 500, 1000, 2000, 5000)
plot(log(Packages) ~ Date, data=CRANpackages, yaxt="n",
     ylab="Number of packages", pch=20)
axis(side=2, at=log(yticks), labels=yticks, las=TRUE)
lm.fit <- lm(log(Packages) ~ Date, subset=Date < as.Date("2010-01-01"),
             data=CRANpackages)
abline(lm.fit)
dev.off()
