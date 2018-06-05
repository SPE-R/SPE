library(cranlogs)
N <- 20
x <- cran_top_downloads("last-month", N)
x <- x[N:1,]

##Identify which packages are in the tidyverse
tidyverse.imports <- available.packages()["tidyverse","Imports"]
in.tidyverse <- logical(N)
for (i in 1:N) {
    in.tidyverse[i] <- grepl(x$package[i], tidyverse.imports)
}

pch <- 19
x$count <- x$count/1000
png("top20-cran.png", width=6, height=6, units="in", res=100)
dotchart(x$count, x$package,
         col=ifelse(in.tidyverse, "blue", "black"),
         xlab=paste("Downloads", format(Sys.time(), "%b %Y"), "(thousands)"),
         pch=pch, fg="yellow", xlim=c(0, max(x$count)))
legend("bottomright", col=c("blue","black"), pch=pch,
       legend=c("Tidyverse", "other"), bg="white")
title("Top 20 packages by downloads")
dev.off()

png("top100-cran.png", width=6, height=6, units="in", res=100)
y <- cran_top_downloads("last-month", 100)
plot(y$count/1000, type="h", ylim=c(0, max(y$count/1000)), lwd=2,
     ylab="Downloads (thousands)", xlab="rank")
title("Top 100 packages by downloads")
dev.off()
