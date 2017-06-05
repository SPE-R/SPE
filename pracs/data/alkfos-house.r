#alkfos<-read.csv("alkfos.csv")
alkfos.pctchange<-(sweep(alkfos[-1],1,alkfos$c0,"/")-1)*100
available<-aggregate(!is.na(alkfos[-1]),list(alkfos$grp),sum)
means<-aggregate(alkfos.pctchange,list(alkfos$grp),mean,na.rm=T)
sds<-aggregate(alkfos.pctchange,list(alkfos$grp),sd,na.rm=T)
available<-as.matrix(available[-1])
means<-as.matrix(means[-1])
sds<-as.matrix(sds[-1])

sems<-sds/sqrt(available)

times<-c(0,3,6,9,12,18,24)

### Put data in long format in a data frame for ggplot2
ggdata <- data.frame(
    time = rep(times, 2),
    means = c(means[1,], means[2,]),
    sds = c(sds[1,], sds[2,]),
    available = c(available[1,], available[2,]),
    treat = rep(c("placebo","tamoxifen"), each=7)
    )
ggdata <- transform(ggdata, sems = sds/sqrt(available))

