x <- read.table("top-cran.csv", header=TRUE, sep=",", as.is=FALSE)
N <- nrow(x)
x <- x[N:1,]
pch <- 19
png("top-cran.png", width=6, height=6, units="in", res=100)
dotchart(x$downloads/1000, x$name,
         col=c(hadley="blue",graphics="red",other="black")[x$type],
         xlab="Downloads Jan-May 2015 (thousands)", pch=pch, fg="yellow",
         xlim=c(0, 800))
legend("bottomright", col=c("red","blue", "black"), pch=pch,
       legend=c("Hadleyverse", "graphics", "other"), bg="white")
dev.off()
